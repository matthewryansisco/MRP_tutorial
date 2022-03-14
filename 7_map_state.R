library(tigris)
state_shapefile <- states(cb=T)

# Reduce to continental us
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP)<=56,]
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP) != 2,]
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP) != 15,]

library(ggplot2)
state_shapefile <- fortify(state_shapefile, region='stateCE10')
head(state_shapefile)

# Merge in data from cell_count
temp <- cell_count %>% group_by(state) %>% summarize(cognitive_difficulty = weighted.mean(cognitive_difficulty, count)
                                                     , age = weighted.mean(age, count)
                                                     , prediction = weighted.mean(prediction, count))
temp

state_shapefile <- merge(state_shapefile, temp, by.x="STUSPS", by.y="state")

library(ggthemes)
ggplot() + geom_sf(data=state_shapefile, aes(fill=cognitive_difficulty), lwd=.001, color=NA) + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("Cognitive Difficulty")

ggplot() + geom_sf(data=state_shapefile, aes(fill=age), lwd=.001, color=NA) + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("Age")

ggplot() + geom_sf(data=state_shapefile, aes(fill=prediction), lwd=.001, color="black") + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("MRP Estimated Values")
