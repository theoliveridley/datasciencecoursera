require(lubridate) #For easier to use date functions dmy, ymd, hms, etc. 
require(data.table) #For faster reading of file using fread()
#Read and prepare data
downloadurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("RawData/household_power_consumption.zip") ) download.file(downloadurl, "RawData/household_power_consumption.zip")
if(!file.exists("RawData/household_power_consumption.txt")) unzip("RawData/household_power_consumption.zip")
fulldata <- fread("RawData/household_power_consumption.txt", sep = ";",na.strings="?", header = TRUE)
fulldata$Date <- dmy(fulldata$Date) #Convert date to date type
#Create date sets for only the required dates 2007-02-01 and 2007-02-02
selectdata <- fulldata[fulldata$Date == ymd("2007-02-01")| fulldata$Date == ymd("2007-02-02"),]
#Change time to a time object using hms from lubridate. 
selectdata$Time <- hms(selectdata$Time)
#change all other columns to numeric. fread() bug coerces columns to characters if chars are found, can't override
selectdata$Global_active_power <- as.numeric(selectdata$Global_active_power)
selectdata$Global_reactive_power <- as.numeric(selectdata$Global_reactive_power)
selectdata$Voltage <- as.numeric(selectdata$Voltage)
selectdata$Global_intensity <- as.numeric(selectdata$Global_intensity)
selectdata$Sub_metering_1 <- as.numeric(selectdata$Sub_metering_1)
selectdata$Sub_metering_2 <- as.numeric(selectdata$Sub_metering_2)
#Sub_metering_3 is already numeric - This code will be optimized later 

#Figure 4


png(width=480, height = 480, filename="Fig4.png")
par(mfrow=c(2,2), mar = c(5,4.5,1,0.5))

#Part one is copied from fig2
with(selectdata, plot(Date + Time, Global_active_power, type = "l", ylab = "Global Active Power", xlab = ""))
#part2
with(selectdata, plot(Date + Time, Voltage, type = "l", xlab = "datetime", ylab = "Voltage"))

#Part 3 is copied from fig3 with a small change in legend border
with(selectdata, plot(Date + Time, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(selectdata, lines(Date + Time, Sub_metering_2, col = "red"))
with(selectdata, lines(Date + Time, Sub_metering_3, col = "blue"))
legend("topright", names(selectdata[7:9]), lwd = 1, col = c("black", "red", "blue"), bty = "n")
#part4
with(selectdata, plot(Date + Time, Global_reactive_power, type = "l", xlab = "datetime"))
dev.off()