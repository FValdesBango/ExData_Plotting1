#The script uses the "dplyr" packages and so it installs it incase it's absent.
install.packages("dplyr")
library(dplyr)

#It doesn't inform us if we should consider taht the raw data we obtain is 
#still in .zip format the raw data so potentially it has just been downloaded in 
#our working directory, and files haven't been extracted yet, so we check for
#its unzipping, doing it in case it hasn't been done.


if (!file.exists("household_power_consumption.txt")) {
        unzip(zipfile ="exdata%2Fdata%2Fhousehold_power_consumption")
}

#We first define a vector with the class of the data were are going to extract 
#from the file 
clas.t<-c("character","character",rep("numeric",7))

#We save variable values in a "raw" data, letting know in
#our call to the function that the missing values are coded in this set as "?"
hpcraw <- read.table (file = "./household_power_consumption.txt", 
                 sep= ";", header = TRUE, na.strings = "?", colClasses = clas.t)

# We establish a proper format for the time data that is extracted
hpcraw$Date<-as.Date(hpcraw$Date, format ="%d/%m/%Y")

#We subset our data frame to a smaller one containing only the data from the 
#period of time of interest
hpcsbt<- filter(hpcraw,hpcraw$Date==as.Date("2007-02-01") | 
                        hpcraw$Date==as.Date("2007-02-02") )
#We add a new column that will contain the information of the time not only 
#related to the date but also account for time passing in hours/minutes/seconds

hpcsbt<-mutate(hpcsbt,Complete.Time=as.POSIXct(with(hpcsbt,paste(Date,Time)),
                                               format="%Y-%m-%d %H:%M:%S"))

#In order to reproduce the images we set the proper language of our 
#working enviroment
Sys.setlocale("LC_TIME", locale = "C")

#We create the .png file according with the  specified dimensions
png(file="plot3.png", width = 480, height = 480)


with(hpcsbt,plot(Complete.Time,Sub_metering_1,xlab = "",
                 ylab = "Energy sub metering", type = "n"))

with(hpcsbt,lines(Sub_metering_1~Complete.Time))
with(hpcsbt,lines(Sub_metering_2~Complete.Time, col="red"))
with(hpcsbt,lines(Sub_metering_3~Complete.Time, col="blue"))

legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty= c(1,1,1), col = c("black","red","blue"))

#We close the call to .png outputing the file finally
dev.off()
