
int touch_pin1 =5;
int touch_pin2 =6;
int touch_pin3 =7;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 400;

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

    Serial.println("0,0;");
    Serial.println("1,0;");
    Serial.println("2,0;");

    if(val1>60000){
      Serial.println("0,1;");
    }
    else

    if(val2>60000){
      Serial.println("1,1;");
    }
    if(val3>60000){
      Serial.println("2,1;");
    }
    //Serial.print(val1);
    //print(","); // Delimiter
    //Serial.print(val2);
    //Serial.print(","); // Delimiter
    //Serial.println(val3); // Print the last value and a newline character
    startMillis = currentMillis;
  }


}
