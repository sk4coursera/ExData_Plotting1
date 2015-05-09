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

# Begin plotting to a file device
png("plot2.png", width = 480, height = 480, units = "px")

# Draw the plot
plot(x = df2$DateTime, y = df2$Global_active_power, type="line", xlab="DateTime", ylab = "Global Active Power (kilowatts)", main = "Global Active Power")

# Close the file device
dev.off()
