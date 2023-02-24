setwd("/Volumes/KYRADRIVE/floodproject") #kyra mac wd
#setwd("D:/floodproject") #kyra windows wd

library(terra)
#source: https://www.fema.gov/flood-maps/national-flood-hazard-layer
floodarea <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_AR")
floodbound <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_LN")

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
a = list.files("i15_Crop_Mapping_2019",pattern = '.shp$',full.names = 1) 
landuse<-vect(a)
names(landuse)

#categories 
uses <- landuse$SYMB_CLASS
cats <- unique(uses)
agcats <- cats[1:10]
agind <-  unlist(sapply(agcats,grep,uses,value = 0))

urbanind<- grep(uses,cats[11],value = 0)

landuse$SYMB_CLASS[agind]<- "agricultural land"
landuse$SYMB_CLASS[urbanind] <- "urban land"
