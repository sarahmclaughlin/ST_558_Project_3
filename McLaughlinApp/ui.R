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
                menuItem("Modeling", tabName = "Model"), 
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
                            
                            # Scatterplot Box 
                            box(title = "Scatterplot", 
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
                                plotOutput("scatter"), 
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
          
          
          
          # ---------------- Fifth Tab ---------------- # 
                tabItem(tabName = "D",
                        fluidRow(
                        # Widget to Save Data Set
                        box( 
                            downloadButton("saveData", "Save Dataset")), 
                        
                        # Show DataSet
                        box(title = "Data", 
                            tableOutput("tab5")))
            )
        )
    )
)
) #FluidPage
) #ShinyUI

 
    



