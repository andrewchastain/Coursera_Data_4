library(tidyverse)

if(!dir.exists("./data/")) {
    dir.create("./data/")
}

# check if the file has already been downloaded
if(!file.exists("./data/household_power_consumption.txt")) {
    file_loc <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(file_loc, destfile = "./data/household_power_raw.zip", mode = "wb")
    
    unzip(zipfile = "./data/household_power_raw.zip", exdir = "data")    
}

# read file and convert to tibble (for dplyr experience)
dt <- read.csv2(file = "./data/household_power_consumption.txt", stringsAsFactors = FALSE, na=c("", "?"))
dt <- as_tibble(dt)

# reparse the file to correct formats
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

# filter to dates of interest, and combine date and time into datetime column
dt <- filter(dt, dt$Date == "2007-02-02" | dt$Date == "2007-02-01" )
dt <- mutate(dt, datetime = as.POSIXct(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S"))

# make plot
png(filename = "plot2.png")
plot(dt$datetime, dt$Global_active_power, type = "n", xlab ="", ylab = "Global Active Power (kilowatts)")
lines(dt$datetime, dt$Global_active_power)
dev.off()