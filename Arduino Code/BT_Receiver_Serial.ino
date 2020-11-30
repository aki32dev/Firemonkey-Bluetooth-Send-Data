byte incomingString = "";
void setup() {
  Serial.begin(9600);

}

void loop() {
  if (Serial.available() > 0) {
    // read the incoming byte:
    incomingString = Serial.read();

    // say what you got:
    Serial.println(incomingString);
  }
  
}
