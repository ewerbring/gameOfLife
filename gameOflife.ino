#include <Wire.h>

void setup() {
 Serial.begin(9600);
  pinMode(2, INPUT_PULLUP);
  pinMode(4, INPUT_PULLUP);

  pinMode(13, OUTPUT);
}

void loop() {

 int c = analogRead(A3)/4;
 int f = analogRead(A1)/4;
 int t = analogRead(A4)/4;
 int a = analogRead(A5)/4;

 int notPressed = digitalRead(2);
 int notPressed2 = digitalRead(4);


 Serial.print(notPressed);
 Serial.print("P-");
  Serial.print(notPressed2);
 Serial.print("B>");

 Serial.print(t);
 Serial.print("T+");

 Serial.print(c);
 Serial.print("C,");
 Serial.print(f);
 Serial.print("F.");
 Serial.print(a);
 Serial.print("A_");



 
  
  
  // Sending to the serial connection the analug inputs introcued by the potentiometer.
  // As only is possible to send values from 0 to 255, devide de AnalogRead value by 4.
// Serial.write(analogRead(A1)/4);
// Serial.write(analogRead(A3)/4);
  // After sending the byte, let the ADC stabilize.
 delay(33);
}
