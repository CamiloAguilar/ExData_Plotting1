## Coursera project 1 - Exploratory data analysis
library(readr)
library(dplyr)
library(data.table)

# 1. Load file ####
if(!file.exists("./data")){
  dir.create("./data")
}
if(!file.exists("./data/household_power_consumption.txt")){
  temp <- tempfile()
  urlFile<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(urlFile, temp)
  unzip(temp, exdir = "./data"); rm(urlFile)
  unlink(temp)
}

dataEPC<-read.table("./data/household_power_consumption.txt", sep = ";", header = T, fill = T, 
                    na.strings = "?")

# 2. Coercing Dates and times ####
dataEPC$Date<-as.POSIXct(paste(dataEPC$Date,dataEPC$Time,sep=" "), format = "%d/%m/%Y %H:%M:%S")
dataEPC<-select(dataEPC, -(Time)) %>%
  filter(Date>=as.POSIXct("2007-02-01",format="%Y-%m-%d") & 
           Date<as.POSIXct("2007-02-03",format="%Y-%m-%d"))

# 3. Making plot ####
par(mfcol=c(2,2))
#plot 1 of 4
with(dataEPC, plot(Date, Global_active_power, "l", xlab = "",
                   ylab="Global Active Power (kilowatts)"))
#plot 2 of 4
with(dataEPC, plot(Date, Sub_metering_1, type = "n", ylab = "Energy sub metering", xlab = ""))
lines(dataEPC$Date, dataEPC$Sub_metering_1)
lines(dataEPC$Date, dataEPC$Sub_metering_2, col="red")
lines(dataEPC$Date, dataEPC$Sub_metering_3, col="blue")
legend("topright", col = c("black","blue","red"),cex=0.2,lty=1, lwd=1.5, 
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))

#plot 3 of 4
with(dataEPC, plot(Date, Voltage, "l", xlab = "datetime", ylab="Voltage"))

#plot 4 of 4
with(dataEPC, plot(Date, Global_reactive_power, "l", xlab = "datetime", ylab="Global_reactive_power"))

dev.copy(png, width=480, height=480, file="plot4.png") ## Copy my plot to a PNG file
dev.off()
