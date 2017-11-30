# Loading Necessary files
library(RColorBrewer)
library(tm)
library(wordcloud)

# Defining the Main server function 
shinyServer(function(input, output) {
  
  # Define function that creates a document term matrix
  TM <- function(text) {
    # Convert text to a corpus 
    myCorpus = Corpus(VectorSource(text))
    # Transform to lower case
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    # Remove punctuation
    myCorpus = tm_map(myCorpus, removePunctuation)
    # Remove numbers
    myCorpus = tm_map(myCorpus, removeNumbers)
    # Remove stop words
    if ("Remove stop words" %in% input$options) {
      myCorpus = tm_map(myCorpus, removeWords, stopwords("SMART"))
    }
    # Create the document-term matrix 
    DTM = TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1))
    m = as.matrix(myDTM)
    sort(rowSums(m), decreasing = TRUE)
  }
  
  # Switch between textInput and fileInput 
  #output$method <- renderUI({
  #  if (is.null(input$input_type))
  #    return()
  #  switch(input$input_type,
  #         "Upload a text file" = fileInput("file",
  #                            label = "Upload a text file")
  #         )
  #  })
  
  # Define a reactive expression for the document term matrix
  terms <- eventReactive(input$create, {
    
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        TM(input$text)
        #switch(input$input_type,
        #       "Paste text" = DTM(input$text), #DTM(input$text),
        #       "Upload text file" = DTM(input$file)
        #       )
      })
    })
  })
  
  
  # Create word cloud output
  wordcloud_rep = repeatable(wordcloud)
  output$cloud = renderPlot({
    v = terms()
    pal = "black"
    if("Color" %in% input$options) {
      pal = brewer.pal(8, "Dark2")
    }
    wordcloud_rep(words = names(v),
                  freq = v,
                  scale=c(4,0.5),
                  min.freq = input$min_frequency,
                  max.words= input$max_words,
                  colors=pal
    )
  })
})

