#include <math.h>
#define LED_CS 6
#define SWITCH_CS D0
#define LEFT_LED D0
#define RIGHT_LED D1
#define THERMISTOR_CS A7
#define PHOTOCELL A6
#define PIEZO A5

Servo rightServo, leftServo;
int temperature = 0, photocell = 0, runs = 0;

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
            digitalWrite(LEFT_LED, 1);
            digitalWrite(RIGHT_LED, 1);
            break;
        case 1:
            digitalWrite(LEFT_LED, 0);
            digitalWrite(RIGHT_LED, 0);
            break;
        case 11:
            digitalWrite(LEFT_LED, 1);
            digitalWrite(RIGHT_LED, 0);
            break;
        case 12:
            digitalWrite(LEFT_LED, 0);
            digitalWrite(RIGHT_LED, 1);
            break;
        default:
            return 400;
    }
    return 200;
}

void setup() { 
  leftServo.attach(A0);
  rightServo.attach(A1);
 
  Spark.function("MOVE", move);
  Spark.function("LED_CONTROL", led_control);
  
  Spark.variable("temperature", &temperature, INT);
  Spark.variable("light", &photocell, INT);
  Spark.variable("runs", &runs, INT);

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
}


void loop() { 
  runs++;
  delay(100);
  temperature = analogRead(THERMISTOR_CS);
  photocell = analogRead(PHOTOCELL);
}
