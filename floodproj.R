setwd("/Volumes/KYRADRIVE/floodproject") #kyra mac wd
#setwd("D:/floodproject") #kyra windows wd

library(terra)
#source: https://www.fema.gov/flood-maps/national-flood-hazard-layer
floodarea <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_AR")
floodbound <- vect('national_flood_hazard_layer_fema/NFHL_06_20230121.gdb',layer = "S_FLD_HAZ_LN")
#making sense of and organizing fema data
names(floodarea)
subtypes<- unique(floodarea$ZONE_SUBTY) #special floodzones
zonetypes<- unique(floodarea$FLD_ZONE)

# 
# ZONE A Area inundated by the Base Flood with no Base Flood Elevations determined.
# ZONE AE Area inundated by the Base Flood with Base Flood Elevations determined.
# ZONE AH Area inundated by the Base Flood with flood depths of 1 to 3 feet (usually areas of
#                                                                            ponding); Base Flood Elevations determined.
# ZONE AO Area inundated by the Base Flood with flood depths of 1 to 3 feet (usually sheet flow
#                                                                            on sloping terrain); average depths determined. For areas of alluvial fan flooding,
# velocities are also determined.
# ZONE V Coastal flood zone with velocity hazard (wave action); no Base Flood Elevations
# determined.
# ZONE VE Coastal flood zone with velocity hazard (wave action); Base Flood Elevations
# determined


#layer names from fema
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

#listing all categories, finding the unique ones, setting all of the crops to ag land
# and U as urban
uses <- landuse$SYMB_CLASS
cats <- unique(uses)
agcats <- cats[1:10]
agind <-  unlist(sapply(agcats,grep,uses,value = 0))

urbanind<- grep(uses,cats[11],value = 0)
# replacing the values in the column
landuse$SYMB_CLASS[agind]<- "agricultural land"
landuse$SYMB_CLASS[urbanind] <- "urban land"
