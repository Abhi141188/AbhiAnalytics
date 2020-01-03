#Text Mining
#Loading required package: NLP
library(tm)

#Create Corpus (collection of documents)
docs <- Corpus(DirSource("F:/rWork/rProjects/AbhiAnalytics/PresidentSpeechs"))
inspect(docs)

#inspect a particular document
writeLines(as.character(docs[[1]]))

#Preprocessing
toSpace <- content_transformer(function(x,pattern){return(gsub(pattern, "",x))})

docs <- tm_map(docs, toSpace,"-")
docs <- tm_map(docs, toSpace,":")
docs <- tm_map(docs, toSpace,"'")
docs <- tm_map(docs, toSpace," -")

#Remove Punctuation 
docs <- tm_map(docs,removePunctuation)

#Transform to lower case (bcz r is case sensitive)
docs <- tm_map(docs,content_transformer(tolower))

#Remove digits
docs <- tm_map(docs,removeNumbers)

#Remove Stopwords/common words of english, from the text
docs <- tm_map(docs,removeWords, stopwords("english"))

# Remove the word of ur choice
# pecify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("blabla1", "blabla2")) 

#Remove Whitespaces
docs <- tm_map(docs,stripWhitespace)

#inspect output
writeLines(as.character(docs[[1]]))

#Stemming
#We will need SnowballC library for stemming
library(SnowballC)

#Stem document
docs <- tm_map(docs, stemDocument)
#limitation of stemming: 
#it sometimes removes prefixes & suffixes when it is not even required.
writeLines(as.character(docs[[1]]))

#Clean up to fix the nuances of stemming
docs <- tm_map(docs,content_transformer(gsub), pattern = "presid", replacement = "president")
docs <- tm_map(docs,content_transformer(gsub), pattern = "determin", replacement = "determine")
docs <- tm_map(docs,content_transformer(gsub), pattern = "destini", replacement = "destiny")

#Inspecting after the fix above:
writeLines(as.character(docs[[1]]))

#Create Document-Term Matrix
dtm <- DocumentTermMatrix(docs)

#Inspect a segment of document term matrix:
inspect(dtm[1:2,100:110])

#Text Mining
#Converting the dtm into matrix to get the frequencies of each column/term/word
freq <- colSums(as.matrix(dtm))

length(freq)
#length is the total no. of terms we have

#Sort Order (asc)
ord <- order(freq,decreasing = TRUE)

#Most frequently occurring words
freq[head(ord)]

#Least frequently occurring words
freq[tail(ord)]

#List most frequent words with lower bounds specified as second argument.
findFreqTerms(dtm,lowfreq=50)

#WordCloud
library(wordcloud)
set.seed(42)
#setting the same seed each time ensures consistent look across clouds
#limit words by specifying min freq
wordcloud(names(freq),freq,min.freq = 10)
#Add color
wordcloud(names(freq),freq,min.freq = 5,colors = brewer.pal(6,"Dark2"))
#Organize words
wordcloud(names(freq),freq,min.freq = 5,
          max.words = 100,
          random.order=FALSE, 
          colors=brewer.pal(8, "Dark2"),
          scale = c(2,0.5),
          rot.per = 0.3)
