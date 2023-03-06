#setwd("/Volumes/KYRADRIVE/floodproject") #kyra mac wd
setwd("F:/floodproject") #kyra windows wd

library(terra)

# fldfiname <- "femadata/NFHL_06_20230220.zip"
# if (!file.exists(fldfiname)){
# dir.create("femadata")
#  download.file("https://hazards.fema.gov/nfhlv2/output/State/NFHL_06_20230220.zip",
#                destfile= fldfiname,mode = "wb")
#  file <- unzip(list.files("./femadata"), exdir = "./femadata")}

url2 <- "https://data.cnra.ca.gov/dataset/6c3d65e3-35bb-49e1-a51e-49d5a2cf09a9/resource/1da7b37a-dd97-4b69-a86a-fe824a252eaf/download/i15_crop_mapping_2019.zip"
landname <- "./landdata/i15_Crop_Mapping_2019.zip"
if (!file.exists(landname)){
dir.create("landdata")
 download.file(url2,
               destfile= landname,mode = "wb")
usefiles <-unzip("./landdata/i15_Crop_Mapping_2019.zip")
landuse <- vect(usefiles[7])
} else {usefiles <-unzip("./landdata/i15_Crop_Mapping_2019.zip")
landuse <- vect(usefiles[7])}

#msc.fema.gov/portal/downloadProduct?productTypeID=NFHL&productSubTypeID=NFHL_STATE_DATA&productID=NFHL_06_20230220.zip",#https://
#source: https://www.fema.gov/flood-maps/national-flood-hazard-layer
#https://hazards.fema.gov/nfhlv2/output/State/NFHL_06_20230121.zip
floodarea <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_AR")
floodbound <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_LN")
#making sense of and organizing fema data
names(floodarea)
# names(floodbound)<-c( "DFIRM_ID","VERSION_ID","FLD_AR_ID","STUDY_TYP",  "FLD_ZONE",   
# "ZONE_SUBTY","SFHA_TF","STATIC_BFE","V_DATUM","DEPTH", 
# "LEN_UNIT", "VELOCITY", "VEL_UNIT", "AR_REVERT","AR_SUBTRV",   
#  "BFE_REVERT",   "DEP_REVERT",   "DUAL_ZONE",    "SOURCE_CIT",   "GFID",        
# "SHAPE_Length", "SHAPE_Area")
subtypes<- unique(floodarea$ZONE_SUBTY) #special floodzones

zonetypes<- unique(floodarea$FLD_ZONE) #zone types, see explanations below
# HIGH-RISK AREAS: ALSO KNOWN AS THE SPECIAL FLOOD HAZARD AREA

# ZONE A Area inundated by the Base Flood with no Base Flood Elevations determined.
# ZONE AE Area inundated by the Base Flood with Base Flood Elevations determined.
# ZONE AH Area inundated by the Base Flood with flood depths of 1 to 3 feet 
#(usually areas of ponding); Base Flood Elevations determined.
# ZONE AO Area inundated by the Base Flood with flood depths of 1 to 3 feet
#(usually sheet flow on sloping terrain); average depths determined. For areas of alluvial fan flooding,
# velocities are also determined.
# ZONE V Coastal flood zone with velocity hazard (wave action); no Base Flood Elevations
# determined.
# ZONE VE Coastal flood zone with velocity hazard (wave action); Base Flood Elevations
# determined

# MODERATE-TO-LOW RISK AREAS: THESE ARE NON-SPECIAL FLOOD HAZARD AREAS
# ZONE X (0.2%) This zone designation is for multiple risks including areas of the 0.2% annual
#         chance flood; areas of the 1% annual chance flood with average depths of less
#         than 1 foot or with drainage areas less than 1 square mile; and areas protected
#         by levees from the 1% annual chance flood.
# ZONE X Areas determined to be outside the 0.2% annual chance floodplain

#ZONE D Areas in which flood hazards are undetermined, but possib

# Zone A99
# Areas with a 1% annual chance of flooding that will be protected by a Federal flood control system where 
# construction has reached specified legal requirements. No depths or base flood elevations are shown within these zones.
# layer names from fema
# 0. NFHL Availability
# 1. LOMRs
# 2. LOMAs
# 3. FIRM Panels
# 4. Base Index
# 5. PLSS
# 6. Toplogical Low Confidence Areas
# 7. River Mile Markers
# 8. Datum Conversion Points
# 9. Coastal Gages
# 10. Gages
# 11. Nodes
# 12. High Water Marks
# 13. Station Start Points
# 14. Cross-Sections
# 15. Coastal Transects
# 16. Base Flood Elevations: the elevation of surface water resulting from has a 1% chance of equaling or exceeding that level in any given year
# 17. Profile Baselines
# 18. Transect Baselines
# 19. Limit of Moderate Wave Action
# 20. Water Lines
# 21. Coastal Barrier Resources System Area
# 22. Political Jurisdictions
# 23. Levees
# 24. General Structures
# 25. Primary Frontal Dunes
# 26. Hydrologic Reaches
# 27. Flood Hazard Boundaries: boundaries of flood, mudflow, and related erosion areas having special hazards have been designated
# 28. Flood Hazard Zones
# 29. Submittal Information
# 30. Alluvial Fans
# 31. Subbasins
# 32. Water Areas
#plot(floodbound)
# sfha = special flood hazard area

#reading in files
# a = list.files("i15_Crop_Mapping_2019",pattern = '.shp$',full.names = 1) 
# landuse<-vect(a)
#names(landuse)

#listing all categories, finding the unique ones, setting all of the crops to ag land
# and U as urban
uses <- landuse$SYMB_CLASS
cats <- unique(uses)
agcats <- cats[1:10]
agind <-  unlist(sapply(agcats,grep,uses,value = 0))

#urbanind<- grep(uses,cats[11],value = 0)
# replacing the values in the column
landuse$SYMB_CLASS[agind]<- "agricultural land"
landuse$SYMB_CLASS[-agind] <- "urban land"

agflood <- intersect(landuse[agind],floodbound)
agflood$SYMB_CLASS
urbflood <- intersect(landuse[-agind],floodbound)
plot(landuse, main = "CA Agricultural Land in Flood Zones")#, add = TRUE)
lines(agflood,col = "blue")


