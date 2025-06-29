
import cv2
import numpy as np
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db

# Fetch the service account key JSON file from the Firebase project settings
cred = credentials.Certificate("kbtu-4554c-firebase-adminsdk-log99-e492917432.json")

# Initialize the Firebase app with the service account credentials
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://kbtu-4554c-default-rtdb.firebaseio.com/'
})


position = ""  

def scan_images():
    url = 'http://admin:Admin123@192.168.20.64:80/ISAPI/Streaming/channels/101/picture'
    num_frames = 11 
    for i in range(1, num_frames):
      cap = cv2.VideoCapture(url)
      ret, frame = cap.read()
      if not ret:
          print("Не удалось получить кадр")
          break   
      filename = f'image_{i}.jpg'  
      cv2.imwrite(filename, frame)
      print(f"Фотография {i} сохранена как {filename}")
    cap.release()    
    global position 
    
   
    net = cv2.dnn.readNet("yolov3.weights", "yolov3.cfg")

    
    conf_threshold = 0.5

    
    regions_of_interest = [
        [(1082, 182, 435, 120), (1082, 310, 730, 240)]  
    ]

    for i in range(1, 11):
        image_path = "image_{}.jpg".format(i)
        img = cv2.imread(image_path)

        car_found = False  
        car_zone = None 

        for zone_index, roi in enumerate(regions_of_interest[0]):
            x, y, w, h = roi
            roi_img = img[y:y+h, x:x+w]
            cv2.rectangle(img, (x, y), (x + w, y + h), (0, 0, 255), 2)

            
            blob_roi = cv2.dnn.blobFromImages([roi_img], 1/255, (416, 416), swapRB=True, crop=False)
            net.setInput(blob_roi)
            output_layers_names = net.getUnconnectedOutLayersNames()
            layerOutputs = net.forward(output_layers_names)

            
            class_ids = []
            boxes = []
            confidences = []
            for output in layerOutputs:
                for detection in output:
                    scores = detection[5:]
                    class_id = np.argmax(scores)
                    confidence = scores[class_id]
                    if confidence > conf_threshold and class_id == 2:
                        center_x = int(detection[0] * w + x)
                        center_y = int(detection[1] * h + y)
                        box_w = int(detection[2] * w)
                        box_h = int(detection[3] * h)
                        x1 = int(center_x - box_w / 2)
                        y1 = int(center_y - box_h / 2)
                        class_ids.append(class_id)
                        confidences.append(float(confidence))
                        boxes.append([x1, y1, box_w, box_h])

            
            indexes = cv2.dnn.NMSBoxes(boxes, confidences, conf_threshold, 0.4)
            count_cars = 0
            for j in range(len(boxes)):
                if j in indexes:
                    x1, y1, box_w, box_h = boxes[j]
                    cv2.rectangle(img, (x1, y1), (x1 + box_w, y1 + box_h), (0, 255, 0), 2)
                    count_cars += 1

            
            if count_cars > 0:
                car_found = True
                car_zone = zone_index + 1
                break

       
        if car_found:
            if car_zone == 1:
                position = "ВХОД"
            elif car_zone == 2:
                position = "ВыХОД"
            print("На изображении {} найдена машина в зоне {} ({}).".format(image_path, car_zone, position))
            
            break  



tumb = False
chs = True
while True:
    emily = db.reference("door").get()
    if emily == "open" and chs == True:
        tumb = True
    if tumb == True:
        print("сработало")
        scan_images()
        print(position)
        db.reference("car").set(position)
        db.reference("pos_start").set("start")
        
        position = ""
        tumb = False
        chs = False
    if emily == "close":
        chs = True