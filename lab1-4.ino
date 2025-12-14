
int touch_pin1 =5;
int touch_pin2 =6;
int touch_pin3 =7;
int touch_slider1 = 9;
int touch_slider2 = 10;
int touch_slider3 = 11;
int touch_slider4 = 12;
int touch_slider5 = 13;

// int slider1_min = 60000;
// int slider1_max = 101203;
// int slider2_min = 72500;
// int slider2_max = 111847;
// int slider3_min = 75000;
// int slider3_max = 117737;
// int slider4_min = 77180;
// int slider4_max = 118773;
// int slider5_min = 65141;
// int slider5_max = 100000;

int slider1_min = 70000;
int slider1_max = 105000;
int slider2_min = 90000;
int slider2_max = 130000;
int slider3_min = 90000;
int slider3_max = 127000;
int slider4_min = 96000;
int slider4_max = 120000;
int slider5_min = 80000;
int slider5_max = 125000;

unsigned long startMillis;
unsigned long currentMillis;
const unsigned long period = 400;

float discreteV = 0.5;
float frac1;
float frac2;
float frac;

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

    int sliderValue1, sliderValue2, sliderValue3, sliderValue4, sliderValue5;
    sliderValue1 = touchRead(touch_slider1);
    sliderValue2 = touchRead(touch_slider2);
    sliderValue3 = touchRead(touch_slider3);
    sliderValue4 = touchRead(touch_slider4);
    sliderValue5 = touchRead(touch_slider5);

    

    // Serial.println("0,0;");
    // Serial.println("1,0;");
    // Serial.println("2,0;");

    if(val1>59000){
      Serial.println("0,1;");
    }
    else

    if(val2>59000){
      Serial.println("1,1;");
    }
    if(val3>59000){
      Serial.println("2,1;");
    }
    // Serial.print(val1);
    // Serial.print(","); // Delimiter
    // Serial.print(val2);
    // Serial.print(","); // Delimiter
    // Serial.println(val3); // Print the last value and a newline character

    // Serial.print(sliderValue1);
    // Serial.print(","); // Delimiter
    // Serial.print(sliderValue2);
    // Serial.print(","); // Delimiter
    // Serial.print(sliderValue3);
    // Serial.print(","); // Delimiter
    // Serial.print(sliderValue4);
    // Serial.print(","); // Delimiter
    // Serial.println(sliderValue5); // Print the last value and a newline character


  // Serial.println("0,"+ String(sliderValue1>=slider1_min));
  // Serial.println("1,"+ String(sliderValue2>=slider2_min));
  // Serial.println("2,"+ String(sliderValue3>=slider3_min));
  // Serial.println("3,"+ String(sliderValue4>=slider4_min));
  // Serial.println("4,"+ String(sliderValue5>=slider5_min));

  if(sliderValue1>=slider1_min)       {discreteV = 0.0;  if(sliderValue2>=slider2_min){frac1 = (float)sliderValue1/slider1_max; 
                                        frac2 = (float)sliderValue2/slider2_max; frac = ((1- frac1)+frac2)/8; discreteV = discreteV+frac;} }
  else if(sliderValue2>=slider2_min)  {discreteV = 0.25; if(sliderValue3>=slider3_min){frac1 = (float)sliderValue2/slider2_max; frac2 = (float)sliderValue3/slider3_max; frac = ((1- frac1)+frac2)/8; discreteV = discreteV+frac;} }
  else if(sliderValue3>=slider3_min)  {discreteV = 0.5;  if(sliderValue4>=slider4_min){frac1 = (float)sliderValue3/slider3_max; frac2 = (float)sliderValue4/slider4_max; frac = ((1- frac1)+frac2)/8; discreteV = discreteV+frac;} }
  else if(sliderValue4>=slider4_min)  {discreteV = 0.75; if(sliderValue5>=slider5_min){frac1 = (float)sliderValue4/slider4_max; frac2 = (float)sliderValue5/slider5_max; frac = ((1- frac1)+frac2)/8; discreteV = discreteV+frac;} }
  else if(sliderValue5>=slider5_min)  {discreteV = 1.0;   }

  // if(sliderValue1>=slider1_min && sliderValue2>=slider2_min )   {frac1 = (float)sliderValue1/slider1_max; frac2 = (float)sliderValue2/slider2_max; frac = ((1- frac1)+frac2)/8;}
  // else if(sliderValue2>=slider2_min && sliderValue3>=slider3_min )   {frac1 = (float)sliderValue2/slider2_max; frac2 = (float)sliderValue3/slider3_max; frac = ((1- frac1)+frac2)/8;}
  // else if(sliderValue3>=slider3_min && sliderValue4>=slider4_min )   {frac1 = (float)sliderValue3/slider3_max; frac2 = (float)sliderValue4/slider4_max; frac = ((1- frac1)+frac2)/8;}
  // else if(sliderValue4>=slider4_min && sliderValue5>=slider5_min )   {frac1 = (float)sliderValue4/slider4_max; frac2 = (float)sliderValue5/slider5_max; frac = ((1- frac1)+frac2)/8;}


  //Serial.println(discreteV);
  //Serial.println(frac1);
  
  Serial.println("3," + String(discreteV) + ";");

    startMillis = currentMillis;
  }


}
