# Total PM2.5 1999,2002,2005,2008  #base plotting 


#download data 
#unzip and read 

if (file.exists("emissions") == FALSE) {
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

download.file(fileUrl, destfile = "./emissions")
unzip("emissions")
} 

NEI <- readRDS("summarySCC_PM25.rds")  #6.5 million rows x 6 columns 
SCC <- readRDS("Source_Classification_Code.rds") #12,000 rows by 15 columns  

 
#split data by years, 1999, 2002, 2005, 2008 
nei1999 <- subset(NEI, year == 1999)
nei2002 <- subset(NEI, year == 2002)
nei2005 <- subset(NEI, year == 2005)
nei2008 <- subset(NEI, year == 2008)
mean(is.na(NEI))  #NO NAs in the data 


#sum total emissions per year 

sum99 <- sum(nei1999$Emissions)
sum02 <- sum(nei2002$Emissions)
sum05 <- sum(nei2005$Emissions)
sum08 <- sum(nei2008$Emissions)

sums <- c(sum99,sum02,sum05,sum08)
thousands <- sums/1000  #for scaling of the Y axis 
#plot 

png(filename="plot1.png", width = 480, height = 480, units = "px")

plot(x = unique(NEI$year), y = thousands, xlab = "YEAR", ylab = "PM2.5 (thousands)", 
     ylim = c(3000,8000),
     main = "TOTAL PM2.5 Emissions", pch = 2, col = "blue")


dev.off()
