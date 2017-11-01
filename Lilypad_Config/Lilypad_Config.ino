#include <SD.h>

File myFile; // File that is created on SD card
int dataPoints = 0; // Total number of data recorded in one second
int analogEEGPin = 3; // Analong pin which is connected to EEG amplifier circuit
int val = 0; // EEG reading from analog pin

void setup() {
  
  Serial.begin(9600);
  Serial.print("Initilaizing SD Card: ");
  //set pin 10 to ouput to write to SD card Breakout
  pinMode(10, OUTPUT);
  if (!SD.begin(10)) {
    Serial.println("Initialization failed!");
    return;
  }
  Serial.println("Initialization successful");

  myFile = SD.open("data.txt", FILE_WRITE);

  if(!myFile) {
    Serial.println("Error opening data.txt");
    return;
  }
  
  cli();//stop interrupts
  
  //set timer1 interrupt at 1Hz
  TCCR1A = 0;// set entire TCCR1A register to 0
  TCCR1B = 0;// same for TCCR1B
  TCNT1  = 0;//initialize counter value to 0
  // set compare match register for 1hz increments
  OCR1A = 15624;// = (16*10^6) / (1*1024) - 1 (must be <65536)
  // turn on CTC mode
  TCCR1B |= (1 << WGM12);
  // Set CS10 and CS12 bits for 1024 prescaler
  TCCR1B |= (1 << CS12) | (1 << CS10);  
  // enable timer compare interrupt
  TIMSK1 |= (1 << OCIE1A);

  sei();//allow interrupts

}

void loop() {
  // Read data is less that 250 samples collected, and store it in file
  if(dataPoints < 250) {
    val = analogRead(analogEEGPin);
    myFile.println(val);
    dataPoints++;
  }
  else if(dataPoints == 250) {
    Serial.println("Number of data points recorded: " + dataPoints);
  }
  // 1/250 seconds = 3750 microseconds
  delayMicroseconds(3750);
}

// Interrupt to reset after 1 second has passed
ISR(TIMER1_COMPA_vect) {
  Serial.println("1 second passed");
  dataPoints = 0;
}

