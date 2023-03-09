library(terra)
library(geodata)
countyname = 'Yolo'
setwd("/Volumes/KYRADRIVE/floodproject")
 flcounty <- function(countyname) {
  
  fldfiname <- "femadata/NFHL_06_20230220.zip"
  if (!file.exists(fldfiname)){
    dir.create("femadata")
    download.file("https://hazards.fema.gov/nfhlv2/output/State/NFHL_06_20230220.zip",
                  destfile= fldfiname,mode = "wb")
    file <- unzip(list.files("./femadata"), exdir = "./femadata")
  }
  clname <- tolower(countyname)
  fldrds <- paste0(clname,"flood.rds")
  if (!file.exists(fldrds)) {
  floodarea <- terra::vect('./femadata/NFHL_06_20230220/NFHL_06_20230220.gdb',layer = "S_FLD_HAZ_AR")
  usa  = geodata::gadm("USA", level=2, path=".")
  county_idx <- grep(paste0(clname, collapse="|"), tolower(usa$NAME_2))
  
  if (length(county_idx) == 0) {
    stop(paste("County", countyname, "not found in USA shapefile"))
  } else if (length(county_idx) > 1) {
    warning(paste("Multiple matches found for county", countyname))
  }
  
  county <- usa[county_idx, ]  
  
  floodcounty = terra::crop(floodarea, county)
  saveRDS(floodcounty, fldrds)}
  
  
  landname <- "./landdata/i15_Crop_Mapping_2019.zip"
  if (!file.exists(landname)){
    dir.create("landdata")
    url2<- "https://data.cnra.ca.gov/dataset/6c3d65e3-35bb-49e1-a51e-49d5a2cf09a9/resource/1da7b37a-dd97-4b69-a86a-fe824a252eaf/download/i15_crop_mapping_2019.zip"
    download.file(url2,
                  destfile= landname,mode = "wb")
    unzip("./landdata/i15_Crop_Mapping_2019.zip")
    #landuse <- vect(usefiles[7])
  } 
  lu_rds <- paste0(countyname,"landu.rds")
  if (!file.exists(lu_rds)) {
    usa  = geodata::gadm("USA", level=2, path=".")
    county = usa[usa$NAME_2 == countyname, ]
    usefiles <-unzip("./landdata/i15_Crop_Mapping_2019.zip", list=TRUE)
    landuse <- terra::vect(usefiles$Name[8])
    lu_county = terra::crop(landuse, county)
    saveRDS(lu_county, lu_rds)
  }
 }

flcounty('yolo')
