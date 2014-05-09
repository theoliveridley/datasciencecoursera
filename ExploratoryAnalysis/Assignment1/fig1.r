library("lubridate") #For easier to use date functions dmy, ymd, hms, etc. 
#Read and prepare data
downloadurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("RawData/household_power_consumption.zip") ) download.file(downloadurl, "RawData/household_power_consumption.zip")
if(!file.exists("RawData/household_power_consumption.txt")) unzip("RawData/household_power_consumption.zip")
fulldata <- read.table("RawData/household_power_consumption.txt", sep = ";", nrows=2075259, colClasses=columns, na.strings="?", header = TRUE)
fulldata$Date <- ymd(fulldata$Date) #Convert date to date type
#Create date sets for only the required dates 2007-02-01 and 2007-02-02
selectdata <- fulldata[fulldata$Date == ymd("2007-02-01")| fulldata$Date == ymd("2007-02-02"),]
#Change time to a change object using hms from lubridate. 
selectdata$Time <- hms(selectdata$Time)
#Exploratory graphics. 
#Figure 1
png(width=480, height = 480, filename="Fig1.png")
hist(selectdata$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()
#Figure 2
png(width=480, height = 480, filename="Fig2.png")
with(selectdata, plot(Date + Time, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = ""))
dev.off()