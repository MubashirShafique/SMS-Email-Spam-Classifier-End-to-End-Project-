# SMS/Email Spam Classifier (End-to-End Project) 

This is a complete AI system that classifies SMS and Emails as **Spam** or **Ham (Safe)**. The Machine Learning model is connected to both **Web** and **Mobile apps** using a **FastAPI backend**.

---

## Project Features
- **AI-Powered:** NLP-based classification model that gives accurate results.  
- **FastAPI Backend:** Fast and reliable prediction service for the model.  
- **Web Dashboard:** Streamlit web app for instant testing.  
- **Mobile App:** Flutter-based Android app to test on mobile.  

---

## Repository Structure
- **01_Data:** Dataset used for training.  
- **02_Notebook:** Notebook with model training and evaluation steps.  
- **03_Saved_Model:** Trained `.pkl` files (Model and Vectorizer).  
- **04_API_Backend:** FastAPI scripts for serving the model.  
- **05_Streamlit_App:** Python web UI code using Streamlit.  
- **06_Android_App:** Flutter mobile app source code.  

---

## Installation & Setup Guide

### 1. Backend Setup (FastAPI)
First, run the API:

```bash
# Go to API folder
cd 04_API_Backend

# Install dependencies
pip install -r requirements.txt

# Run FastAPI server
uvicorn API:app --reload  ```

gdd


