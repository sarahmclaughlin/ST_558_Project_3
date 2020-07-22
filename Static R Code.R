# Sarah McLaughlin 
# ST558 Project 3 
# Static R Code 

# Set Up Libraries  
library(tidyverse)
library(knitr)
library(caret)
library(tree)

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

# Make certain variables factors
data$letter <- as.factor(data$letter)
data$final <- as.factor(data$final)
data$sex <- as.factor(data$sex)
data$school <- as.factor(data$school)
data$Pstatus <- as.factor(data$Pstatus)
data$famsize <- as.factor(data$famsize)
data$internet <- as.factor(data$internet)
data$higher <- as.factor(data$higher)


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
# Not by school  
g + geom_bar()
# By school  
g + geom_bar(aes(fill = school))
# Save Graphs with ggsave()
# ggsave(filename = "testsave.png")

# Numerical Data Analysis 
# Take numeric data only 
numData <- data %>% select(G3, age, absences, Medu, Fedu, famrel, studytime, failures, traveltime, Walc, health)

# Six number summaries 
# Not by school 
mat <- apply(numData, 2, summary, digits = 2, na.rm = TRUE)
kable(mat)
# Filter by School 
numData1 <- data %>% filter(school == "GP") %>% select(G3, age, absences, Medu, Fedu, famrel, studytime, failures, traveltime, Walc, health)
mat <- apply(numData1, 2, summary, digits =2 )
kable(mat)

# Numerical Graphs  
# Histograms 
g <- ggplot(data = data, aes(x = G3, fill = school))

g + geom_histogram(bins = 10)

# Scatter Plots 
g <- ggplot(data = data, aes(x = absences, y = G3))

# Not by School 
g + geom_point() + geom_smooth(method = lm)

# By School 
g + geom_point(aes(col = school))

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
# Have to be able to change the choices argument 
biplot(PCs, xlabs = rep(".", nrow(data)), choices = c(1,3), cex = 1.2)

# -----------------------TAB 4 : Modeling------------------------------------- # 

# Linear Regression Model 
# Pick your variables and then do a scatter plot 
g <- ggplot(data = data, aes(x = age, y = G3))

g + geom_point() + geom_smooth(method = lm)

# Create a linear model  
model1 <- lm(G3 ~ age, data = data)

# Create a linear model with all variables 
model2 <- lm(G3 ~ ., data = data)

# Predict Data using model
predict(model1, newdata = data.frame(age = c(13, 14, 16)))

# Classification Tree  
# adjust data to only include Letter grade 
data2 <- data %>% select(-G3, -final)

# Classified by Letter  
classTree <- tree(letter ~ age + absences, data = data2, split = "deviance")

plot(classTree)
text(classTree)

# Predict using Tree
predict(classTree, data.frame(age = 13, absences = 2), type = "class")

# -----------------------TAB 5 : Data------------------------------------- # 
print(data)


