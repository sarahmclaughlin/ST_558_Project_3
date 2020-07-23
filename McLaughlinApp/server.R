# Sarah McLaughlin 
# ST558 Project 3
# July 23, 2020 

library(shiny)
library(DT)
library(tidyverse)

# Bring in Data  
data <- read_delim("student-mat.csv", delim = ";")

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

# ------------------------------------------ # 

# Define server logic for each tab 
shinyServer(function(input, output, session) {

    getData <- reactive({
        data2 <- data %>% select(input$CatTable)
        })
    
    # Output for Tab 2 
    output$catTable <- renderTable({
        
    # Get filtered data 
        newData <- getData()
        
    # One Way Table
    table(select(newData, input$CatTable))
    })
    
    output$catGraph <- renderPlot({
        #Not colored by a variable 
        if (as.character(input$CatCol) == "None"){
            # Bar graphs of pass fail 
            g <- ggplot(data = data, aes_string(x = input$CatTable))
            # Not by school  
            g + geom_bar()
        } else {
            g <- ggplot(data = data, aes_string(x = input$CatTable))
            # By School 
            g + geom_bar(aes_string(fill = input$CatCol))
        }
    })
    
    # Output for Tab 5 
    output$tab5 <- renderTable({
        data
    })
    ### Fix this later
  # observe( if (input$save){
       # ggsave(filename = "Dataset")}  
       # else {}
   
    })
