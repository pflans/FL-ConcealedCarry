# http://www.freshfromflorida.com/content/download/7502/118869/cw_active.pdf
# *Out of State,"163,308"
# http://edr.state.fl.us/Content/population-demographics/data/

library('maps')
library(ggplot2)
library(scales)
library(plyr)
library(gridExtra)

ccpermits <- read.csv('fl-ccpermits.csv')
names(ccpermits) <- c('county','permits')

flpop <- read.csv('2013_Pop_Estimates.csv')
flpop <- flpop[-c(68:623),]
flpop <- flpop[1:2]
names(flpop) <- c('county','population')

florida <- map_data('county', regions ='florida')



names(florida) <- c("long", "lat", "group", "order", "state_name", "county")

florida <- data.frame(lapply(florida, function(v) {
  if (is.character(v)) return(toupper(v))
  else return(v)
}))

fl_state <- map_data('state', regions ='florida')


choro <- merge(florida, ccpermits, by = "county")
 
 
choro$permits <- gsub(",", "", choro$permits)
choro$permits <- as.numeric(choro$permits)

choro_order <- choro[order(choro$order), ]

# qplot(long, lat, data = choro_order, group = group, fill = permits, geom = "polygon")
  
g <- arrangeGrob(qplot(long, lat, data = choro_order, group = group, fill = permits, geom = "polygon"), 
                 sub = textGrob("Florida Department of Agriculture and Consumer Services - Division of Licensing - Concealed Weapon/Firearm License Holders by County as of January 31, 2014", x = 0, hjust = -0.1, vjust=0.1,
                                gp = gpar(fontface = "italic", fontsize = 12)))
  
  
ggsave("plot.png", g) 