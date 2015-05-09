# Read the file with delimiter ";"
df1 <- read.csv2("household_power_consumption.txt", colClasses="character" )

# To filter out the data we are interested in 
df1[, 1] <- as.Date(df1[, 1], "%d/%m/%Y")

# Another DF with data between dates 2007-02-01 and 2007-02-02
df2 <- subset(df1, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))

# Add a DateTime column with columns "Date" (#1) and "Time" (#2)
df2$CharDateTime <- paste(df2[, 1], df2[, 2])

# Add another column that stores the DateTime in POSIXlt format
df2$DateTime <- strptime(df2$CharDateTime, "%Y-%m-%d %H:%M:%S")

# Convert numeric columns into numeric type
df2[c(3:9)] <- sapply(df2[c(3:9)], as.numeric)

# Begin plotting to a file
png("plot4.png", width = 480, height = 480, units = "px")

# To draw 4 plots row wise
par(mfrow=c(2,2))

# Plot #3 with several lines and other options
drawPlot3 <- function(){

    # Data points we are interested in plotting
    plotdatapoints <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

    # Colors to use
    plotcolors <- rainbow(length(plotdatapoints))

    # Set the plot area, using the 'range' function to ensure that we will be able to draw the lines in the visible area
    plot(range(df2$DateTime), range(df2[plotdatapoints]), type="n", xlab="DateTime", ylab = "Energy Sub Metering (watt-hour of active energy)")

    # Draw a line for each data point we are interested in
    for (i in seq_along(plotdatapoints)) { 
      lines(df2$DateTime, df2[[plotdatapoints[i]]], col = plotcolors[i])
    }

    # Finally draw the legend
    legend("topright", plotdatapoints, cex=0.8, bty="n", col=plotcolors, lty="solid")
}

# Draw the four plots
with(df2, {
    plot(DateTime, Global_active_power, type="line", xlab="DateTime", ylab = "Global Active Power (kilowatts)")
    plot(DateTime, Voltage, type="line", xlab="DateTime", ylab = "Voltage (volts)")
    drawPlot3()
    plot(DateTime, Global_reactive_power, type="line", xlab="DateTime", ylab = "Global Reactive Power (kilowatts)")
})

# Close the file device
dev.off()
