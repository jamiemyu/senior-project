
#include <SD.h>

const int buttonPin = 2;     // the number of the switch to activate
const int analogPin = 3;     // analog pin where EEG voltage is recorded

// variables will change:
int val;
int buttonState = 0;       // variable for reading switch status
bool start = true;
unsigned long starttime = 0;
int array[270];
int i;
int j;

File myFile; // File that is created on SD card


void setup() {

  // Debug: Serial.begin(115200);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
  //set pin 10 to ouput to write to SD card Breakout
  pinMode(10, OUTPUT);
  if (!SD.begin(10)) {
    // Debug: Serial.println("Initialization failed!");
    return;
  }
  
  if(SD.exists("data.txt")) {
    SD.remove("data.txt");
  }
  
  myFile = SD.open("data.txt", FILE_WRITE);
  myFile.close();
  // Debug: Serial.println("Initialization successful");
  starttime = millis();
  i=0;
}

void loop() {

  buttonState = digitalRead(buttonPin);
  
  if (buttonState == LOW) {
    // used to measure the time
    if(start) {
      starttime = millis();
      start = false;
    } 
    val = analogRead(analogPin);
    float voltage = val * (5.0 / 1023.0);
    if(i < 250) {
      array[i] = val;
      i++;
    }
    
    Serial.println(voltage);
    // we use 935ms as we give 65ms for file data write
    if((millis() - starttime)>= 935) {
      start = true;
      // Debug: starttime = millis();
      // Debug: Serial.println("One second");
      myFile = SD.open("data.txt", FILE_WRITE);
      for(j = 0; j < i + 1; j++) {
        myFile.println(array[j]);
      }
      // -1 in the file marks a second of data
      myFile.println("-1");
      myFile.close();
      j=0;
      i=0; 
      // Debug: int stoptime = millis() - starttime;
      // Debug: Serial.println("Time to write");
      // Debug: Serial.println(stoptime);
    }
  
  }
  delayMicroseconds(3500);
}
