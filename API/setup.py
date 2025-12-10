"""
Quick Setup Script - API-Only Deployment
Run this to prepare everything for deployment in minutes!

Usage: python quick_setup.py
"""

import os
import shutil
import sys

def print_step(step_num, text):
    print(f"\n{'='*60}")
    print(f"Step {step_num}: {text}")
    print('='*60)

def print_success(text):
    print(f"[OK] {text}")

def print_error(text):
    print(f"[ERROR] {text}")

def create_directories():
    """Create project structure"""
    print_step(1, "Creating Project Structure")
    
    dirs = [
        "api_deployment",
        "api_deployment/models",
        "flutter_app"
    ]
    
    for d in dirs:
        os.makedirs(d, exist_ok=True)
        print_success(f"Created {d}/")

def copy_model_files():
    """Copy trained model files"""
    print_step(2, "Copying Model Files")
    
    model_files = [
        'best_model.pkl',
        'scaler.pkl',
        'label_encoder.pkl',
        'feature_params.pkl'
    ]
    
    if not os.path.exists('models'):
        print_error("'models' directory not found!")
        print("  Please run this script from your project root directory")
        print("  where you trained your model.")
        sys.exit(1)
    
    all_present = True
    for file in model_files:
        src = os.path.join('models', file)
        dst = os.path.join('api_deployment/models', file)
        
        if os.path.exists(src):
            shutil.copy2(src, dst)
            print_success(f"Copied {file}")
        else:
            print_error(f"Missing {file}")
            all_present = False
    
    if not all_present:
        print("\n✗ Some model files are missing!")
        sys.exit(1)
    
    return True

def create_requirements():
    """Create requirements.txt"""
    print_step(3, "Creating requirements.txt")
    
    requirements = """fastapi==0.104.1
uvicorn[standard]==0.24.0
python-multipart==0.0.6
opencv-python-headless==4.8.1.78
numpy==1.24.3
pillow==10.1.0
scikit-learn==1.3.2
joblib==1.3.2
"""
    
    with open('api_deployment/requirements.txt', 'w') as f:
        f.write(requirements)
    
    print_success("requirements.txt created")

def create_api_server():
    """Create api_server.py placeholder"""
    print_step(4, "Creating API Server File")
    
    api_code = """# Copy the complete API code from the 'Backend API' artifact
# and paste it here, or create this file manually.
#
# For now, this is just a placeholder.
# 
# Quick instructions:
# 1. Open the 'Backend API for Complete Clothing Classification' artifact
# 2. Copy all the code
# 3. Paste it into this file
# 4. Save and you're ready to run!

print("Please replace this file with the actual API code from the artifact")
"""
    
    with open('api_deployment/api_server.py', 'w') as f:
        f.write(api_code)
    
    print_success("api_server.py template created")
    print("  [WARNING] You need to copy the actual API code from the artifact!")

def create_dockerfile():
    """Create Dockerfile"""
    print_step(5, "Creating Dockerfile")
    
    dockerfile = """FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \\
    libgl1-mesa-glx \\
    libglib2.0-0 \\
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY api_server.py .
COPY models/ models/

EXPOSE 8000

CMD ["uvicorn", "api_server:app", "--host", "0.0.0.0", "--port", "8000"]
"""
    
    with open('api_deployment/Dockerfile', 'w') as f:
        f.write(dockerfile)
    
    print_success("Dockerfile created")

def create_flutter_pubspec():
    """Create Flutter pubspec.yaml"""
    print_step(6, "Creating Flutter Configuration")
    
    pubspec = """name: clothing_classifier
description: Clothing classification mobile app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  image_picker: ^1.0.4
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
"""
    
    os.makedirs('flutter_app', exist_ok=True)
    with open('flutter_app/pubspec.yaml', 'w') as f:
        f.write(pubspec)
    
    print_success("pubspec.yaml created")
    print("  [WARNING] Create Flutter project and copy main.dart from artifact")

def create_test_script():
    """Create API test script"""
    print_step(7, "Creating Test Script")
    
    test_code = """#!/usr/bin/env python3
\"\"\"
Test your API quickly
Usage: python test_api.py [URL]
\"\"\"

import requests
import sys
import os

def test_api(base_url):
    print(f"\\nTesting API at: {base_url}")
    print("-" * 50)
    
    # Test 1: Health check
    print("\\n1. Testing health endpoint...")
    try:
        response = requests.get(f"{base_url}/", timeout=5)
        if response.status_code == 200:
            data = response.json()
            print("[OK] API is online")
            print(f"  Classes: {data.get('classes', [])}")
        else:
            print(f"[ERROR] Status code: {response.status_code}")
            return False
    except Exception as e:
        print(f"[ERROR] Cannot connect: {e}")
        print("\\nTroubleshooting:")
        print("  - Is the API running?")
        print("  - Is the URL correct?")
        print("  - Are you on the same network (for local)?")
        return False
    
    # Test 2: Classification (if image provided)
    if len(sys.argv) > 2:
        image_path = sys.argv[2]
        if os.path.exists(image_path):
            print(f"\\n2. Testing classification with {image_path}...")
            try:
                with open(image_path, 'rb') as f:
                    files = {'file': f}
                    response = requests.post(
                        f"{base_url}/classify",
                        files=files,
                        timeout=30
                    )
                
                if response.status_code == 200:
                    data = response.json()
                    print("[OK] Classification successful")
                    print(f"  Prediction: {data['prediction']}")
                    print(f"  Confidence: {data['confidence']*100:.1f}%")
                    print(f"  All scores: {data['all_scores']}")
                else:
                    print(f"[ERROR] {response.json()}")
            except Exception as e:
                print(f"[ERROR] Classification failed: {e}")
    else:
        print("\\n2. Skipping image test (no image provided)")
        print("   Usage: python test_api.py URL image.jpg")
    
    print("\\n" + "="*50)
    print("[OK] Basic tests passed!")
    print("="*50)
    return True

if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8000"
    test_api(url)
"""
    
    with open('test_api.py', 'w') as f:
        f.write(test_code)
    
    try:
        os.chmod('test_api.py', 0o755)
    except:
        pass  # Windows doesn't need chmod
    
    print_success("test_api.py created")

def create_readme():
    """Create README with instructions"""
    print_step(8, "Creating README")
    
    readme = """# Clothing Classifier - Ready to Deploy!

## What You Have Now

```
api_deployment/          <- Your Backend API
  ├── api_server.py        (NEEDS: Copy code from artifact)
  ├── requirements.txt     [OK] Ready
  ├── Dockerfile          [OK] Ready
  └── models/             [OK] All model files copied
      ├── best_model.pkl
      ├── scaler.pkl
      ├── label_encoder.pkl
      └── feature_params.pkl

flutter_app/            <- Your Mobile App
  └── pubspec.yaml         [OK] Ready
  
test_api.py             [OK] Ready to test
```

## Quick Start (3 Steps!)

### Step 1: Complete API Setup

1. **Copy API code:**
   - Open the "Backend API" artifact I provided
   - Copy ALL the code
   - Paste into `api_deployment/api_server.py`

### Step 2: Start API

Choose one method:

**Option A: Local Testing**
```bash
cd api_deployment
pip install -r requirements.txt
uvicorn api_server:app --host 0.0.0.0 --port 8000
```

**Option B: Docker**
```bash
cd api_deployment
docker build -t clothing-api .
docker run -p 8000:8000 clothing-api
```

**Option C: Deploy to Railway (Free)**
1. Create account at railway.app
2. Upload `api_deployment/` folder
3. Railway auto-deploys!
4. Get your URL

### Step 3: Setup Flutter App

1. **Create Flutter project:**
```bash
flutter create clothing_classifier
cd clothing_classifier
```

2. **Copy files:**
   - Copy `flutter_app/pubspec.yaml` -> replace yours
   - Copy Flutter code from artifact -> `lib/main.dart`

3. **Update API URL** in `main.dart` line 34:
```dart
static const String API_BASE_URL = "http://YOUR_URL:8000";
```

4. **Run:**
```bash
flutter pub get
flutter run
```

## Testing

Test your API:
```bash
# Health check
python test_api.py http://localhost:8000

# With image
python test_api.py http://localhost:8000 test_image.jpg
```

Or in browser:
- Open: http://localhost:8000/docs
- Try the interactive API!

## Deployment Options

### Free Hosting (Perfect for starting)

**Railway.app** [RECOMMENDED]
- Go to railway.app
- New Project -> Upload folder
- Get URL instantly
- 500 hours/month free

**Render.com**
- Go to render.com  
- New Web Service
- Connect GitHub
- Auto-deploy

### Paid (If you scale up)
- AWS Lambda
- Google Cloud Run
- Heroku
- DigitalOcean

## Troubleshooting

**"Cannot connect to API"**
```bash
# Check if API is running
curl http://localhost:8000/

# Check your IP (if using local)
ipconfig  # Windows
ifconfig  # Mac/Linux
```

**"Model not found"**
- Make sure all 4 .pkl files are in models/ folder

**"Slow predictions"**
- Normal on free hosting (1-3 seconds)
- Consider paid hosting for faster response

## What's Next?

- [ ] Complete Step 1-3 above
- [ ] Test with sample images
- [ ] Deploy to cloud
- [ ] Add authentication (see deployment guide)
- [ ] Improve Flutter UI
- [ ] Add analytics

## Support

- Full deployment guide: See "Simple Deployment Guide" artifact
- API docs (when running): http://localhost:8000/docs

Good luck!
"""
    
    with open('README.md', 'w', encoding='utf-8') as f:
        f.write(readme)
    
    print_success("README.md created")

def main():
    """Main setup function"""
    print("\n" + "="*60)
    print("  CLOTHING CLASSIFIER - QUICK SETUP")
    print("  API-Only Approach (Simple & Fast!)")
    print("="*60)
    
    try:
        create_directories()
        copy_model_files()
        create_requirements()
        create_api_server()
        create_dockerfile()
        create_flutter_pubspec()
        create_test_script()
        create_readme()
        
        print("\n" + "="*60)
        print("  [OK] SETUP COMPLETE!")
        print("="*60)
        
        print("\n[NEXT STEPS]")
        print("\n1. Copy API code:")
        print("   - Open 'Backend API' artifact")
        print("   - Copy code to api_deployment/api_server.py")
        
        print("\n2. Start API:")
        print("   cd api_deployment")
        print("   pip install -r requirements.txt")
        print("   uvicorn api_server:app --reload")
        
        print("\n3. Test it:")
        print("   python test_api.py http://localhost:8000")
        
        print("\n4. Setup Flutter:")
        print("   - Create Flutter project")
        print("   - Copy Flutter code from artifact to lib/main.dart")
        print("   - Update API_BASE_URL with your API address")
        print("   - Run: flutter run")
        
        print("\n[INFO] See README.md for complete instructions")
        print("\n[OK] You're ready to deploy!\n")
        
    except Exception as e:
        print(f"\n[ERROR] Setup failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()