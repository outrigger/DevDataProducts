trainingDataset <- read.csv("data/train.csv")
testingDataset <- read.csv("data/test.csv")

testingDataset$Survived <- NA
combinedDataset <- rbind(trainingDataset, testingDataset)

# Process Title
combinedDataset$Name = as.character(combinedDataset$Name)
combinedDataset$Title <- sapply(combinedDataset$Name, FUN = function(x) {strsplit(x, split = '[,.]')[[1]][2]})
combinedDataset$Title <- sub(' ', '', combinedDataset$Title)
combinedDataset$Title[combinedDataset$Title %in% c('Mlle', 'Ms')] <- 'Miss'
combinedDataset$Title[combinedDataset$Title == 'Mme'] <- 'Mrs'
combinedDataset$Title[combinedDataset$Title %in% c('Capt', 'Don', 'Major', 'Col', 'Sir', 'Jonkheer')] <- 'Sir'
combinedDataset$Title[combinedDataset$Title %in% c('Dona', 'Lady', 'the Countess')] <- 'Lady'
combinedDataset$Title <- factor(combinedDataset$Title)

# Process Family Size
combinedDataset$FamilySize <- combinedDataset$SibSp + combinedDataset$Parch

# Process Family Name
combinedDataset$Surname <- sapply(combinedDataset$Name, FUN = function(x) {strsplit(x, split = '[,.]')[[1]][1]})
combinedDataset$FamilyNameProcessed1 <- paste(combinedDataset$Surname, as.character(combinedDataset$FamilySize), sep = "_")

# Aggregate Lone Passengers & Tag as Alone
passengerFamilies <- data.frame(table(combinedDataset$FamilyNameProcessed1))
lonePassengers <- passengerFamilies[passengerFamilies$Freq == 1,]
combinedDataset$FamilyNameProcessed1[combinedDataset$FamilyNameProcessed1 %in% lonePassengers$Var1] <- 'Alone'

# Aggregate Families of 2 & Tag as Small
familiesOfTwo <- passengerFamilies[passengerFamilies$Freq == 2,]
combinedDataset$FamilyNameProcessed1[combinedDataset$FamilyNameProcessed1 %in% familiesOfTwo$Var1] <- 'Small'

combinedDataset$FamilyNameProcessed1 <- factor(combinedDataset$FamilyNameProcessed1)

# Impute missing Age values
ageFit <- rpart(Age ~ Pclass + Sex + SibSp + Parch + Fare + Title + FamilySize,
                data = combinedDataset[!is.na(combinedDataset$Age),],
                method = "anova"
                )

combinedDataset$Age[is.na(combinedDataset$Age)] <- predict(ageFit, combinedDataset[is.na(combinedDataset$Age),])

# Process Port of Embarkation
combinedDataset$Embarked[which(combinedDataset$Embarked == '')] <- "S"
combinedDataset$Embarked <- factor(combinedDataset$Embarked)

# Impute missing Fare values
combinedDataset$Fare[which(is.na(combinedDataset$Fare))] <- median(combinedDataset$Fare, na.rm = TRUE)

# Further Process Family Name
combinedDataset$FamilyNameProcessed2 <- combinedDataset$FamilyNameProcessed1
combinedDataset$FamilyNameProcessed2 <- as.character(combinedDataset$FamilyNameProcessed2)
combinedDataset$FamilyNameProcessed2[combinedDataset$FamilySize <= 1] <- 'Alone'
combinedDataset$FamilyNameProcessed2[combinedDataset$FamilySize > 1 & combinedDataset$FamilySize <= 2] <- 'Small'
combinedDataset$FamilyNameProcessed2 <- factor(combinedDataset$FamilyNameProcessed2)


# Re-create Training & Testing Datasets
trainingDataset <- combinedDataset[1:891,]
testingDataset <- combinedDataset[892:1309,]

trainingDataset$Survived <- factor(trainingDataset$Survived, levels = c(0, 1), labels = c('Died', 'Survived'))
trainingDataset$Pclass <- factor(trainingDataset$Pclass, levels = c(1, 2, 3), labels = c('First Class', 'Second Class', 'Third Class'))


fitModel <- rpart(Survived ~ as.factor(Pclass) + Sex + Age,
                  data = trainingDataset,
                  method = "class")