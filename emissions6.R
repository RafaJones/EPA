#motor vehicle emissions between Baltimore City and Los Angeles County 


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

#baltimore  fips ="24510"   LA fips = "06037"

NEIboth <- subset(NEI, fips == "24510" | fips == "06037") 
#11416 rows by 6 columns 

#motor vehicle SCC codes 
sector <- unique(SCC$EI.Sector)  #59 broad categories 

#categories containing the word vehicle 
vehiclesector <- grep("Vehicle", sector) #positions 21,22,23, 24
vehicleselect <- sector[c(21,22,23,24)]  #select the correct sectors

scc0 <- SCC[which(SCC$EI.Sector %in% vehicleselect),] #select the SCC codes for the vehicle sectors
selectSCC <- unique(scc0$SCC) #extract only the SCC codes 

vehicledata <- subset(NEIboth, SCC %in% selectSCC)

vehicledata <- tbl_df(vehicledata)
vehicledata <- group_by(vehicledata, fips, year, add = TRUE)
data <- summarise_each(vehicledata, funs(sum), Emissions)

for(i in 1:length(data$fips)) {
  if(data$fips[i] == "06037") data$fips[i] <- "Los Angeles" 
  else data$fips[i] <- "Baltimore" }
  
png(filename = "plot6.png", width=480, height =580, units = "px")
qplot(year, Emissions, data = data, color = fips, geom = c("point","line"),
      main = "Baltimore vs Los Angeles, Vehicle Emissions")

dev.off() 

