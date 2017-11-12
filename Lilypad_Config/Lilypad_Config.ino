#include <SD.h>

File myFile; // File that is created on SD card
int dataPoints = 0; // Total number of data recorded in one second
const int analogEEGPin = 3; // Analong pin which is connected to EEG amplifier circuit
int val = 0; // EEG reading from analog pin
const int buttonPin = 2;

int buttonState = 0; // variable to read push button status

String fileName = "data";
int nFiles = 0;

void setup() {
  
  Serial.begin(9600);
  Serial.print("Initilaizing SD Card: ");
  pinMode(buttonPin, INPUT);
  //set pin 10 to ouput to write to SD card Breakout
  pinMode(10, OUTPUT);
  if (!SD.begin(10)) {
    Serial.println("Initialization failed!");
    return;
  }
  Serial.println("Initialization successful");
  while(!SD.exists(fileName + ".txt")) {
    nFiles++;
  }
}

void loop() {
  // read buton state
  buttonState = digitalRead(buttonPin);

  if(buttonState == HIGH) {
    myFile = SD.open(fileName + nFiles + ".txt", FILE_WRITE);
    if(!myFile) {
      Serial.println("Error opening data.txt");
      return;
    }
    val = analogRead(analogEEGPin);
    myFile.println(val);
    myFile.close();
  }
  
  // 1/250 seconds = 3750 microseconds
  delayMicroseconds(4000);
}



