#============================================packages
library(shiny)
library(shinydashboard)
library(reticulate)
library(readr)
library(readxl)
library(tm)
library(SnowballC)
library(wordcloud2)
library(RColorBrewer)
library(tidyverse)
library(tidytext)
# ========================================== UI page
ui <- dashboardPage(
  dashboardHeader(title = "ABSA dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Upload", tabName = "Upload", icon = icon("upload")),
      menuItem("approaches", tabName = "approaches", icon = icon("fas fa-tree")),
      menuItem("Chart",tabName = "Chart",icon = icon("line-chart")),
      menuItem("Export", tabName = "Export", icon=icon("download")),
      menuItem("Admin", tabName = "Admin", icon = icon("home"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "Upload",
              fluidRow(
                column(10,offset = 0.5,
                       box(title = "UPLOAD",fileInput("file1", "Choose CSV, XLSX or TXT file",
                                                      accept = c(".xlsx", ".csv", ".txt")
                       ),
                       #tags$hr(),
                       #checkboxInput("header", "Header", TRUE)
                       ),
                       br(),
                  
                ),
                column(10,offset = 0.5,box(title = "Text-Box",textAreaInput("text", "Enter the review : ",resize = "vertical"),
                ))
              ),
              tableOutput("table"),
              #tableOutput("table1")
             
              #tableOutput("contents")
              
              
      ),
      
      
      tabItem(tabName = "approaches",
              selectInput("app", "ABSA 7 SUBTASK:",
                          list("","Aspect Term Extraction for text","Aspect Term Extraction for csv","Opinion Term Extraction","Aspect-Level Sentiment Classification",
                               "Aspect-Oriented Opinion Extraction","Aspect Term Extraction and Sentiment Classification",
                               "Pair Extraction","Triplet Extraction","BERT")),
              
              actionButton("submit","SUBMIT"),
              
              br(),hr(),
              
              box(height = 70,
              uiOutput("ui_1"),
              uiOutput("ui_2"),
              uiOutput('ui_3'),
              uiOutput('ui_4'),
              uiOutput('ui_5'),
              uiOutput('ui_6'),br(),br(),br(),
              tableOutput('data_table2'),
              tableOutput('data_table1')
              ),
              br(),br(),
              
              
              
              
              
      ),
      tabItem(tabName = "Chart",
              fluidPage(
                actionButton("generate_wc","Generate Wordcloud"),
                actionButton("generate_plot","Generate Plot"),
                wordcloud2Output("wc"),
                plotOutput("barplot"),
                br(),
                
                
              )
              
      ),
      tabItem(tabName = "Export",
              fluidRow(
                box(title = "Export",width = 3,status = "primary",
                    solidHeader = TRUE,
                    collapsible = TRUE,
                    radioButtons(inputId = "var1",label = "select the file type", choices = list("png","pdf")),
                    br(),
                    
                    
                    downloadButton("downloadData", "Download WordCloud"),
                    br(),
                    
                    downloadButton(outputId = "down", label = "Download the plot")))),
      
      tabItem(tabName = "Admin",
            fluidPage(
                tabsetPanel(
                tabPanel("Admin",
                         # box(title = "Admin page",width = 5,status = "primary",
                         #     solidHeader = T,
                         #     collapsible = T,
                             textInput("username", label = "User name :"),
                             passwordInput("password", label = "Password : "),br(),
                             actionButton("update",label = "Update")
                        ),
                tabPanel("Tab 2",
                         # add UI elements for the second tab here
                ))
                
      
    )
  )
)
)
)
