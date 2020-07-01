import flask
from flask import request

from sklearn.feature_extraction.text import CountVectorizer
from sklearn.externals import joblib
import numpy as np
import pandas as pd
import nltk
from nltk.corpus import stopwords
import string
from scipy.sparse import csr_matrix

app = flask.Flask(__name__)
app.config['SECRET_KEY'] = 'topnotch'
app.config["DEBUG"] = True

#logic starts

def process(text):
    nopunc = [char for char in text if char not in string.punctuation]
    nopunc = ''.join(nopunc)

    clean_words = [word for word in nopunc.split() if word.lower() not in stopwords.words('english')]
    
    return clean_words

def checker(passedVal):
	# nltk.download('stopwords')
	msg = passedVal
	messages = []
	messages.append(msg)
	msgs = pd.DataFrame(messages, columns=['sms'])
	retVal = "Ham"

	classifier = joblib.load("spamDetector.pkl")
	gVec = joblib.load("gVec.pkl")
	bowch = gVec.transform(msgs['sms'])

	if (classifier.predict(bowch)[0] == 0):
		retVal = "not spam"
	else:
		retVal = "spam"		
	return retVal

#logic ends


@app.route('/', methods=['GET'])
def home():
    return checker(request.args['msg'])

app.run()


