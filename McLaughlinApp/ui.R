# Sarah McLaughlin 
# ST558 Project 3
# July 23, 2020 
#

library(shiny)
library(shinydashboard)

# UI 
shinyUI(fluidPage(

    # Application title
   titlePanel("McLauglin APP: Using Data Mining to Predict Secondary School Performance in Math Class"),

    # Create Dashboard  
    dashboardPage(
        dashboardHeader(title = "Dashboard"),
        dashboardSidebar(
            sidebarMenu(
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
                
                # Categorical Data Analysis Tab 
                tabItem(tabName = "Cat", 
                        fluidRow(
                            # Type of Data Widget
                            box(title = "Analysis of Categorical Data", 
                                # Select Widget Input 
                                selectInput("CatTable", 
                                           "Pick Variable", 
                                            choices = list("final", "letter", "sex","age", "school", "Pstatus", "internet", "higher"), 
                                            multiple = FALSE)), 
                            # One Way Table 
                            box(title = "One Way Table", 
                                tableOutput("catTable")), 
                            
                            # Bar Graphs 
                            box(title = "Bar Graphs", 
                                # Click to Sort by a Variable 
                                selectInput("CatCol", 
                                            "Color by Variable", 
                                            choices = list("None", "sex", "school", "Pstatus", "internet", "higher"), 
                                            multiple = FALSE), 
                                plotOutput("catGraph"))
                        )),
                
                # Quantitative Data Analysis Tab 
                tabItem(tabname = "Quant", 
                        fluidRow( 
                            box(
                                #
                            ))), 
                
                # Fifth Tab 
                tabItem(tabName = "D",
                        # Widget to Save Data Set
                        box( 
                            actionButton("save", "Save Dataset")), 
                        
                        # Show DataSet
                        box(title = "Data", 
                            tableOutput("tab5")))
            )
        )
    )
    
    # Sidebar with ability for user to pick categorial or quantitative

        # Show a plot of the generated distribution
       # mainPanel(
           # tabsetPanel(
              #  tabPanel("Information", ), 
               # tabPanel("Data Exploration"), 
               # tabPanel("Principal Component Analysis"), 
               # tabPanel("Modeling"), 
               # tabPanel("Data"))
           # )
      #  )
   # )
  )
)

