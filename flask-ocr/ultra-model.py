from ultralytics import YOLO
import cv2
from ultralytics.yolo.utils.plotting import Annotator
from PIL import Image
import numpy as np
import paddleocr

# Initialize model
model = YOLO('static/bests.pt')

# Load an image using PIL
im1 = Image.open("images/00000273-PHOTO-2020-11-24-20-10-20.jpg")

# Perform object detection on the image
results = model.predict(source=im1, conf=0.1, save=True)  # Save plotted images

# Convert the PIL image to a numpy array
img = np.array(im1)

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
ocr_result = ocr.ocr(crop_img)

print(ocr_result)

exit(0)
