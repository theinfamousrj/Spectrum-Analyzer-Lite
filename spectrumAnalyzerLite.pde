//  Created by theinfamousrj
//  Copyright (c) 2011 omfgp.com. All rights reserved.

// Spectrum analyzer read values will be kept here.
int SpectrumLeft[7];
int SpectrumRight[7];

//For spectrum analyzer shield, these three pins are used.
//You can move pins 4 and 5, but you must cut the trace on the shield and re-route from the 2 jumpers. 
int spectrumReset = 5;
int spectrumStrobe = 4;
int spectrumAnalog = 0;  //0 for left channel, 1 for right.

// --- STUFF YOU CAN EDIT! ---
int ledMin = 6;   // beginning pin of LED string
int ledMax = 12;  // end pin of LED string 
// --- STUFF YOU CAN EDIT! ---


// Standard setup stuff
void setup() {
  byte Counter;

  //Setup pins to drive the spectrum analyzer. 
  pinMode(spectrumReset, OUTPUT);
  pinMode(spectrumStrobe, OUTPUT);

  //Init spectrum analyzer
  digitalWrite(spectrumStrobe,LOW);
    delay(1);
  digitalWrite(spectrumReset,HIGH);
    delay(1);
  digitalWrite(spectrumStrobe,HIGH);
    delay(1);
  digitalWrite(spectrumStrobe,LOW);
    delay(1);
  digitalWrite(spectrumReset,LOW);
    delay(5);
  
  // Sets the pins as output pints from ledMin to ledMax
  for(int n=ledMin; n<=ledMax; n++) {
    pinMode(n, OUTPUT);
  }
  
  // A little light test
  lightTest(5);
}


// The loop reads the spectrum and dances the lights accordingly
void loop() {
  
  readSpectrum();
  danceAllLights();
  
}


// Function to read 7 band equalizers
void readSpectrum() {
  // Band 0 = Lowest Frequencies.
  byte Band;
  
  for(Band = 0; Band < 7; Band++) {
    SpectrumLeft[Band] = analogRead(0); //left
    SpectrumRight[Band] = analogRead(1); //right
    digitalWrite(spectrumStrobe, HIGH);  //Strobe pin on the shield
    digitalWrite(spectrumStrobe, LOW);     
  }
}


// Dances specific lights to specific frequencies
void danceAllLights() {
  for(int j=1; j<=7; j++) {
    if(j==2) {
      if(SpectrumLeft[j] >= 600 && SpectrumLeft[j] <= 900) {
        digitalWrite((j+5), HIGH);
        delay(1);
        digitalWrite((j+5), LOW);
      }
    }
    else if(j==3 || j==4 || j==5) {
      if((SpectrumLeft[j] % 2) == 0) {
        if(SpectrumLeft[j] >= 600 && SpectrumLeft[j] <= 900) {
          digitalWrite((j+5), HIGH);
          delay(1);
          digitalWrite((j+5), LOW);
        }
      }
    }
    else {
      if(SpectrumLeft[j] >= 400 && SpectrumLeft[j] <= 1000) {
        digitalWrite((j+5), HIGH);
        delay(1);
        digitalWrite((j+5), LOW);
      }
    }
  }
}


// Tests the lights quickly
void lightTest(int num) {
  for(int n=0; n<num; n++) {
    for(int m=ledMin; m<=ledMax; m++) {
      digitalWrite(m, HIGH);
      delay(60);
      digitalWrite(m, LOW);
    }
  }
}
