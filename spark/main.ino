#include <math.h>
#define LED_CS 6
#define SWITCH_CS D0
#define LEFT_LED D0
#define RIGHT_LED D1
#define THERMISTOR_CS A7
#define PHOTOCELL A6
#define PIEZO A5

Servo rightServo, leftServo;
int temperature = 0, photocell = 0;
unsigned long uptime = 0;
unsigned long initialBootTime = 0;
bool leftLightOn = true, rightLightOn = true;

int move(String command){
    analogWrite(PIEZO, 120);
    switch(command.toInt()){
        case 0:
            //Deinit
            rightServo.write(90);
            leftServo.write(90);
            break;
        case 1:
            //Up
            rightServo.write(0);
            leftServo.write(180);
            break;
        case 2:
            //Down
            rightServo.write(180);
            leftServo.write(0);
            break;
        case 3:
            //Right
            rightServo.write(180);
            leftServo.write(180);
            break;
        case 4:
            //Left
            rightServo.write(0);
            leftServo.write(0);
            break;
        default:
            return 400;
    }
    return 200;
}

int led_control(String command){
    analogWrite(PIEZO, 120);
    switch(command.toInt()){
        case 0:
            leftLightOn = true;
            rightLightOn = true;
            break;
        case 1:
            leftLightOn = false;
            rightLightOn = false;
            break;
        case 11:
            leftLightOn = true;
            rightLightOn = false;
            break;
        case 12:
            leftLightOn = false;
            rightLightOn = true;
            break;
        default:
            return 400;
    }
    digitalWrite(LEFT_LED, leftLightOn);
    digitalWrite(RIGHT_LED, rightLightOn);
    return 200;
}

void setup() { 
  leftServo.attach(A0);
  rightServo.attach(A1);
 
  Spark.function("MOVE", move);
  Spark.function("LED_CONTROL", led_control);
  
  Spark.variable("temperature", &temperature, INT);
  Spark.variable("light", &photocell, INT);
  Spark.variable("uptime", &uptime, INT);
  Spark.variable("left_light", &leftLightOn, BOOLEAN);
  Spark.variable("right_light", &rightLightOn, BOOLEAN);

  pinMode(LED_CS, OUTPUT);
  pinMode(THERMISTOR_CS, INPUT);
  pinMode(PHOTOCELL, INPUT);
  pinMode(RIGHT_LED, OUTPUT);
  pinMode(LEFT_LED, OUTPUT);
  pinMode(PIEZO, OUTPUT);
  
  for(int i = 0; i < 21; i++){
    digitalWrite(RIGHT_LED, (i % 2 == 0));
    digitalWrite(LEFT_LED, (i % 2 == 0));
    delay(200-(i*10));
  }
  initialBootTime = millis();
}


void loop() { 
  unsigned long currentTime = millis();
  delay(50);
  temperature = analogRead(THERMISTOR_CS);
  photocell = analogRead(PHOTOCELL);
  uptime = (currentTime-initialBootTime)/1000;
}
