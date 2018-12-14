if(!dir.exists("./data/")) {
    dir.create("./data/")
}

library(tidyverse)

file_loc <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_loc, destfile = "./data/household_power_raw.zip", mode = "wb")

unzip(zipfile = "./data/household_power_raw.zip", exdir = "data")

#t1 <- cols(Date = "D", Time = "t", Global_active_power = "d", Global_reactive_power = "d", Voltage = "d", Global_intensity = "d", Sub_metering_1 = "d", Sub_metering_2 = "d", Sub_metering_3 = "d")

#dt <- read.csv2(file = "./data/household_power_consumption.txt", col_types = t1, na=c("", "?"))
dt <- read.csv2(file = "./data/household_power_consumption.txt", stringsAsFactors = FALSE, na=c("", "?"))
dt <- as_tibble(dt)

dtDates <- dt$Date
dt$Date <- parse_date(dtDates, format = "%d/%m/%Y")
rm(dtDates)
dt$Time <- parse_time(dt$Time, format = "%H:%M:%S")
dt$Global_active_power <- parse_number(dt$Global_active_power)
dt$Global_reactive_power <- parse_number(dt$Global_reactive_power)
dt$Global_intensity <- parse_number(dt$Global_intensity)
dt$Voltage <- parse_number(dt$Voltage)
dt$Sub_metering_1 <- parse_number(dt$Sub_metering_1)
dt$Sub_metering_2 <- parse_number(dt$Sub_metering_2)
dt$Sub_metering_3 <- parse_number(dt$Sub_metering_3)

dt <- filter(dt, dt$Date == "2007-02-02" | dt$Date == "2007-02-01" )
dt <- mutate(dt, datetime = as.POSIXct(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S"))

png(filename = "plot1.png")
hist(dt$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col="red")
dev.off()

png(filename = "plot2.png")
plot(dt$datetime, dt$Global_active_power, type = "n", xlab ="", ylab = "Global Active Power (kilowatts)")
lines(dt$datetime, dt$Global_active_power)
dev.off()

plot(dt$datetime, dt$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(dt$datetime, dt$Sub_metering_1)
lines(dt$datetime, dt$Sub_metering_2, col = "red")
lines(dt$datetime, dt$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1, 1))

png(filename = "plot3.png")
plot(dt$datetime, dt$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(dt$datetime, dt$Sub_metering_1)
lines(dt$datetime, dt$Sub_metering_2, col = "red")
lines(dt$datetime, dt$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1, 1))
dev.off()       

png(filename = "plot4.png")
par(mfcol = c(2, 2))
plot(dt$datetime, dt$Global_active_power, type = "n", xlab ="", ylab = "Global Active Power")
lines(dt$datetime, dt$Global_active_power)

plot(dt$datetime, dt$Sub_metering_1, type = "n", xlab = "", ylab = "Energy sub metering")
lines(dt$datetime, dt$Sub_metering_1)
lines(dt$datetime, dt$Sub_metering_2, col = "red")
lines(dt$datetime, dt$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", lty = c(1, 1, 1))

plot(dt$datetime, dt$Voltage, type = "n", xlab = "datetime", ylab = "Voltage")
lines(dt$datetime, dt$Voltage)

plot(dt$datetime, dt$Global_reactive_power, type = "n", xlab = "datetime", ylab = "Global_reactive_power")
lines(dt$datetime, dt$Global_reactive_power)
dev.off()