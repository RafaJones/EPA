#Across entire USA how have coal combustion related emissions changed from 1999 to 2008 

library(ggplot2)
library(dplyr)
library(cowplot)

#download data 
#unzip and read 

if (file.exists("emissions") == FALSE) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  download.file(fileUrl, destfile = "./emissions")
  unzip("emissions")
} 

NEI <- readRDS("summarySCC_PM25.rds")  #6.5 million rows x 6 columns 
SCC <- readRDS("Source_Classification_Code.rds") #12,000 rows by 15 columns 

sector <- unique(SCC$EI.Sector)  #59 broad categories 

coalsectors <- grep("Coal", sector) #3 sectors include Coal in their name, They are also all Combustion 
#positions 1,6, and 11 
coalsectors <- sector[c(1,6,11)]

#get the SCC codes for the coal sectors 

coalSCC <- SCC[which(SCC$EI.Sector %in% coalsectors),]  #subset the SCC dataset
selectSCC <- unique(coalSCC$SCC) #extract only the SCC codes 

coaldata <- subset(NEI, SCC %in% selectSCC)

coaldata <- tbl_df(coaldata)
coaldata <- group_by(coaldata, type, year, add=TRUE)
data <- summarise_each(coaldata, funs(sum), Emissions)

data$Emissions <- data$Emissions/1000  #scale it down for cleanliness 



plot1 <- qplot(type, Emissions, data = coaldata, color = year) 
#you can see that lighter colors (more recent data) dominate the low emissions 

#more traditionally, you can see total emissions over time in the second plot 

plot2 <- qplot(year, Emissions, data = data, color = type, 
               ylab="Total Emissions (thousands)", geom = c("point","line"))

png(filename = "plot4.png", width = 850, height = 700, units = "px")

plot_grid(plot1,plot2,align='h',labels = c("Coal Emissions", "Total Coal Emissions (thousands)"))


dev.off()




