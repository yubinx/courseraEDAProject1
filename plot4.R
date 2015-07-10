# step 1: read a subset of data from txt file----
setwd("C:/Users/Administrator/Desktop/R") # set working directory (make sure that the data file is located at the same directory)

# method 1
hpc <- read.table("household_power_consumption.txt", header=T, sep=";", skip=66636, nrows=69517-66637) # 2007/2/1 starts from 66638th row and 2007/2/2 ends at 69517th row
# problem using read.table is that if using skip, the header cannot be read properly

# method 2
library(sqldf)
hpc <- read.csv.sql("household_power_consumption.txt", sep=";", sql = "select * from file where Date in ('1/2/2007', '2/2/2007')")

# method 3: read the whole file and subset
hpc <- read.table("household_power_consumption.txt", header=T, sep=";")
hpc <- subset(hpc, Date > as.Date("2007/1/31") & Date < as.Date("2007/2/3"))

# step 2.1: convert date in the file into the correct format----

# method 1
library(lubridate); 
hpc$Date <- dmy(hpc$Date) 

# method 2
hpc$Date <- as.Date(hpc$Date, "%d/%m/%Y") 

# step 2.2: convert the Date and Time variables to Date/Time classes and include it in the data frame----
hpc$dt <- strptime(paste(hpc$Date,hpc$Time), format="%Y-%m-%d %H:%M:%S") # an individual vector of date/time


# step3: plot----

# plot4
# Disclaimer: I noticed that for the top right and bottom right subplots of the example plot 4, the x axis labels are both "datetime".
# I excluded them from my plots because I believe they were not intended. Otherwise they can be added by including xlab="datetime".

png(file="plot4.png")
par(mfrow=c(2,2))
with(hpc, {
  plot(dt, Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  plot(dt, Voltage, type="l", xlab="")
  plot(dt, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
  lines(dt, Sub_metering_2, col="red")
  lines(dt, Sub_metering_3, col="blue")
  legend("topright", lty=1, bty="n", col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
  plot(dt, Global_reactive_power, type="l", ylab="Global Reactive Power (kilowatts)", xlab="")
})
dev.off()