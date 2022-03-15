"This script aggregates predictions at the level of state and plots them."

library(tigris)
library(ggplot2)
library(ggthemes)
library(dplyr)

state_shapefile <- states(cb=T)

# Reduce to continental us
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP)<=56,]
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP) != 2,]
state_shapefile <- state_shapefile[as.numeric(state_shapefile$STATEFP) != 15,]

state_shapefile <- fortify(state_shapefile, region='stateCE10')
head(state_shapefile)

# Merge in data from freq_table_state
temp <- freq_table_state %>% group_by(state) %>% 
  summarize(prediction = weighted.mean(prediction, count))
temp

state_shapefile <- merge(state_shapefile, temp, by.x="STUSPS", by.y="state")

ggplot() + 
  geom_sf(data=state_shapefile, aes(fill=prediction), lwd=.1, color="black") + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("MRP Estimated Values")

# Compare with: https://climatecommunication.yale.edu/visualizations-data/ycom-us/