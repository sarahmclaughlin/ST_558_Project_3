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
               tabItem(tabName = "Intro", 
                       fluidPage(
                         box(title = "Using Data Mining to Predict Secondary School Student Performance", 
                         uiOutput("paper")
                       ))),
               
      # ---------------- Second Tab ---------------- # 
                # Categorical Data Analysis Tab 
                tabItem(tabName = "Cat", 
                        fluidPage(
                          fluidRow(
                            box(title = "Analysis of Categorical Data", 
                                # Select Widget Input 
                                selectInput("CatTable", 
                                           "Pick Variable", 
                                            choices = list("final", "letter", "sex",
                                                           "age", "school", "Pstatus", "famsize", "internet", 
                                                           "higher"), 
                                            multiple = FALSE)), 
                            # One Way Table 
                            box(title = "One Way Table", 
                                tableOutput("catTable"))), 
                            
                            # Bar Graphs 
                          fluidRow(
                            box(title = "Bar Graphs", 
                                # Click to Sort by a Variable 
                                checkboxInput("color", "Color by Second Variable?"), 
                                    
                                    conditionalPanel(condition = "input.color", 
                                        selectInput("CatCol", 
                                            "Color by Variable", 
                                            choices = list("sex", "school", "Pstatus", "internet", "higher",
                                                           "famsize"), 
                                            multiple = FALSE)), 
                                plotOutput("catGraph")))
                        )),
                
                # Quantitative Data Analysis Tab 
                tabItem(tabName = "Quant", 
                        fluidPage( 
                          fluidRow(
                            # Title Box
                            box(title = "Six Number Summary", 
                            # Click to analyze only one variable  
                                checkboxInput("one", "Analyze One Numeric Variable?"), 
                                    conditionalPanel(condition = "input.one", 
                                                     selectInput("oneNum", 
                                                                 "Variable", 
                                                                 choices = list("G3", "G1", "G2", "age", 
                                                                                "absences", "Medu",
                                                                                "Fedu", "famrel", "studytime",
                                                                                "failures", "traveltime", "Walc",
                                                                                "health"), multiple = FALSE)), 
                                uiOutput("numsums"))), 
                            
                          fluidRow(
                            box(title = "Histogram of One Variable",
                                plotOutput("Hist")),
                            
                            # Scatterplot Box 
                            box(title = "Scatterplot for Two Variables", 
                                selectInput("xvar", "X", 
                                            choices = list("G3", "G1", "G2", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health" ), multiple = FALSE), 
                                selectInput("yvar", "Y", 
                                            choices = list("G3", "G1", "G2", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health"), multiple = FALSE), 
                                plotOutput("scatter", click = "plot_click"),
                                verbatimTextOutput("info"),
                            
                                # Save Scatter Plot 
                                downloadButton("savescat", "Download"))
                            ))),
                
          # ---------------- Third Tab ---------------- #  
                tabItem(tabName = "PCA", 
                        fluidPage(
                          fluidRow(
                          # PCA Output 
                            box(title = "Principal Component Analysis", 
                                selectInput("PCAVar", "Variables", 
                                            choices = list("G3", "G1", "G2", "age", "absences", "Medu",
                                                           "Fedu", "famrel", "studytime",
                                                           "failures", "traveltime", "Walc",
                                                           "health"), multiple = TRUE)),
                            box(title = "PCA Output", 
                                verbatimTextOutput("PCAOutput"))),
                          
                          fluidRow(
                          # Biplot 
                            box(title = "BiPlot", 
                                plotOutput("biplot")), 
                          
                          # Appropriateness of PCs
                            box(title = "Appropriateness of PCs", 
                                plotOutput("approp")))
                        )
                        ),
      
          # ---------------- Fourth Tab ---------------- # 
                # Linear Regression Tab
                tabItem(tabName = "LinReg", 
                        fluidPage(
                         box(title = "General Linear Regression Equation", 
                              withMathJax("$$Y_i =\\beta_0 +\\beta_1{X_1}+...+\\epsilon_i$$")),
                          box(title = "Linear Regression", 
                              selectInput("regX", "Pick X Variable(s) for Linear Regression", 
                                          choices = list("G3", "G1", "G2", "age", "absences", "Medu",
                                                         "Fedu", "famrel", "studytime",
                                                         "failures", "traveltime", "Walc",
                                                         "health"), multiple = TRUE), 
                              verbatimTextOutput("linreg")), 
                          box(title = "Values for Prediction", 
                              h5("Insert values for prediction below"), 
                              # Var 1 G3, school, absences, studytime, failures
                            numericInput("G1value", "G1", value = 0, min = 0, max = 20, step = 1), 
                            numericInput("G2value", "G2", value = 0, min = 0, max = 20, step = 1), 
                            numericInput("ageValue", "Age", value = 0, min = 15, max = 22, step = 1),
                            numericInput("absencesValue", "Absences", value = 0, min = 0, max = 75, step = 1),
                              h6("For Mother's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 9th
                                 Grade, 3 = Secondary Education, 4 = High Education"),
                            numericInput("MeduV", "Mother's Education", value = 0, min = 0, max = 4, step = 1), 
                              h6("For Father's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 9th
                                 Grade, 3 = Secondary Education, 4 = High Education"), 
                            numericInput("FeduV", "Father's Education", value = 0, min = 0, max = 4, step = 1), 
                              h6("For Quality of Family Relationship, from 1 - very bad to 5 - excellent"), 
                            numericInput("famrelV", "Family Relationship", value = 0, min = 1, max = 5, step = 1), 
                              h6("For study time, 1 = Less Than Two Hours, 2 = 2-5 Hours, 3= 5-10 Hours, 4 = More 
                                 than 10 Hours"),
                            numericInput("studytimeValue", "Studytime", value = 0, min = 0, max = 4, step = 1 ), 
                            numericInput("failuresValue", "Number of Failures", value = 0, min = 0, 
                                         max = 3, step = 1), 
                            numericInput("travelV", "Travel Time (in hours)", value = 0, min = 1, max = 4, 
                                         step = 1), 
                              h6("For Weekly Alcohol Consumption, from 1 - very low to 5 - very high"), 
                            numericInput("WalcV", "Weekly Alcohol Consumption", value = 0, min = 1, max = 5, 
                                         step = 1), 
                              h6("For Current Health Status, from 1 - very bad to 5 - very good"), 
                            numericInput("healthV", "Current Health Status", value = 0, min = 1, max = 5, step = 1)
                        ),
                        
                        # Prediction
                        box(title = "Prediction using Model Created Above", 
                            verbatimTextOutput("predictReg")))),
      
                # Classification Tree 
                tabItem(tabName = "Class", 
                        fluidPage(
                        fluidRow(
                        box(title = "Pick variables for Classification Tree", 
                            selectInput("classVars", "Variables", 
                                        choices = list("age", "absences", "studytime", "failures"), 
                                        multiple = TRUE)), 
                        box(title = "Classification Tree to Predict Letter Grade", 
                        plotOutput("tree"))),
                        fluidRow(
                          box(title = "Assign Variables for Prediction", 
                              numericInput("ageValueC", "Age", value = 0, min = 15, max = 22, step = 1),
                              numericInput("absencesValueC", "Absences", value = 0, min = 0, max = 75, step = 1), 
                              h6("For study time, Less Than Two Hours = 1, 2-5 Hours = 2, 5-10 Hours = 3, More than 10 Hours = 4"),
                              numericInput("studytimeValueC", "Studytime", value = 0, min = 0, max = 4, step = 1 ), 
                              numericInput("failuresValueC", "Number of Failures", value = 0, min = 0, max = 3, step = 1)), 
                          box(title = "Prediction", 
                              verbatimTextOutput("predictClass"))))), 
                        
          
          
          # ---------------- Fifth Tab ---------------- # 
                tabItem(tabName = "D",
                        
                        # Widget to Save Data Set
                        fluidRow(
                          box(title = "Click Variables that you would like included in your dataset",
                              selectInput("vars", "Variables", 
                                          choices = list("final", "letter", "G3", "sex", 
                                                         "age", "school", "absences", "Pstatus", 
                                                         "Medu", "Fedu", "famsize", "famrel", 
                                                         "studytime", "failures", "internet", 
                                                         "higher", "traveltime", "Walc", "health"), 
                                                    multiple = TRUE)), 
                              box(downloadButton("saveData", "Save Dataset")), 
                          
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

 
    



