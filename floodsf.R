#function that allows you to put in any county in California and get landuse data
# and national flood hazard layer for that county and save as rds

library(terra)
library(geodata)
countyname = 'los angeles'
setwd("/Volumes/KYRADRIVE/floodproject")
 flcounty <- function(countyname) {
  #if nfhl does not exist in directory, download from fema
  fldfiname <- "femadata/NFHL_06_20230220.zip"
  if (!file.exists(fldfiname)){
    dir.create("femadata")
    download.file("https://hazards.fema.gov/nfhlv2/output/State/NFHL_06_20230220.zip",
                  destfile= fldfiname,mode = "wb")
    file <- unzip(list.files("./femadata"), exdir = "./femadata")
  }
  # take input county name as lower for string comparison
  clname <- tolower(countyname)
  # create name of rds to be created
  fldrds <- paste0(clname,"flood.rds")
  # if rds for nfhl county does not already exist in directory, create and save
  #checks is county is in california before cropping, also checks for duplicates
  if (!file.exists(fldrds)) {
    usa  = geodata::gadm("USA", level=2, path=".")
    usa = usa[usa$NAME_1=="California"]
    county_idx <- grep(paste0(clname, collapse="|"), tolower(usa$NAME_2))
    # stops is county is not in california
    if (length(county_idx) == 0) {
      stop(paste("County", countyname, "not found in California"))
    } else if (length(county_idx) > 1) {
      warning(paste("Multiple matches found for county", countyname))
    }
    # subsets to county
    county <- usa[county_idx, ]  
    # creating spat vector from nfhl layer
  floodarea <- terra::vect('./femadata/NFHL_06_20230220/NFHL_06_20230220.gdb',
                           layer = "S_FLD_HAZ_AR")
 
  #cropping to county and saving to rds
  floodcounty = terra::crop(floodarea, county)
  saveRDS(floodcounty, fldrds)
  }
  
  # if land use data does not exist in directory, download from CNRA
  landname <- "./landdata/i15_Crop_Mapping_2019.zip"
  if (!file.exists(landname)){
    dir.create("landdata")
    url2<- "https://data.cnra.ca.gov/dataset/6c3d65e3-35bb-49e1-a51e-49d5a2cf09a9/resource/1da7b37a-dd97-4b69-a86a-fe824a252eaf/download/i15_crop_mapping_2019.zip"
    download.file(url2,
                  destfile= landname,mode = "wb")
    unzip("./landdata/i15_Crop_Mapping_2019.zip")
    #landuse <- vect(usefiles[7])
  } 
  # create name of rds to be created
  lu_rds <- paste0(countyname,"landu.rds")
  #if the rds for landuse does not exist for county, crops to county and saves
  if (!file.exists(lu_rds)) {
    usa  = geodata::gadm("USA", level=2, path=".")
    county = usa[usa$NAME_2 == countyname, ]
    usefiles <-unzip("./landdata/i15_Crop_Mapping_2019.zip", list=TRUE)
    landuse <- terra::vect(usefiles$Name[8])
    lu_county = terra::crop(landuse, county)
    saveRDS(lu_county, lu_rds)
  }
 }

flcounty('king county')
