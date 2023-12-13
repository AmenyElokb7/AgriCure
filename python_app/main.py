from fastapi import FastAPI , File, UploadFile, Depends
import uvicorn 
import numpy as np
from io import BytesIO
from PIL import Image
import cv2
import tensorflow as tf
from fastapi.middleware.cors import CORSMiddleware
import openai

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
MODEL= tf.keras.models.load_model("../saved_models/saved_models/1")
openai.api_key = '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'

CLASS_NAMES=['Pepper__bell___Bacterial_spot', 'Pepper__bell___healthy', 'Potato___Early_blight', 'Potato___Late_blight', 'Potato___healthy', 'Tomato_Bacterial_spot', 'Tomato_Early_blight', 'Tomato_Late_blight', 'Tomato_Leaf_Mold', 'Tomato_Septoria_leaf_spot', 'Tomato_Spider_mites_Two_spotted_spider_mite', 'Tomato__Target_Spot', 'Tomato__Tomato_YellowLeaf__Curl_Virus', 'Tomato__Tomato_mosaic_virus', 'Tomato_healthy']

@app.get("/ping")
async def ping():
    return "hello i am alive"
    
def read_file_as_image(data)->np.ndarray:
    image = np.array(Image.open(BytesIO(data)))
    return image
    
@app.post("/predict")
async def predict(
    file:UploadFile=File(...),
):
    image = read_file_as_image(await file.read())
    resized_image = cv2.resize(image, (256, 256))
    img_batch=np.expand_dims(resized_image, 0)
    
    predictions = MODEL.predict(img_batch)
    
    predicted_class = CLASS_NAMES[np.argmax(predictions[0])]
    confidence= np.max(predictions[0])

    if predicted_class=="Pepper__bell___healthy" or predicted_class=="Potato___healthy" or predicted_class=="Tomato_healthy":
        question = f"type your plant is healthy. and give 3 advice on how to take care of your plant "
    else:
        question = f"What is the solution for {predicted_class}?"
    
    solution=""
    
    gpt_response = openai.Completion.create(
        engine="text-davinci-003",  
        prompt=question,
        temperature=0.7,
        max_tokens=150,
        n=1,
    )

    
    solution = gpt_response['choices'][0]['text'].strip()


    return {
        'class':predicted_class,
        'confidence': float(confidence),
        'solution':solution
    }

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
