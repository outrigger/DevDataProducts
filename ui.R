library(shiny)

shinyUI(fluidPage(
  
  tabsetPanel("Developing Data Products",
              
    tabPanel("Introduction",
      h2("Titanic Survival Prediction", align = "center"),
      img(src="titanic_sinking.png", style="display: block; margin-left: auto; margin-right: auto;"),
      h5("The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships.", align = "justify"),
      h5("One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class.", align = "justify"),
      h5("This Shiny application analyses the types of people who are likely to survive through the use of machine learning techniques that predict which passengers survived the tragedy.", align = "justify"),
      br(),
      h5(strong("Click on the tabs above to find out more!"), align = "center"),
      br(),
      h6(strong(em("Note: ")), em("You may find the server.R and ui.R codes on my "), em(a("GitHub.", href = "https://github.com/outrigger/DevDataProducts", target="_blank")), align = "center")
    ),
              
    "Descriptive Analytics",
    tabPanel("Exploratory Data Analysis",
      sidebarLayout(
        sidebarPanel(
          selectInput("x",
                      label = "x-axis",
                      choices = list("Age" = "Age", "Fare" = "Fare", "Family Size" = "FamilySize", "Number of Siblings/Spouses Aboard" = "SibSp"),
                      selected = list("Age")
                      ),
          selectInput("y",
                      label = "y-axis",
                      choices = list("Age" = "Age", "Fare" = "Fare", "Family Size" = "FamilySize", "Number of Siblings/Spouses Aboard" = "SibSp"),
                      selected = list("Fare")
                      ),
          selectInput("distinguishingVariable",
                      label = "Distinguishing Variable",
                      choices = list("Class" = "Pclass", "Sex" = "Sex", "Title" = "Title", "Embarkment Port" = "Embarked"),
                      selected = list("Pclass")
                      ),
          checkboxGroupInput("facets",
                             label = "Facets",
                             choices = list("Survived" = "Survived", "Sex" = "Sex", "Class" = "Pclass", "Title" = "Title", "Family Size" = "FamilySize", "Number of Siblings/Spouses Aboard" = "SibSp", "Embarkment Port" = "Embarked"),
                             selected = list("Survived", "Sex")
                             )
        ),
        
        mainPanel(
          h2("Plotted Chart"),
          br(),
          h4("Instructions"),
          h6("1. Analyse the correlation between two variables by choosing the desired parameters for the x-axis and y-axis."),
          h6("2. Choose the desired distinguishing variable to plot the data."),
          h6("3. Check the desired facets to split up the plotted data."),
          br(),
          h4("Results"),
          plotOutput("dataPlot1")
        )
      )
    ),
    
    "Predictive Analytics",
    tabPanel("Decision Tree",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput("decisionTreeVariables",
                             label = h4("Decision Tree Variables"),
                             choices = list("Sex" = "Sex", "Age" = "Age", "Class" = "Pclass", "Fare" = "Fare", "Embarkment Port" = "Embarked", "Title" = "Title", "Family Size" = "FamilySize", "Number of Siblings/Spouses Aboard" = "SibSp", "Family Name" = "FamilyNameProcessed2"),
                             selected = list("Sex", "Age", "Pclass")
          )
        ),
      
      mainPanel(
        h2("Decision Tree created with rpart"),
        br(),
        h4("Note"),
        h6(em("Due to shinyapps.io's incompatibility with RGTk2, the interactive decision tree which makes use of the rattle package cannot work. As such, the decision tree was rendered using the native plot() function from the rpart package."), align = "justify"),
        h6(em(a("Read more about the issue here", href = "https://groups.google.com/forum/#!topic/shinyapps-users/fkKoRBfEUJo", target="_blank"))),
        br(),
        h4("Instructions"),
        h6("1. Check the desired variables to plot the decision tree."),
        br(),
        h4("Results"),
        plotOutput("decisionTree")
      )
     )
    ),
    
    tabPanel("Will you survive?",
      sidebarLayout(
        sidebarPanel(radioButtons("Sex",
                                 "Sex",
                                 choices = list("Male" = "male", "Female" = "female"),
                                 selected = "female"
                                 ),
                    sliderInput("Age",
                                "Age",
                                min = 0, max = 100, value = 27),
                    radioButtons("Pclass",
                                 "Class",
                                 choices = list("First" = 1, "Second" = 2, "Third" = 3),
                                 selected = 2),
                    sliderInput("Fare",
                                "Fare",
                                min = 1, max = 100, value = 20),
                    selectInput("Embarked",
                                "Embarked at",
                                choices = list("Cherbourg" = "C", "Queenstown" = "Q", "Southampton" = "S"),
                                selected = "S"),
                    sliderInput("FamilySize",
                                "Family Size",
                                min = 1, max = 15, value = 2),
                    selectInput("Title",
                                "Title",
                                choices = list("Mr" = "Mr", "Mrs" = "Mrs", "Miss" = "Miss", "Master" = "Master", "Dr" = "Dr", "Rev" = "Rev", "Sir" = "Sir", "Lady" = "Lady"),
                                selected = "Miss"),
                    textInput("FamilyName",
                              "Family Name",
                              value = "Johnson"),
                    sliderInput("Siblings",
                                "Number of Siblings/Spouses Aboard",
                                min = 0, max = 10, val = 1)
      ),
      
      mainPanel(
        h2("Your Survival Prediction"),
        br(),
        h4("Instructions"),
        h6("1. Fill up your characteristics using the input controls on the sidebar to find out!", align = "justify"),
        img(src="survival_status.png", style="display: block; margin-left: auto; margin-right: auto;"),
        br(),
        h4("Results"),
        "Based on the results computed from the current decision tree created in the Decision Tree tab, you must have",
        textOutput("survivalStatus", container = strong), " !",
        br()
      )
    )
  ))
))