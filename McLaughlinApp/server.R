# Sarah McLaughlin 
# ST558 Project 3
# July 23, 2020 

library(shiny)
library(DT)
library(tidyverse)
library(googleVis)
library(devtools)

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

    
# ---------- TAB 2 ---------------- # 
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
    
    # Bar Graphs
    output$catGraph <- renderPlot({
        
        # Colored by variable 
        if (input$color){
            g <- ggplot(data = data, aes_string(x = input$CatTable))
            #By color
            g + geom_bar(aes_string(fill = input$CatCol))
            
        } else {
        # Bar graphs of variable 
        g <- ggplot(data = data, aes_string(x = input$CatTable))
        # Not by color 
        g + geom_bar()
        }
    })
    
    # Output for Numerical analysis  
    output$numsums <- renderGvis({
        numData <- data %>% select(G3, age, absences, Medu, Fedu, famrel, studytime, 
                                   failures, traveltime, Walc, health)
        mat <- apply(numData, 2, summary, digits = 2, na.rm = TRUE)
        mat <- cbind(' ' = c("Min", "1st Q", "Median", "Mean", "3rd Q", "Max"), mat)
        mat <- as.data.frame(mat) 
        
        # Just one variable 
        if (input$one){
            oneMat <- cbind(' ' = c("Min", "1st Q", "Median", "Mean", "3rd Q", "Max"), mat[input$oneNum])
            gvisTable(oneMat)
        } else {
        # All variables 
            gvisTable(mat)
        }
    })
    
    output$scatter <- renderPlot({
        # Create Scatter Plot 
        g <- ggplot(data = data, 
                        aes_string(x = input$xvar, y = input$yvar))
        g + geom_point(position = "jitter")}
    )
    # Create Reactive function to use to save plot  
    plotInput <- reactive({
        g <- ggplot(data = data, 
                    aes_string(x = input$xvar, y=input$yvar))
        g + geom_point(position = "jitter")
    })
    
    # Output for Saving Scatterplot 
       output$savescat <- downloadHandler(
          filename <- function(){
              paste(input$xvar, "by", input$yvar, ".png", sep = "")
         }, 
          content <-function(file){
              ggsave(file, plot = plotInput())
          }
       )
    
# -------------- TAB 3 ------------ #
       output$PCAOutput <- renderPrint({
           if (length(input$PCAVar) == 0){
               return("Pick a variable to begin Principal Component Analysis")
           } else {
        # PCA Function  
        PCs <- prcomp(select(data, !!!input$PCAVar), scale = TRUE)
        
           print(PCs)
           }
           })
       
       # Biplot 
       output$biplot <- renderPlot({
           if (length(input$PCAVar) > 1){
           PCs <- prcomp(select(data, !!!input$PCAVar), scale = TRUE)
           biplot(PCs, xlabs = rep(".", nrow(data)), cex = 1.2)
           } else {}
       })
       
       # Appropriateness of PCs
       output$approp <- renderPlot({
           if(length(input$PCAVar) > 1){
           PCs <- prcomp(select(data, !!!input$PCAVar), scale = TRUE)
           # Plots to see appropriateness of PCs 
           par(mfrow = c(1,2))
           plot(PCs$sdev^2/sum(PCs$sdev^2), xlab = "Principal Component", 
                ylab = "Proportion of Variance Explained", ylim = c(0,1), 
                type = 'b')
           plot(cumsum(PCs$sdev^2/sum(PCs$sdev^2)), xlab = "Principal Component", ylab = "Cum. Prop of Variance Explained", ylim = c(0,1), type = 'b')
           } else {}
       })
      
    
# -------------- TAB 5 ------------ # 
    # Output for Tab 5 
       
    output$tab5 <- renderGvis({
        gvisTable(data)
    })
    
    output$saveData <- downloadHandler(
        filename<- function(){
            paste("data", Sys.Date(), ".csv", sep = "")
        },
        content <- function(file){
            write.csv(data, file)
        }
    )
})
    
