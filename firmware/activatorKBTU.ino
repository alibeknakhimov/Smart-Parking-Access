#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
#include <Wire.h>


// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Insert your network credentials
const char* WIFI_SSID = "Wifi";
const char* WIFI_PASSWORD = "artofwar3";

// Insert Firebase project API Key
#define API_KEY "AIzaSyDBZ1E652kt2XmItr5IB6sKsW1Ql4l_SxY"

// Insert Authorized Email and Corresponding Password
#define USER_EMAIL "kbtuactivator@kbtu.kz"
#define USER_PASSWORD "ali278578"

// Insert RTDB URLefine the RTDB URL
#define DATABASE_URL "https://kbtu-4554c-default-rtdb.firebaseio.com/"

// Define Firebase objects
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Variable to save USER UID
String uid;

// Variables to save database paths
String databasePath;
String tempPath;
String humPath;
String presPath;

float temperature;
float humidity;
float pressure;
int read_data;
int pausa;
// Timer variables (send new readings every three minutes)
unsigned long sendDataPrevMillis = 0;
unsigned long timerDelay = 2000;
boolean pol = 0;
// Initialize BME280


// Initialize WiFi
void initWiFi() {
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }
  Serial.println(WiFi.localIP());
  Serial.println();
}

// Write float values to the database
void sendInt(String path, int value) {
  if (Firebase.RTDB.setInt(&fbdo, path.c_str(), value)) {
    Serial.print("Writing value: ");
    Serial.print (value);
    Serial.print(" on the following path: ");
    Serial.println(path);
    Serial.println("PASSED");
    Serial.println("PATH: " + fbdo.dataPath());
    Serial.println("TYPE: " + fbdo.dataType());
  }
  else {
    Serial.println("FAILED");
    Serial.println("REASON: " + fbdo.errorReason());
  }
}
void sendStrings(String path, String value) {
  if (Firebase.RTDB.setString(&fbdo, path.c_str(), value)) {
    Serial.print("Writing value: ");
    Serial.print (value);
    Serial.print(" on the following path: ");
    Serial.println(path);
    Serial.println("PASSED");
    Serial.println("PATH: " + fbdo.dataPath());
    Serial.println("TYPE: " + fbdo.dataType());
  }
  else {
    Serial.println("FAILED");
    Serial.println("REASON: " + fbdo.errorReason());
  }
}
void readInt() {
  if (Firebase.RTDB.getInt(&fbdo, "/pausa"))
  {
    if (fbdo.dataType() == "int")
    {
      pausa = fbdo.intData();
      Serial.print("Data received: ");
      Serial.println(pausa); //print the data received from the Firebase database
    }
  }
  else
  {
    Serial.println(fbdo.errorReason()); //print he error (if any)
  }
}
void setup() {
  Serial.begin(115200);

  initWiFi();

  // Assign the api key (required)
  config.api_key = API_KEY;

  // Assign the user sign in credentials
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  // Assign the RTDB URL (required)
  config.database_url = DATABASE_URL;

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  // Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  // Assign the maximum retry of token generation
  config.max_token_generation_retry = 5;

  // Initialize the library with the Firebase authen and config
  Firebase.begin(&config, &auth);

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  readInt();
  tempPath = "/temperature"; // --> UsersData/<user_uid>/temperature
  humPath = "/door"; // --> UsersData/<user_uid>/humidity
  presPath = "/shlagbaum"; // --> UsersData/<user_uid>/pressure
  pinMode(25, OUTPUT);
  digitalWrite(25, LOW);
}

void loop() {
  // Send new readings to database
  if (Firebase.ready() && (millis() - sendDataPrevMillis > timerDelay || sendDataPrevMillis == 0) && pol == 0) {
    sendDataPrevMillis = millis();

    if (Firebase.RTDB.getInt(&fbdo, "/shlagbaum/control"))
    {
      if (fbdo.dataType() == "int")
      {
        read_data = fbdo.intData();
        Serial.print("Data received: ");
        Serial.println(read_data); //print the data received from the Firebase database
        if (read_data == 1) {
          Serial.println("done");
          pol = 1;
        }
      }
    }
    else
    {
      Serial.println(fbdo.errorReason()); //print he error (if any)
    }
  }
  if(pol == 1){
      sendStrings(humPath, "open");
      digitalWrite(25, HIGH);
      delay(100);
      digitalWrite(25, LOW);
      delay(pausa * 1000);
      digitalWrite(25, HIGH);
      delay(100);
      digitalWrite(25, LOW);
      sendStrings(humPath, "close");
      sendInt(presPath, 0);
      pol = 0;
  }
}
