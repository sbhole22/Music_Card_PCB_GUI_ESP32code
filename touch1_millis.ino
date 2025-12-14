
int touch_pin1 =5;
int touch_pin2 =6;
int touch_pin3 =7;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 10;

void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
startMillis = millis();
}

void loop() {
  // put your main code here, to run repeatedly:
// Send value 1
  currentMillis = millis();
  if (currentMillis - startMillis >= period)
  {
    int val1 = touchRead(touch_pin1);
    int val2 = touchRead(touch_pin2);
    int val3 = touchRead(touch_pin3);
    Serial.print(val1);
    Serial.print(","); // Delimiter
    Serial.print(val2);
    Serial.print(","); // Delimiter
    Serial.println(val3); // Print the last value and a newline character
    startMillis = currentMillis;
  }


}
