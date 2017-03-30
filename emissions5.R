#motor vehicles emissions in Baltimore City 1999-2008

library(ggplot2)
library(dplyr)

#download data 
#unzip and read 

if (file.exists("emissions") == FALSE) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  
  download.file(fileUrl, destfile = "./emissions")
  unzip("emissions")
} 

NEI <- readRDS("summarySCC_PM25.rds")  #6.5 million rows x 6 columns 
SCC <- readRDS("Source_Classification_Code.rds") #12,000 rows by 15 columns 

mean(is.na(NEI))  #NO NAs in the data 

#baltimore  fips ="24510"

NEIb <- subset(NEI, fips == "24510")

sector <- unique(SCC$EI.Sector)  #59 broad categories 

#categories containing the word vehicle 
vehiclesector <- grep("Vehicle", sector) #positions 21,22,23, 24
vehicleselect <- sector[c(21,22,23,24)]  #select the correct sectors

scc0 <- SCC[which(SCC$EI.Sector %in% vehicleselect),] #select the SCC codes for the vehicle sectors
selectSCC <- unique(scc0$SCC) #extract only the SCC codes 

vehicledata <- subset(NEIb, SCC %in% selectSCC)

vehicledata <- tbl_df(vehicledata)
vehicledata <- group_by(vehicledata, year)
data <- summarise_each(vehicledata, funs(sum), Emissions)

png(filename = "plot5.png", width=480, height =480, units = "px")

qplot(year, Emissions, data = data, geom = c("point","line"), main = "Baltimore Vehicle Emissions")

dev.off()