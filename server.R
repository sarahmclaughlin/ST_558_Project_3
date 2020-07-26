# Sarah McLaughlin 
# ST558 Project 3
# July 23, 2020 

library(shiny)
library(DT)
library(tidyverse)
library(googleVis)
library(devtools)
library(tree)

# Bring in Data  
data <- read_delim("student-mat.csv", delim = ";")

# Create Letter Variables 
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
#data$school <- as.factor(data$school)
#data$Pstatus <- as.factor(data$Pstatus)
data$famsize <- as.factor(data$famsize)
data$internet <- as.factor(data$internet)
data$higher <- as.factor(data$higher)


# Select Only Specific Variables 
data <- data %>% select(final, letter, G3, G1, G2, sex, age, school, absences, Pstatus, Medu, Fedu, famsize, famrel, studytime, failures, internet, higher, traveltime, Walc, health)

# ------------------------------------------ # 

# Define server logic for each tab 
shinyServer(function(input, output, session) {


# ---------- TAB 1 ---------------- #
    url <- a("Link to Paper", href = "http://www3.dsi.uminho.pt/pcortez/student.pdf ")
    output$paper <- renderUI({
      tagList("URL Link:", url)
    })
    
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
        numData <- data %>% select(G3, G1, G2, age, absences, Medu, Fedu, famrel, studytime, 
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
    
    # Histogram
    output$Hist <- renderPlot({
        if(input$one) {
        g <- ggplot(data = data, aes_string(x = input$oneNum))
        
        g + geom_histogram(stat = "count")
        }else {}
        })
    
    # Scatter Plot 
    output$scatter <- renderPlot({
        # Create Scatter Plot 
        g <- ggplot(data = data, 
                        aes_string(x = input$xvar, y = input$yvar))
        g + geom_point(position = "jitter")}
    )
    
    # Info for click 
    output$info <- renderText({
        paste0("x=", input$plot_click$x, "\ny=", input$plot_click$y)
    })
    
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
      
# -------------- TAB 4 ------------ #
       
    # Linear regression 
    
        # Data for Regression 
        regData <- data %>% select(G3, G1, G2, letter, age, absences, Medu, Fedu, famrel, studytime, 
                                   failures, traveltime, Walc, health)
        
        modelFunc <- reactive({
            lm(as.formula(paste("G3 ~ ", paste(input$regX, collapse = "+"))), data = regData)
        })
            
        output$linreg <- renderPrint({ 
          if(length(input$regX) > 0){
            model <- modelFunc()
            print(model$coefficients)
        } else {}
        })
    
        output$predictReg <- renderPrint({
          if (length(input$regX) > 0){
            print(predictionFunc())
          } else {
        print("Choose x variable to create model for prediction.")
      }
    })
    
    # Classification Tree  
    
    # Reactive function to create classification tree
    classTree <- reactive({
      tree(as.formula(paste("letter ~ ", paste(input$classVars, collapse = "+"))), 
                        data = regData, split = "deviance")
          })
    
    output$tree <- renderPlot({

      if (length(input$classVars) > 0){
        classModel <- classTree()
        plot(classModel)
        text(classModel)
      } else { }
    })
    
    predictClass <- reactive({
    dataClass <- data.frame(G1 = input$G1valueC, G2 = input$G2valueC, 
                            age = input$ageValueC, absences = input$absencesValueC, 
                            Medu = input$MeduVC, Fedu = input$FeduVC, 
                            studytime = input$studytimeValueC, failures = input$failuresValueC, 
                            traveltime = input$travelVC, Walc = input$WalcVC, Health = input$healthVC)
    predC <- predict(classModel, dataClass, type = "class" )
    predC
    })
    
    output$predictClass <- renderPrint({
      if (length(input$classVars) > 0){
      dataClass <- data.frame(G1 = input$G1valueC, G2 = input$G2valueC, 
                              age = input$ageValueC, absences = input$absencesValueC, 
                              Medu = input$MeduVC, Fedu = input$FeduVC, 
                              studytime = input$studytimeValueC, failures = input$failuresValueC, 
                              traveltime = input$travelVC, Walc = input$WalcVC, Health = input$healthVC)
      classModel <- classTree()
      predC <- predict(classModel, dataClass, type = "class" )
      predC
    } else {
      print("Choose at least one x variable to begin prediction")
    }
      })
# -------------- TAB 5 ------------ # 
    # Output for Tab 5 
    
    output$tab5 <- renderGvis({
      
      data1 <<- data %>% select(!!!input$vars)
        gvisTable(data1)
    })
    
    output$saveData <- downloadHandler(
        filename<- function(){
            paste("data", Sys.Date(), ".csv", sep = "")
        },
        content <- function(file){
            write.csv(data1, file)
        }
    )
})
    
