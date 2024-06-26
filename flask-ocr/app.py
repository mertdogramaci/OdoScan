from flask import Flask, request, jsonify
from ultralytics import YOLO
import cv2
from ultralytics.yolo.utils.plotting import Annotator
from PIL import Image
import numpy as np
import paddleocr
import re

model = YOLO('static/bests.pt')

app = Flask(__name__)


@app.route('/detect', methods=['POST'])
def detect():
    file = request.files['image']
    device_id = request.form['device_id']

    print(device_id)

    # Load an image using PIL
    im1 = Image.open(file)

    # Perform object detection on the image
    results = model.predict(source=im1, conf=0.1)  # Save plotted images

    # Convert the PIL image to a numpy array
    img = np.array(im1)

    """
    # Initialize the annotator
    annotator = Annotator(img)

    # Draw the bounding boxes on the image
    for r in results:
        boxes = r.boxes
        for box in boxes:
            b = box.xyxy[0]  # get box coordinates in (top, left, bottom, right) format
            c = box.cls
            print(c)
            annotator.box_label(b, model.names[int(c)])

    # Display the image with bounding boxes
    cv2.imshow('YOLO Detection', cv2.cvtColor(img, cv2.COLOR_RGB2BGR))
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    """

    # Crop the box.cls with label including "panel"
    # Save the cropped image to a file

    crop_img = None

    for r in results:
        boxes = r.boxes
        for box in boxes:
            b = box.xyxy[0]  # get box coordinates in (top, left, bottom, right) format
            c = box.cls
            if model.names[int(c)].find("panel") != -1:
                print(c)
                print(model.names[int(c)])
                print(b)
                crop_img = img[int(b[1]):int(b[3]), int(b[0]):int(b[2])]
                Image.fromarray(crop_img).save("static/cropped.jpg")
                break
    
    # Load the PaddleOCR model
    ocr = paddleocr.PaddleOCR(lang="en")

    # Perform OCR on the cropped image
    ocr_results = ocr.ocr(crop_img)

    str_result = "".join(result[1][0] for result in ocr_results[0])

    # Get only the numbers from the OCR result using regex
    milage = re.findall(r'\d+', str_result)[0]
    print("milage: " + milage)
    print("device_id: " + device_id)
    return jsonify(milage=milage, device_id=device_id)

# def detect():
#     device_id = request.form['device_id']
#     print(device_id)
#     return jsonify(device_id=device_id)

if __name__ == '__main__':
    app.run(host="192.168.1.108",port=5000,debug=True)
