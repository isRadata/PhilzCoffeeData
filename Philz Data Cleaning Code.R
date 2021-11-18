#Philz App Expenditures Data Cleaning and Visualization

### INSTALL PACKAGES AND LOAD LIBRARIES
install.packages("readr")
library(readr)
install.packages("tidyverse")
library(tidyverse)
install.packages("dplyr")
library(dplyr)
install.packages("tidyr")
library(tidyr)


### READ IN DATASET
df <- read_csv("philz.csv")

### Look at dataset structure, columns and rows
srt(df)
view(df)


### DATA CLEANING

# Drop row 1 through 6 and 116
df <- (df %>% slice(-c(0:6,121)))
# Rename column headers
colnames(df) <- (c("Store", "OrderCreationDate", "ReservedPickUpTime","Status", 
                   "Subtotal", "Tip", "Taxes"))
# Drop first row with column names and relabel column headers with column names
df <- (df %>% slice(-c(1)))

# Remove rows with missing values 
df <- na.omit(df)

# Change variable from character to numeric
df$Subtotal <- as.numeric(df$Subtotal) 

### Checkpoint of df to ensure code is performing correctly ###
view(df)

### Cleaning up time/date columns

# Split date and time into two columns
df$OrderCreationDate <- data.frame(do.call("rbind", strsplit(as.character(df$OrderCreationDate),' ', 2)))
df$ReservedPickUpTime <- data.frame(do.call("rbind", strsplit(as.character(df$ReservedPickUpTime),' ', 2)))

# Rename third column using indexing
colnames(df)[3] <- "ReservedPickUpDate"

# Edit subtotal column into dollars with two decimal places
df$Subtotal <- round(df$Subtotal/100, digits=4)

# Add column with Zip Codes
df$ZipCode <- 'na'
df$ZipCode[df$Store == "Campbell"] <- '95008'
df$ZipCode[df$Store == "Forest Ave"] <- '94301'
df$ZipCode[df$Store == "Cupertino Main"] <- '95014'
df$ZipCode[df$Store == "Sunnyvale"] <- '94086'
df$ZipCode[df$Store == "Fremont"] <- '94538'
df$ZipCode[df$Store == "DeAnza Cupertino"] <- '95014'
df$ZipCode[df$Store == "La Jolla"] <- '92037'
df$ZipCode[df$Store == "Los Gatos"] <- '95123'
df$ZipCode[df$Store == "Front St"] <- '94111'
df$ZipCode[df$Store == "Middlefield Rd"] <- '94306'
df$ZipCode[df$Store == "South Coast Metro"] <- '92626'

# Include only 'assigned' transactions
df <- subset(df, Status == "assigned") 
view(df)

### SAVE DATASET AS EXCEL FILE
write.csv(df,"PhilzData_Cleaned.csv", row.names = FALSE)







