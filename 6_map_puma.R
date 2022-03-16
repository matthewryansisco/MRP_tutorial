"This script aggregates predictions at the level of PUMA and plots them."

library(tigris)
library(ggplot2)
library(ggthemes)
library(dplyr)

puma_shapefile <- pumas(cb=T, year=2019,
                        # state="TX"  # To only pull shapefiles for one state
                        )

# Reduce to continental us
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10)<=56,]
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10) != 2,]
puma_shapefile <- puma_shapefile[as.numeric(puma_shapefile$STATEFP10) != 15,]

puma_shapefile <- fortify(puma_shapefile, region='PUMACE10')
head(puma_shapefile)

# Show what's loaded so far (just shapes)
ggplot() + geom_sf(data=puma_shapefile, lwd=.001, color="black") + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=rev(heat.colors(10))) +
  ggtitle("")


# Merge in data from freq_table_puma
puma_mrp_estimates <- freq_table_puma %>% group_by(PUMA, ST) %>% 
  summarize(prediction = weighted.mean(prediction, count))
puma_mrp_estimates
puma_shapefile <- merge(puma_shapefile, puma_mrp_estimates, 
                        by.x=c("PUMACE10", "STATEFP10"), 
                        by.y=c("PUMA", "ST"))

# Plot
ggplot() + 
  geom_sf(data=puma_shapefile, aes(fill=prediction), lwd=.001, color=NA) + 
  theme_bw() + # theme_map()+
  scale_fill_gradientn(colors=c("white", "orange", "red")) +
  ggtitle("")

