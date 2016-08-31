setwd("C:/Users/Philipp/Dropbox/tobelabeled/Text Analysis")

##
### Load packages
library(dplyr)
library(ggplot2)
library(stringr)
library(stats)
library(pscl)

#################
### Load data ###
cl = c('factor', 'numeric', 'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric', 'numeric', 'numeric', 'character', 'character')
#daten <- read.csv2("end_results.csv", sep = ",", dec = '.', colClasses = cl)
daten <- read.csv2("end_results.csv", sep = ",", dec = '.', colClasses = cl)
row_sub = rowSums(as.matrix(is.na(daten))) == 0
#row_sub <- apply(daten, 1, function(row) all(row !="#NV"))
daten2 <- daten[row_sub,]

#daten2[,'text.diff'] = daten2[,'text_confidence_positive']-daten2[,'text_confidence_negative']
#daten2[,'bild.diff'] = daten2[,'bild_confidence_positive']-daten2[,'bild_confidence_negative']


daten2[,'text.ana'] = as.numeric(as.character(daten2[,'text_sentiment']))*as.numeric(as.character(daten2[,'text_highest_score']))
daten2[,'bild.ana'] = as.numeric(as.character(daten2[,'bild_sentiment']))*as.numeric(as.character(daten2[,'bild_highest_score']))

#################
#################
# 2n try
# gewichtete Analysen auf Achsen

#diff oder ana wählen
#columns <- c("id", "hand_labels_tog", "text.diff", "bild.diff")
columns <- c("id", "hand_labels_tog", "text.ana", "bild.ana")

daten3 <- daten2[,columns]
#daten3 <- select(obj = daten2, id, true_sentiment, text.ana, bild.ana)

#m1 <- select(.data = daten2, id, true_sentiment)
#m1$text.ana <- daten3$text.sentiment*daten3$highest.text.score
#typeof(daten3$text.sentiment)
typeof(daten3)

##############################
#getting steigung via wolfram alpha!!
#
#

steigung = -2.06024 
inter = 0.237455

#text.ana oder text.diff
ggplot(data = daten3, aes(x = text.ana, y= bild.ana))+
  labs(color = "Hand labeled combined sentiment")+
  geom_point(aes(col = as.factor(daten3$hand_labels_tog)), size = 2)+
  scale_x_continuous(limits = c(-1, 1))+
  scale_y_continuous(limits = c(-1, 1))+
  labs(x = 'Confidence Scores * Sentiment (Text)', y= 'Confidence Scores * Sentiment (Picture)')+
  geom_abline(intercept = inter, slope = steigung)
  

