import cv2
import numpy as np
from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import io
import joblib

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load everything
model = joblib.load("models/best_model.pkl")
scaler = joblib.load("models/scaler.pkl")
label_encoder = joblib.load("models/label_encoder.pkl")
params = joblib.load("models/feature_params.pkl")

# Rebuild HOG
hog = cv2.HOGDescriptor(
    _winSize=tuple(params["win_size"]),
    _blockSize=tuple(params["block_size"]),
    _blockStride=tuple(params["block_stride"]),
    _cellSize=tuple(params["cell_size"]),
    _nbins=params["nbins"]
)

def extract_color_histogram(img):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

    h = cv2.calcHist([hsv], [0], None, [params["color_bins"]], [0,180])
    s = cv2.calcHist([hsv], [1], None, [params["color_bins"]], [0,256])
    v = cv2.calcHist([hsv], [2], None, [params["color_bins"]], [0,256])

    h = cv2.normalize(h, h).flatten()
    s = cv2.normalize(s, s).flatten()
    v = cv2.normalize(v, v).flatten()

    return np.concatenate([h, s, v])

def extract_features_api(pil_img):
    # PIL → OpenCV
    img = np.array(pil_img)
    img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)

    img = cv2.resize(img, tuple(params["img_size"]))

    # HOG
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    hog_feat = hog.compute(gray).flatten()

    # Color histogram
    hist_feat = extract_color_histogram(img)

    # Combine
    return np.concatenate([hog_feat, hist_feat]).reshape(1, -1)

# ADD THIS ROOT ENDPOINT
@app.get("/")
async def root():
    return {
        "status": "online",
        "service": "ReThread Classification API",
        "endpoints": {
            "/predict": "POST - Upload image for classification"
        }
    }

@app.post("/predict")
async def predict(image: UploadFile = File(...)):
    try:
        raw = await image.read()
        pil_img = Image.open(io.BytesIO(raw)).convert("RGB")

        feats = extract_features_api(pil_img)
        feats_scaled = scaler.transform(feats)

        pred = model.predict(feats_scaled)[0]
        label = label_encoder.inverse_transform([pred])[0]

        return {"success": True, "prediction": label}

    except Exception as e:
        return {"success": False, "error": str(e)}