import streamlit as st
import requests


st.set_page_config(page_title="sms_spam_classifier", layout="centered")
st.title("Email/SMS Spam Classifier")


input_sms=st.text_area(
    "Enter Your Email/Message:", 
    placeholder="Type...",
    height=200  
)

if st.button("Predict"):
    input_payload={"text":input_sms}


    API_URL = "http://localhost:8000/classifier"


    try:
        response=requests.post(API_URL,json=input_payload)

        if response.status_code==200:
            result = response.json()
            if result['label'] == "Spam":
                st.header(f"There is {int(result['probability']*100)}% chances that the Given Message is Spam")
            else:
                st.header(f"There is {int(result['probability']*100)}% chances that the Given Message is Not Spam")
        else:
            st.error(f"API Error {response.status_code} - {response.text}")
    except requests.exceptions.ConnectionError:
        st.error("onnection Failed! Make sure API is running on port 8000.")