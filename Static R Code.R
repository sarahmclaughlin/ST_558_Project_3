# Sarah McLaughlin 
# ST558 Project 3 
# Static R Code 

# Set Up Libraries  
library(tidyverse)

# -----------------------DATA OVERALL------------------------------ # 
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

# Create Pass Fail Variable  
data <- mutate(data, final = ifelse(G3>= 10, "Pass", "Fail"))


# Select Only Specific Variables 
data <- data %>% select(final, letter, G3, sex, age, school, absences, Pstatus, Medu, Fedu, famsize, famrel, studytime, failures, internet, higher, traveltime, Walc, health)

# -----------------------TAB 1 : Info Page------------------------------ # 


# -----------------------TAB 2 : Data Exploration------------------------------ # 

# Categorical Data Analysis 

# Create a few tables 
# Idea for being able to use in R Shiny 
  # Use dynamic UI to make a one, two or three way table and then 
  # user can pick the variables 
table(data$final)
table(data$letter)
table(data$school)
table(data$school, data$final)

# Create a few bar graphs
# Bar graphs of pass fail 
g <- ggplot(data = data, aes(x = final))
# Without School 
g + geom_bar()
# With School 
g + geom_bar(aes(fill = school))
# Save Graphs with ggsave()
ggsave(filename = "testsave.png")


# Numerical Data Analysis 

# -----------------------TAB 3 : PC------------------------------------- # 

# Run Initial Principal Component Analysis 
PCs <- prcomp(select(data, age, studytime, Medu, Fedu, failures, absences, traveltime, Walc, health), scale = TRUE)

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

