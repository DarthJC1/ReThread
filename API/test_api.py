#!/usr/bin/env python3
"""
Test your API quickly
Usage: python test_api.py [URL]
"""

import requests
import sys
import os

def test_api(base_url):
    print(f"\nTesting API at: {base_url}")
    print("-" * 50)
    
    # Test 1: Health check
    print("\n1. Testing health endpoint...")
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
        print("\nTroubleshooting:")
        print("  - Is the API running?")
        print("  - Is the URL correct?")
        print("  - Are you on the same network (for local)?")
        return False
    
    # Test 2: Classification (if image provided)
    if len(sys.argv) > 2:
        image_path = sys.argv[2]
        if os.path.exists(image_path):
            print(f"\n2. Testing classification with {image_path}...")
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
        print("\n2. Skipping image test (no image provided)")
        print("   Usage: python test_api.py URL image.jpg")
    
    print("\n" + "="*50)
    print("[OK] Basic tests passed!")
    print("="*50)
    return True

if __name__ == "__main__":
    url = sys.argv[1] if len(sys.argv) > 1 else "http://localhost:8000"
    test_api(url)
