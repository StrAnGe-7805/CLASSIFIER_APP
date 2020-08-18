from keras.models import load_model
import re
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from nltk.tokenize import TreebankWordTokenizer
import pickle

model = load_model('resources/model.h5')
lm = WordNetLemmatizer()
tk = TreebankWordTokenizer()
tfidf = pickle.load(open("resources/tfidf.pickel", "rb"))

def mainmodel(text):
    k = text
    k = re.sub('[^a-zA-Z]',' ',k)
    k = k.lower()
    k = tk.tokenize(k)
    k = [lm.lemmatize(word) for word in k if not word in stopwords.words('english')]
    k = ' '.join(k)
    k = tfidf.transform([k]).toarray()

    pred = model.predict(k)

    index = 0
    max = pred[0][0]

    for i in range(5):
        if pred[0][i] > max:
            max = pred[0][i]
            index = i
    if index == 0:
        return 'business'
    elif index == 1:
        return 'entertainment'
    elif index == 2:
        return 'politics'
    elif index == 3:
        return 'sport'
    elif index == 4:
        return 'tech'
