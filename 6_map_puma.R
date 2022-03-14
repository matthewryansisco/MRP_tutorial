library(tigris)
puma_shapefile <- pumas(cb=T, year=2019,
                        # state="TX"  # To only pull shapefiles for one state
                        )

# Reduce to continental us
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10)<=56,]
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10) != 2,]
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10) != 15,]

library(ggplot2)
puma_shapefile <- fortify(puma_shapefile, region='PUMACE10')
head(puma_shapefile)

# Show what's loaded so far (just shapes)
ggplot() + geom_sf(data=puma_shapefile, lwd=.001, color="black") + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("")

# Merge in data from cell_count
temp <- cell_count %>% group_by(PUMA) %>% summarize(cognitive_difficulty = weighted.mean(cognitive_difficulty, count)
                                                    , age = weighted.mean(age, count)
                                                    , prediction = weighted.mean(prediction, count))
temp
puma_shapefile <- merge(puma_shapefile, temp, by.x="PUMACE10", by.y="PUMA")

library(ggthemes)
# ggplot() + geom_sf(data=puma_shapefile, aes(fill=cognitive_difficulty), lwd=.001, color=NA) + 
#   theme_bw() + # theme_map()+
#   scale_fill_gradientn(colors=rev(heat.colors(10))) +
#   ggtitle("")
# 
# ggplot() + geom_sf(data=puma_shapefile, aes(fill=age), lwd=.001, color=NA) + 
#   theme_bw() + # theme_map()+
#   scale_fill_gradientn(colors=rev(heat.colors(10))) +
#   ggtitle("")

ggplot() + geom_sf(data=puma_shapefile, aes(fill=prediction), lwd=.001, color=NA) + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("")

