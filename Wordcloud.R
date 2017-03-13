library("tm")
library("wordcloud")
library("twitteR")
library("ROAuth")

load('AcnTwttrSA.RData')

setup_twitter_oauth(consumer_key = cKey, 
                    consumer_secret = cSecret, 
                    access_token = aToken, 
                    access_secret = aSecret)

sLang <- "en"
search.string <- "trump"
no.of.tweets <- 5000


tweets <- searchTwitter(search.string, n=no.of.tweets, lang= sLang)

tweets.text <- sapply(tweets, function(x) x$getText())

#Remode emoticons
# tweets.text <- sapply(tweets.text,function(row) iconv(row, to="UTF-8", from="ASCII", sub=""))
# tweets.text <- sapply(tweets.text,function(row) iconv(row, to="UTF-8", from="latin1", sub=""))
 tweets.text <- sapply(tweets.text,function(row) iconv(row, to="ASCII", from="UTF-8", sub=""))


#tweets.text <- chartr('αινσϊρ','aeioun',tweets.text)

#convert all text to lower case
tweets.text <- tolower(tweets.text)

# Replace blank space ("rt ")
tweets.text <- gsub("rt ", "", tweets.text)

# Replace @UserName
tweets.text <- gsub("@\\w+", "", tweets.text)

# Remove punctuation
tweets.text <- gsub("[[:punct:]]", "", tweets.text)

# Remove links
tweets.text <- gsub("http\\w+", "", tweets.text)

# Remove tabs
tweets.text <- gsub("[ |\t]{2,}", "", tweets.text)

# Remove intro
tweets.text <- gsub("\n", " ", tweets.text)

# Remove blank spaces at the beginning
tweets.text <- gsub("^ ", "", tweets.text)

# Remove blank spaces at the end
tweets.text <- gsub(" $", "", tweets.text)



#create corpus
tweets.text.corpus <- Corpus(VectorSource(tweets.text))

#clean up by removing stop words
tweets.text.corpus <- tm_map(tweets.text.corpus, function(x)removeWords(x,stopwords(kind=sLang)))

#generate wordcloud
wordcloud(tweets.text.corpus,min.freq = 10, scale=c(7,0.5),colors=brewer.pal(8, "Dark2"),  random.color= TRUE, random.order = FALSE, max.words = 150)

write.csv(tweets.text, file = "foo.csv")

#tweets.text <- sapply(tweets, function(x) x$toDataFrame())

