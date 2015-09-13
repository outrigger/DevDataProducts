library(shiny)
library(rpart)
library(rpart.plot)
# library(rattle)
library(ggplot2)
library(RColorBrewer)

source("parseData.R")

shinyServer(function(input, output) {
 output$dataPlot1 <- renderPlot({
    g <- ggplot(trainingDataset, aes_string(x = input$x, y = input$y, shape = input$distinguishingVariable, color = input$distinguishingVariable),
                                           facets = paste(input$facets, collapse = "~"))
    
    g <- g + geom_point(size = I(3), xlab = "X", ylab = "Y") +
     facet_grid(paste(input$facets, collapse = "~"), scales = "free", space = "free")
    
    print(g)
 })
 
 fitModel <- reactive({
    variables <- paste(input$decisionTreeVariables, collapse = "+")
    
    # Prevents error caused when no decision tree variable options are checked
    if(nchar(variables) < 2) {
      variables <- "Sex"
    }
    args <- list(paste("as.factor(Survived) ~ ", variables))
    
    args$data <- trainingDataset
    args$method <- "class"
    
    do.call(rpart, args)
 })
 
 output$decisionTree <- renderPlot({
   plot(fitModel(), uniform = TRUE)
   text(fitModel(), use.n = TRUE, all = TRUE, cex = .9)
#   fancyRpartPlot(fitModel())
 })

 output$survivalStatus <- renderText({
    FamilyNameProcessed2 <- paste(input$FamilyName, input$FamilySize)
    
    predictSurvival <- data.frame(Sex = input$Sex, Age = input$Age, Pclass = input$Pclass, Fare = input$Fare, Embarked = input$Embarked, FamilySize = input$FamilySize, Title = input$Title, FamilyNameProcessed2 = FamilyNameProcessed2, SibSp = input$Siblings)
    predictSurvival$Pclass <- factor(predictSurvival$Pclass, levels = c(1, 2, 3), labels = c("First Class", "Second Class", "Third Class"))
    
    Prediction <- predict(fitModel(), predictSurvival, type = "class")
    write.csv(Prediction, "prediction.csv")
    return(as.character(Prediction))
 })
  
})