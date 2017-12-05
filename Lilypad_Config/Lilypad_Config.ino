
#include <SD.h>

const int buttonPin = 2;     // the number of the switch to activate
const int analogPin = 3;     // analog pin where EEG voltage is recorded

// variables will change:
int val;
int buttonState = 0;       // variable for reading switch status
bool start = true;
// Debug: bool time = true;
// Debug: unsigned long starttime = 0;
// Debug: int i;

File myFile; // File that is created on SD card


void setup() {

  // Debug: Serial.begin(115200);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  //set pin 10 to ouput to write to SD card Breakout
  pinMode(10, OUTPUT);
  if (!SD.begin(10)) {
    Serial.println("Initialization failed!");
    return;
  }
  
  if(SD.exists("data.txt")) {
    SD.remove("data.txt");
  }
  
  myFile = SD.open("data.txt", FILE_WRITE);
  myFile.close();
  Serial.println("Initialization successful");
  // Debug: i=0;
}

void loop() {

  buttonState = digitalRead(buttonPin);
  
  if (buttonState == LOW) {
    if(start) {
      start = false;
      myFile = SD.open("data.txt", FILE_WRITE);
    }
    
    // used to measure the time for debug
   /* if(time) {
      starttime = millis();
      time = false;
    } */
    val = analogRead(analogPin);
    float voltage = val * (5.0 / 1023.0);
    myFile.println(voltage);
    // Debug: i++;
    
    // Debug: Serial.println(voltage);
    // we use 935ms as we give 65ms for file data write
    // Debug:
    /*if((millis() - starttime)>= 1000) {
      Serial.println("Samples:");
      Serial.println(i);
      i = 0;
      time = true;
    } */
  
  }
  else {
    myFile.close();
    start = true;
    // Debug: time = true;
  }
  delayMicroseconds(3400);
}
