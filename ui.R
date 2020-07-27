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
                         # Sub tabs
                         menuSubItem("Categorial Data", tabName = "Cat"), 
                         menuSubItem("Quantitative Data", tabName = "Quant")), 
                # Third Tab 
                menuItem("Principal Component Analysis", tabName = "PCA"), 
                # Fourth Tab 
                menuItem("Modeling", tabName = "Model", 
                         # Sub tabs
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
                         h3("Using Data Mining to Predict Secondary 
                            School Student Performance"), 
                         h4(strong("An application by Sarah McLaughlin")),
                         h5(em("Based off of a Paper by Paulo Cortez and 
                               Alice Silva of the University of Minho")), 
                         box(uiOutput("paper")), 
                         # Introduction 
                         box(title = h2(strong("Introduction")), 
                             "In this application, I will use the Mathmatics class data from the study
                              conducted by Paulo Cortez and Alice Silva. In the study, Cortez and Silva 
                             sought to predict the final grade for a math class from data pulled from 
                             395 students. The study was conducted via surveys of the students and 
                             records from the school."),
                         # Variables
                         box(title = h3(strong("Variables")), 
                             "For this app, I used the following variables: ", 
                             em("final, letter, G3, G1, G2, sex, age, school, 
                                absences, Pstatus, Medu, Fedu, famsize, famrel, 
                                studytime, failures, internet, higher, traveltime, 
                                Walc, health"), ". I created the ", em("final"), 
                             " and ", em("letter"), " variables via the mutate 
                             function. The ", em("final"), " variable was a 
                             Pass/Fail variable. If a student earned a 10 or above 
                             on their final grade ", em("(G3 variable)"), ", they 
                             passed. I also assigned the ", em("G3 Variable"), 
                             " to another variable called ", em("letter"), ", which 
                             was designated as follows: ", 
                             strong("A: 16-20, B: 14-15, C: 12-13, D: 10-11, 
                                    F: 0-9", " ."), 
                             br(),
                             br(),
                             # Explanation of variables
                             strong("Explanation of Variables"), 
                             br(), 
                             strong("G1/G2: "), "first and second period grades, respectively", 
                             br(), 
                             strong("sex: "), "sex of student", 
                             br(), 
                             strong("school: "), "Gabriel Pereira or 
                             Mousinho da Silveira", 
                             br(), 
                             strong("absences: "), "number of absences", 
                             br(), 
                             strong("Pstatus: "), "parent's cohabitation 
                             status (Together or Apart)",
                             br(), 
                             strong("Medu/Fedu: "), "Mother/Father Education Level", 
                             br(), 
                             strong("famsize: "), "Family size (less than or equal 
                             to 3, more than 3)", 
                             br(), 
                             strong("famrel: "), "Family relationships on a 
                             scale of 1 to 5",
                             br(), 
                             strong("studytime: "), "The amount of weekly 
                             study time (1 = less than 2 hours, 2 = 2-5 hours, 
                             3 = 5-10 hours, 4 = more than 10 hours)", 
                             br(), 
                             strong("failures: "), "The number of failures", 
                             br(), 
                             strong("internet: "), "Internet Accesss: Yes or No", 
                             br(), 
                             strong("higher: "), "Desire to Pursue Higher Education: Yes or No", 
                             br(), 
                             strong("traveltime: "), "Time to Get to School (1 = less than 15 minutes, 
                             2 = 15-30 minutes, 3 = 30 minutes to 1 hour, 4 = more than 1 hour)", 
                             br(), 
                             strong("Walc: "), "Weekly Alcohol Consumption on a scale of 1 to 5", 
                             br(), 
                             strong("health: "), "Health on a scale of 1 (very bad) to 5 (very good)"
                         ), 
                         # Abilities of application
                         box(title = h3("Ability of Application"), 
                             h4(strong("Data Exploration")), 
                             br(), 
                             "This app will perform basic data exploration in two parts: Numerical Data 
                             and Categorical Data. For the categorical data, one way tables and bar graphs will be 
                             generated. For the numerical data, six number summaries, histograms, and 
                             scatterplots will be generated. The user will define which variables are used. The 
                             user will also have the option to save the scatterplot created as a png. Within the 
                             scatterplot, the user also has the option to click on the plot and find a specific 
                             value of a point.", 
                             br(), 
                             br(),
                             h4(strong("Principal Component Analysis")), 
                             br(), 
                             "This app will generate principal component analysis for the user defined variables. 
                             The output of the analysis is given, as well as a biplot of the first two principal 
                             components and two graphs that shows the appropriateness of each 
                             principal component.", 
                             br(), 
                             br(),
                             h4(strong("Modeling")), 
                             br(),
                             h5(em("Linear Regression Model")), 
                             br(), 
                             "Here, the user can define which variables are used to create a linear regression 
                             model for predicting the final grade (G3). Output is given and the user is able to 
                             define specific variables and use the model created to predict the outcome.", 
                             br(), 
                             h5(em("Classification Tree")), 
                             br(), 
                             "Here, the user again defines which variables are used to create a 
                             classification tree. The classification tree is shown and the user 
                             can define variables to predict the final letter grade.", 
                             br(), 
                             br(), 
                             h4(strong("Data")), 
                             br(), 
                             "On this tab, the user can pick which variables it would like included in the 
                             data set. The user can also click a button to download the dataset."
                          
                             
                         
                         
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
                                    # Dynamic UI
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
                            
                            # Scatterplot Box with Dynamic Title
                            box(title = uiOutput("ScatTitle"), 
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
                             # User picks variables for linear regression model
                              selectInput("regX", "Pick X Variable(s) for Linear Regression", 
                                          choices = list("G1", "G2", "age", "absences", "Medu",
                                                         "Fedu", "famrel", "studytime",
                                                         "failures", "traveltime", "Walc",
                                                         "health"), multiple = TRUE), 
                              verbatimTextOutput("linreg")), 
                          box(title = "Values for Prediction", 
                              h5("Insert values for prediction below"), 
                              # User input variable values
                            numericInput("G1value", "G1", value = 0, min = 0, max = 20, step = 1), 
                            numericInput("G2value", "G2", value = 0, min = 0, max = 20, step = 1), 
                            numericInput("ageValue", "Age", value = 0, min = 15, max = 22, step = 1),
                            numericInput("absencesValue", "Absences", value = 0, min = 0, max = 75, step = 1),
                              h6("For Mother's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 9th
                                 Grade, 3 = Secondary Education, 4 = Higher Education"),
                            numericInput("MeduV", "Mother's Education", value = 0, min = 0, max = 4, step = 1), 
                              h6("For Father's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 9th
                                 Grade, 3 = Secondary Education, 4 = Higher Education"), 
                            numericInput("FeduV", "Father's Education", value = 0, min = 0, max = 4, step = 1), 
                              h6("For Quality of Family Relationship, from 1 - very bad to 5 - excellent"), 
                            numericInput("famrelV", "Family Relationship", value = 0, min = 1, max = 5, step = 1), 
                              h6("For study time, 1 = Less Than Two Hours, 2 = 2-5 Hours, 3= 5-10 Hours, 4 = More 
                                 than 10 Hours"),
                            numericInput("studytimeValue", "Studytime", value = 0, min = 0, max = 4, step = 1 ), 
                            numericInput("failuresValue", "Number of Failures", value = 0, min = 0, 
                                         max = 3, step = 1), 
                            h6("For travel time, 1 = less than 15 minutes, 2 = 15-30 minutes, 
                               3 = 30 minutes to 1 hour, 4 = more than 1 hour"), 
                            numericInput("travelV", "Travel Time", value = 0, min = 1, max = 4, 
                                         step = 1), 
                              h6("For Weekly Alcohol Consumption, from 1 - very low to 5 - very high"), 
                            numericInput("WalcV", "Weekly Alcohol Consumption", value = 0, min = 1, max = 5, 
                                         step = 1), 
                              h6("For Current Health Status, from 1 - very bad to 5 - very good"), 
                            numericInput("healthV", "Current Health Status", value = 0, min = 1, max = 5, step = 1)
                        ),
                        
                        # Prediction
                        box(title = "Prediction of Final Grade (G3) using Model Created Above", 
                            verbatimTextOutput("predictReg")))),
      
                # Classification Tree 
                tabItem(tabName = "Class", 
                        fluidPage(
                        fluidRow(
                        box(title = "Pick variables for Classification Tree", 
                            # User pick variables for classification tree
                            selectInput("classVars", "Variables", 
                                        choices = list("G1", "G2", "age", "absences", "Medu",
                                                       "Fedu", "studytime",
                                                       "failures", "traveltime", "Walc",
                                                       "health"), 
                                        multiple = TRUE)), 
                        box(title = "Classification Tree to Predict Letter Grade", 
                        plotOutput("tree"))),
                        fluidRow(
                          box(title = "Assign Variables for Prediction", 
                              # User picks values of variables for prediction
                              numericInput("G1valueC", "G1", value = 0, min = 0, max = 20, step = 1), 
                              numericInput("G2valueC", "G2", value = 0, min = 0, max = 20, step = 1), 
                              numericInput("ageValueC", "Age", value = 0, min = 15, max = 22, step = 1),
                              numericInput("absencesValueC", "Absences", value = 0, min = 0, max = 75, step = 1), 
                                h6("For Mother's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 
                                   9th Grade, 3 = Secondary Education, 4 = Higher Education"),
                              numericInput("MeduVC", "Mother's Education", value = 0, min = 0, max = 4, step = 1), 
                                h6("For Father's Education, 0 = No Education, 1 = Primary (4th Grade), 2 = 5th to 
                                   9th Grade, 3 = Secondary Education, 4 = Higher Education"),
                              numericInput("FeduVC", "Father's Education", value = 0, min = 0, max = 4, step = 1), 
                                h6("For study time, Less Than Two Hours = 1, 2-5 Hours = 2, 5-10 Hours = 3, More 
                                   than 10 Hours = 4"),
                              numericInput("studytimeValueC", "Studytime", value = 0, min = 0, max = 4, step = 1 ),
                              numericInput("failuresValueC", "Number of Failures", value = 0, min = 0, max = 3, 
                                           step = 1),
                              numericInput("travelVC", "Travel Time (in hours)", value = 0, min = 1, max = 4, 
                                           step = 1), 
                              h6("For Weekly Alcohol Consumption, from 1 - very low to 5 - very high"), 
                              numericInput("WalcVC", "Weekly Alcohol Consumption", value = 0, min = 1, max = 5, 
                                           step = 1), 
                              h6("For Current Health Status, from 1 - very bad to 5 - very good"), 
                              numericInput("healthVC", "Current Health Status", value = 0, min = 1, max = 5, 
                                           step =1)), 
                          # Prediction
                          box(title = "Letter Grade Prediction using Above Classification Tree", 
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

 
    



