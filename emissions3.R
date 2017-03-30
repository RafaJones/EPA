#increases and decreases in emissions by TYPE for baltimore city - using ggplot2

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


NEIb <- tbl_df(NEIb)
NEIb <- group_by(NEIb, type,year, add=TRUE)
data <- summarise_each(NEIb, funs(sum), Emissions)

png(filename = "plot3.png", width =480, height = 480, unit = "px")

qplot(year,Emissions, data = data, color = type, geom = c("point","line"), 
      main = "Baltimore PM2.5 Emissions")
dev.off() 




