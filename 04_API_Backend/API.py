from fastapi import FastAPI
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import nltk
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
import string
import pickle
import os

# Download resources once (if not already present)
def download_nltk_resources():
    resources = {
        'punkt': 'tokenizers/punkt',
        'stopwords': 'corpora/stopwords',
        'punkt_tab': 'tokenizers/punkt_tab'  
    }
    
    for resource, path in resources.items():
        try:
            nltk.data.find(path)
        except LookupError:
            nltk.download(resource)

download_nltk_resources()

# Global initializations for speed
ps = PorterStemmer()
STOP_WORDS = set(stopwords.words('english'))

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(BASE_DIR)
model_Path = os.path.join(PROJECT_ROOT, "03_Saved_Model", "model.pkl")
vectorizer_path = os.path.join(PROJECT_ROOT, "03_Saved_Model", "vectorizer.pkl")

# Loading Models
with open(vectorizer_path, 'rb') as f:
    tfidf = pickle.load(f)
with open(model_Path, 'rb') as f:
    model = pickle.load(f)

app = FastAPI()

class InputData(BaseModel):
    text: str

def transform_text(text):
    text = text.lower()
    text = nltk.word_tokenize(text)

   
    y = [ps.stem(i) for i in text if i.isalnum() and i not in STOP_WORDS]
    
    return " ".join(y)

@app.post('/classifier')
def email_sms_spam_classifier(data: InputData): 
    try:
        if data.text == '':
         return JSONResponse(status_code=400, content={"error": "Text is empty"})
        # 1. Preprocess
        transformed_sms = transform_text(data.text)

        # 2. Vectorize 
        vector_input = tfidf.transform([transformed_sms])

        # 3. Predict
        probabilities = model.predict_proba(vector_input)[0]
        prediction = model.predict(vector_input)[0]
         
         # 4. Confedence Score 
        confidence = probabilities[1] if prediction == 1 else probabilities[0]
        return {
            "status": "success",
            "result": int(prediction), 
            "label": "Spam" if prediction == 1 else "Ham",
            "probability": round(float(confidence), 2)
        }
    except Exception as e:
        return JSONResponse(status_code=500, content={"error": str(e)})