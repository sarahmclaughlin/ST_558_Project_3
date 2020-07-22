# Sarah McLaughlin 
# ST558 Project 3 
# Static R Code 

# Set Up Libraries  
library(tidyverse)

# Bring in Data  
data <- read_delim("student-mat.csv", delim = ";")

# Create Letter Grade Variable 
# Letter Grades Based on University of Minho Article 
data <- mutate(data, letter = 
                         ifelse(G3 >= 16, "A", 
                         ifelse(G3 >= 14, "B", 
                         ifelse(G3 >= 12, "C", 
                         ifelse(G3 >= 10, "D", 
                                          "F")))))

# Select Only Specific Variables 
data <- data %>% select(letter, sex, age, school, absences, Pstatus, Medu, Fedu, famsize, famrel, studytime, failures, internet, higher)

# Run Initial Principal Component Analysis 
PCs <- prcomp(select(data, age, studytime, Medu, Fedu, failures, absences), scale = TRUE)

# Show Principal Components 
PCs

# Create Biplot
biplot(PCs, xlabs = rep(".", nrow(data)), cex = 1.2)

# Plots to see appropriateness of PCs 
par(mfrow = c(1,2))
plot(PCs$sdev^2/sum(PCs$sdev^2), xlab = "Principal Component", 
     ylab = "Proportion of Variance Explained", ylim = c(0,1), 
     type = 'b')
plot(cumsum(PCs$sdev^2/sum(PCs$sdev^2)), xlab = "Principal Component", ylab = "Cum. Prop of Variance Explained", ylim = c(0,1), type = 'b')
# Stop after Principal Component 4 

# Graphing Different BiPlots  
biplot(PCs, xlabs = rep(".", nrow(data)), choices = c(1,3), cex = 1.2)

