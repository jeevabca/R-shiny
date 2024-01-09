server <- function(input, output,session){
  
  data <- reactive({
    # Check if a file was uploaded
    req(input$file1)
    file <- input$file1$datapath
    extension <- tools::file_ext(file)
    if (extension == "csv") {
      read.csv(file, header = TRUE)
    } else if (extension == "xlsx") {
      read_excel(file, sheet = 1)
    } else if (extension == "txt"){
      read_file(file)
    }
    })
  
  output$table <- renderTable({
    data()
  })
  
 
  
  #source_python('C:/Users/Dell/Desktop/New folder/r login demo/login demo/ATE.py')
  content_1 <- eventReactive(input$submit,{
    req(input$file1)
    if (input$app == "Aspect Term Extraction for text")
      ATE(read_file(input$file1$datapath))
    
    
      
  })
  #source_python('C:/Users/Dell/Desktop/New folder/r login demo/login demo/OTE.py')
  content_2 <- eventReactive(input$submit,{
    file <- input$file1
    if (input$app == "Opinion Term Extraction")
      OTE(read_file(file$datapath))
  
  })

  #source_python('C:/Users/Dell/Desktop/New folder/r login demo/login demo/ALSC.py')
  content_3 <- eventReactive(input$submit,{
    file <- input$file1
    if (input$app == "Aspect-Level Sentiment Classification")
      ALSC(read_file(file$datapath))
    else if (input$app == "Aspect-Level Sentiment Classification")
      data1(data11)
      
  })
  
  out_1 <- eventReactive(input$submit, {
    text <- input$text
    if (input$app == "Aspect Term Extraction for text")
      ATE(text)
    })
  
  out_2 <- eventReactive(input$submit, {
    text <- input$text
    if (input$app == "Opinion Term Extraction")
      OTE(text)
  })
  
  out_3 <- eventReactive(input$submit, {
    text <- input$text
    if (input$app == "Aspect-Level Sentiment Classification")
      ALSC(text)
  })
  
  output$ui_1 <- renderUI({
    content_1()
    })
  output$ui_2 <- renderUI({
    out_1()
  })
  output$ui_3 <- renderUI({
    content_2()
  })
  output$ui_4 <- renderUI({
    out_2()
  })
  output$ui_5 <- renderUI({
    content_3()
  })
  output$ui_6 <- renderUI({
    out_3()
  })
  
  #source_python('C:/Users/Dell/Desktop/New folder/r login demo/login demo/ATE_for_csv.py')
  ate_csv <- eventReactive(input$submit, {
    # Get the data from the file_data reactive variable
    data1 <- data()
    if (input$app == "Aspect Term Extraction for csv")
      ATE_for_csv(data1)
    })
  output$data_table1 <- renderTable({
    ate_csv()
  })
  
  #source_python('C:/Users/Dell/Desktop/New folder/r login demo/login demo/ate_sc.py')
  ate_sc1 <- eventReactive(input$submit, {
    data1 <- data()
    if (input$app == "Aspect Term Extraction and Sentiment Classification")
      call(data1,'text')
  })
  output$data_table2 <- renderTable({
    ate_sc1()
  })
  
  
  
 
  # Admin server side
  
    observeEvent(input$update, {
      source('C:/Users/Dell/Desktop/New folder/r login demo/login demo/jeeva/R_MySql.R')
      user <- input$username
      pass <- input$password
      query <- sprintf("INSERT INTO admin (user_name, password) VALUES ('%s', '%s')", user, pass)
      dbSendQuery(con, query)
      showModal(modalDialog("Username and password updated!"))
    })
    
    docs <- reactive({
      data <- data()
      if(is.null(data)) {
        return(NULL)
      }
      Corpus(VectorSource(data$text)) %>%
        # Remove special characters
        tm_map(content_transformer(gsub), pattern = "/|@|\\|", replacement = " ") %>%
        # Convert to lowercase
        tm_map(content_transformer(tolower)) %>%
        # Remove numbers
        tm_map(removeNumbers) %>%
        # Remove English stopwords
        tm_map(removeWords, stopwords("english")) %>%
        # Remove custom stopwords
        tm_map(removeWords, c("blabla1", "blabla2")) %>%
        # Remove punctuations
        tm_map(removePunctuation) %>%
        # Strip whitespace
        tm_map(stripWhitespace) %>%
        # Stem words
        tm_map(stemDocument)
    })
    
    # Generate word cloud from preprocessed text data
    observeEvent(input$generate_wc, {
      docs <- docs()
      if(is.null(docs)) {
        return(NULL)
      }
      dtm <- TermDocumentMatrix(docs)
      m <- as.matrix(dtm)
      v <- sort(rowSums(m),decreasing=TRUE)
      d <- data.frame(word = names(v),freq=v)
      output$wc <- renderWordcloud2({
        wordcloud2(d, size = 0.8, shape = "circle", rotateRatio = 0.5,
                   backgroundColor = "#f1f1f1", color = brewer.pal(8, "Dark2"))
      })
    })
  
    output$downloadData <- downloadHandler(
      filename = function(){
        paste("wc",input$var1,sep = ".")
      },
      content = function(file){
        if(input$var1 == "png")
          png(file)
        else
          pdf(file)
        wordcloud2Output("wc")
        dev.off()
      }
    )
    observeEvent(input$generate_plot,{
    # bar plot
    # Create word frequency table
    word_freq <- reactive({
      data() %>% 
        unnest_tokens(word, text) %>%
        count(word) %>%
        arrange(desc(n))
    })
    
    # Create bar plot
    output$barplot <- renderPlot({
      ggplot(word_freq(), aes(x = word, y = n)) +
        geom_bar(stat = "identity") +
        xlab("Word") +
        ylab("Frequency") +
        ggtitle("Word Frequency Bar Plot")
    })
    })
    
    output$down <- downloadHandler(
      filename = function(){
        paste("barplot",input$var1,sep = ".")
      },
      content = function(file){
        if(input$var1 == "png")
          png(file)
        else
          pdf(file)
        plotOutput("barplot")
        dev.off()
      }
    )
    
}
