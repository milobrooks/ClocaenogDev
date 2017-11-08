#CheckClocaenog - quality control the Cloceanog data

#set working directory to source file location
setwd("~/Temp/Clocaenog/ClocaenogDev")

#define constants
#outputFile<-"Output/ClocaenogCheck.pdf"
inputFile<-"../Merge/Clocaenog.dat"

#open the file for graphic output
#pdf(outputFile)

#read in the table
df<-read.table(
  inputFile,
  header = F,
  skip = 4,
  sep = ",",
  as.is = T)

#assign column names
colnames(df)<-t(read.table(
  inputFile,
  header = F,
  skip = 1,
  nrow = 1,
  sep = ",",
  as.is = T))

#assign column units
colUnits<-t(read.table(
  inputFile,
  header = F,
  skip = 2,
  nrow = 1,
  sep = ",",
  as.is = T))

#Convert the timestamp
df$TS<-as.POSIXct(df$TIMESTAMP, tz="GMT")

#extract the desired range
df<-subset(df,
           TS >= as.POSIXct("2016-09-01", tz="GMT") &
             TS < as.POSIXct("2017-10-01", tz="GMT"))

#@@@@represent missing data as NAs
#@@@remove duplicates if any

#set plot margins
par(mar=c(5,4,4,2)+.01)

#specify layout
par(mfrow=c(2,1))

#calculate x axis range
rng<-as.POSIXct(round(range(df$TS), "days"), tz="GMT")

#create the meta data for plotting
mD<-data.frame(
  matrix(
    c(5,13,-5,25,14,22,-5,35,23,31,0,15,34,42,0,1),
    dimnames = list(c("Soil Temperature 5cm",
                      "Air Temperature",
                      "Soil Temperature 20cm",
                      "Soil WVC"),
                    c("startCol",
                      "finishCol",
                      "yLo",
                      "yHi")),
    ncol=4, byrow=T))

#for each instrument
for (i in 1:nrow(mD)) {

  #new page
  par(mfrow=c(2,1))
  
  #for each roof
  for (j in (mD[i, "startCol"]: mD[i, "finishCol"])) {
    plot(
      df$TS,
      df[,j],
      ylim = c(mD$yLo[i], mD$yHi[i]),
      xlab = "Time",
      ylab = colUnits[j],
      main = paste(rownames(mD)[i], ", Plot", j - mD[i, "startCol"] + 1, sep =""),
      cex.main = .75,
      type = "l",
      col = "blue",
      xaxt = "n",
      cex.axis = .75,
      cex.lab = .75,
      las = 1)
  
    axis.POSIXct(1,
                 at=seq(
                     rng[1],
                     rng[2],
                     by = "month"),
                 format = "%m/%y", cex.axis = .75, las = 3)
  }
}
  
# close the pdf device, ie write the file
#dev.off()

