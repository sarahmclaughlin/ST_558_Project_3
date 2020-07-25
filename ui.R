# Sarah McLaughlin 
# ST558 Project 3
# July 23, 2020 
#

library(shiny)
library(shinydashboard)

# UI 
shinyUI(fluidPage(

    # Application title
   titlePanel("Using Data Mining to Predict Secondary School Performance in Math Class"),

    # Create Dashboard  
    dashboardPage(
        dashboardHeader(title = "Dashboard"),
        dashboardSidebar(
            sidebarMenu(
    # Create Tabs 
                # First Tab 
                menuItem("Introduction", tabName = "Intro"),
                # Second Tab 
                menuItem("Data Exploration", tabName = "DE", 
                         menuSubItem("Categorial Data", tabName = "Cat"), 
                         menuSubItem("Quantitative Data", tabName = "Quant")), 
                # Third Tab 
                menuItem("Principal Component Analysis", tabName = "PCA"), 
                # Fourth Tab 
                menuItem("Modeling", tabName = "Model", 
                         menuSubItem("Linear Regression Model", tabName = "LinReg"), 
                         menuSubItem("Classification Tree", tabName = "Class")), 
                # Fifth Tab 
                menuItem("Data", tabName = "D")
            )
        ), 
        
        # Dashboard Body 
        dashboardBody(
            tabItems(
      # ---------------- First Tab ----------------- # 
                
      # ---------------- Second Tab ---------------- # 
                # Categorical Data Analysis Tab 
                tabItem(tabName = "Cat", 
                        fluidPage(
                            box(title = "Analysis of Categorical Data", 
                                # Select Widget Input 
                                selectInput("CatTable", 
                                           "Pick Variable", 
                                            choices = list("final", "letter", "sex",
                                                           "age", "school", "Pstatus", "internet", "higher"), 
                                            multiple = FALSE)), 
                            # One Way Table 
                            box(title = "One Way Table", 
                                tableOutput("catTable")), 
                            
                            # Bar Graphs 
                            box(title = "Bar Graphs", 
                                # Click to Sort by a Variable 
                                checkboxInput("color", "Color by Second Variable?"), 
                                    
                                    conditionalPanel(condition = "input.color", 
                                        selectInput("CatCol", 
                                            "Color by Variable", 
                                            choices = list("sex", "school", "Pstatus", "internet", "higher"), 
                                            multiple = FALSE)), 
                                plotOutput("catGraph"))
                        )),
                
                # Quantitative Data Analysis Tab 
                tabItem(tabName = "Quant", 
                        fluidPage( 
                            # Title Box
                            box(title = "Six Number Summary", 
                            # Click to analyze only one variable  
                                checkboxInput("one", "Analyze One Numeric Variable?"), 
                                    conditionalPanel(condition = "input.one", 
                                                     selectInput("oneNum", 
                                                                 "Variable", 
                                                                 choices = list("G3", "age", "absences", "Medu",
                                                                                "Fedu", "famrel", "studytime",
                                                                                "failures", "traveltime", "Walc",
                                                                                "health"), multiple = FALSE))), 
                                uiOutput("numsums"), 
                            br(), 
                            
                            box(title = "Histogram of One Variable",
                                plotOutput("Hist")),
                            
                            # Scatterplot Box 
                            box(title = "Scatterplot for Two Variables", 
                                selectInput("xvar", "X", 
                                            choices = list("G3", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health" ), multiple = FALSE), 
                                selectInput("yvar", "Y", 
                                            choices = list("G3", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health"), multiple = FALSE), 
                                plotOutput("scatter", click = "plot_click"),
                                verbatimTextOutput("info"),
                            
                                # Save Scatter Plot 
                                downloadButton("savescat", "Download")
                            ))),
                
          # ---------------- Third Tab ---------------- #  
                tabItem(tabName = "PCA", 
                        fluidPage(
                          # PCA Output 
                            box(title = "Principal Component Analysis", 
                                selectInput("PCAVar", "Variables", 
                                            choices = list("G3", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health"), multiple = TRUE)),
                            box(title = "PCA Output", 
                                verbatimTextOutput("PCAOutput")), 
                          # Biplot 
                            box(title = "BiPlot", 
                                plotOutput("biplot")), 
                          
                          # Appropriateness of PCs
                            box(title = "Appropriateness of PCs", 
                                plotOutput("approp"))
                        )
                        ),
          # ---------------- Fourth Tab ---------------- # 
                # Linear Regression Tab
                tabItem(tabName = "LinReg", 
                        fluidPage(
                          box(title = "Linear Regression", 
                              selectInput("regX", "Pick X Variable(s) for Linear Regression", 
                                          choices = list("sex", "age", "school", 
                                                         "absences", "studytime", "failures"), 
                                          multiple = TRUE), 
                              verbatimTextOutput("linreg")), 
                          box(title = "Values for Prediction", 
                              h5("Insert values for prediction below"), 
                              # Var 1 G3, sex, age, school, absences, studytime, failures
                              h6("For sex, Female = 0, Male = 1"),
                            numericInput("sexValue","Sex", value = NA, min = 0, max = 1, step = 1), 
                            numericInput("ageValue", "Age", value = 0, min = 15, max = 22, step = 1), 
                              h6("For school, Gabriel Pereira = 0, Mousinho da Silveira = 1"), 
                            numericInput("schoolValue", "School", value = 0, min = 0, max = 1, step = 1 ), 
                            numericInput("absencesValue", "Absences", value = 0, min = 0, max = 75, step = 1), 
                              h6("For study time, Less Than Two Hours = 1, 2-5 Hours = 2, 5-10 Hours = 3, More than 10 Hours = 4"),
                            numericInput("studytimeValue", "Studytime", value = 0, min = 0, max = 4, step = 1 ), 
                            numericInput("failuresValue", "Number of Failures", value = 0, min = 0, max = 3, step = 1)
                        ))),
          
          
          # ---------------- Fifth Tab ---------------- # 
                tabItem(tabName = "D",
                        # Widget to Save Data Set
                        fluidRow(box( 
                          downloadButton("saveData", "Save Dataset")), 
                          
                        fluidRow(
                          # Show DataSet
                          box(title = "Data", 
                              tableOutput("tab5")))

                        
                        
            )
        )
    )
)
)
) #FluidPage
) #ShinyUI

 
    



