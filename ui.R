# ui.R

shinyUI(fluidPage(
  titlePanel("Word Cloud Generator"),
  
  sidebarLayout(
    sidebarPanel(
      
      #radioButtons("input_type",
      #             label = "Choose an input method:",
      #             choices = c("Enter or paste text","or",
      #                         "Upload a text file"),
      #             selected = "Paste text"
      #            ),
      
      #uiOutput("method"),
      
      
      textInput("text",
                label = "Paste text",
                #value = "Paste text here",
                placeholder = "Paste text here"
      ),
      
      sliderInput("min_frequency",
                  label = "Minimum frequency:",
                  min = 1, max = 100, value = 1
      ),
      
      sliderInput("max_words",
                  label = "Maximum number of words:",
                  min = 1, max = 300, value = 300
      ),
      
      checkboxGroupInput("options",
                         label = "Options:",
                         choices = c("Color", "Remove stop words"),
                         selected = c("Color", "Remove stop words")
      ),
      
      actionButton("create",
                   label = "Create wordcloud")
    ),
    
    mainPanel(
      
      plotOutput("cloud"), 
      
      helpText( 
        p("Don't know what text to use? Find one on",
          a("Wikipedia", 
            href = "http://www.wikipedia.org")
        )
      )
      
    )
  )
))

