#Change in Baltimore City PM2.5 from 1999 to 2008  #base plotting 


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


#split data by years, 1999, 2002, 2005, 2008 
neib1999 <- subset(NEIb, year == 1999)
neib2002 <- subset(NEIb, year == 2002)
neib2005 <- subset(NEIb, year == 2005)
neib2008 <- subset(NEIb, year == 2008)

sumb99 <- sum(neib1999$Emissions)
sumb02 <- sum(neib2002$Emissions)
sumb05 <- sum(neib2005$Emissions)
sumb08 <- sum(neib2008$Emissions)

sumsb <- c(sumb99,sumb02,sumb05,sumb08)

png(filename = "plot2.png", width = 480, height= 480, units = "px")

plot(x = unique(NEIb$year), y = sumsb, ylab= "PM2.5", xlab = "Year", ylim = c(1500,3500), 
     main = "Baltimore Total PM2.5 Emissions", pch = 5, col = "blue")

dev.off() 
