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

#Plot 4
par(mfrow=c(2,2))
axis(2,cex.axis=0.2)
#Topleft
with(mydata, 
     plot( Global_active_power ~ datetime, 
           ylab = "Global Active Power",
           xlab="",
           type = "o",
           pch = 27,
           cex = 0.6)
)

#Topright
with(mydata, 
     plot( Voltage ~ datetime, 
           ylab = "Voltage",
           type = "o",
           pch = 27,
           cex = 0.6)
)

#bottonleft
with(mydata, 
  plot( Sub_metering_1 ~ datetime, 
       ylab = "Energy sub metering",
       xlab = "",
       type = "o",
       pch = 27)
)

with(mydata, 
     points( Sub_metering_2 ~ datetime, 
           ylab = "",
           xlab = "",
           type = "o",
           col = "red",
           pch = 27)
)

with(mydata, 
     points( Sub_metering_3 ~ datetime, 
             ylab = "",
             xlab = "",
             type = "o",
             col = "blue",
             pch = 27,
             cex = 0.6)
)

legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), 
       bty = "n",
       lty = c(1, 1, 1),
       cex = 0.6)

#bottonright
with(mydata, 
     plot( Global_reactive_power ~ datetime, 
           type = "o",
           pch = 27,
           ylim=c(0.0, 0.5),
           cex = 0.6)
)



#Plot 4 image
dev.copy(png,'plot4.png')
dev.off()

