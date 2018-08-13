#libraries
library(dplyr)

#Download and unzip the data we will be working with.
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
temp <- tempfile()
if ( !file.exists("electripowerconsumption.txt")){
  download.file(dataset_url, temp)
  unzip(temp, "household_power_consumption.txt")
  unlink(temp)
}
#Reading, subseting, and cleaning
mydata <- read.delim("household_power_consumption.txt", sep = ";", stringsAsFactors = FALSE, na.strings="?")
mydata$Date <- as.Date(x= mydata$Date, format = "%d/%m/%Y")
mydata <- subset(mydata, Date>= "2007-02-01" & Date <= "2007-02-02")
mydata$Global_active_power <- as.double(mydata$Global_active_power)
mydata$Global_reactive_power <- as.double(mydata$Global_reactive_power)
mydata$Voltage <- as.double(mydata$Voltage)
mydata$Global_intensity <- as.double(mydata$Global_intensity)

mydata$Sub_metering_1 <- as.integer(mydata$Sub_metering_1)
mydata$Sub_metering_2 <- as.integer(mydata$Sub_metering_2)
mydata$Sub_metering_3 <- as.integer(mydata$Sub_metering_3)

#New datatime variable
mydata <- mutate(mydata, datetime= as.POSIXct(paste(Date, Time), format="%Y-%m-%d %H:%M:%S"))

#set device size
dev.new(width = 480, height = 480, unit = "px")

#Plot 3
with(mydata, 
  plot( Sub_metering_1 ~ datetime, 
       ylab = "Energy sub metering",
       xlab = "",
       type = "o",
       pch = 27)
)

with(mydata, 
     points( Sub_metering_2 ~ datetime, 
           ylab = "Energy sub metering",
           xlab = "",
           type = "o",
           col = "red",
           pch = 27)
)

with(mydata, 
     points( Sub_metering_3 ~ datetime, 
             ylab = "Energy sub metering",
             xlab = "",
             type = "o",
             col = "blue",
             pch = 27)
)

legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       lty = c(1, 1, 1))

#Plot 3 image
dev.copy(png,'plot3.png')
dev.off()

