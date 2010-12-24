/*****************************************************
Project : Maximus
Version : 1.0
Date : 10/12/2010
Author : JBot
Company :
Comments:

Program type : Application
Clock frequency : 16,00 MHz
 *****************************************************/
// Arduino specific includes
#include <Servo.h>

// Other includes
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <math.h>
#include <ctype.h>

/* Wait function */
void delay_ms(uint16_t millis)
{
    while (millis) {
        _delay_ms(1);
        millis--;
    }
}


#define ACCURACY 10

Servo turret;

int entier;
char display1, display2, display3, display4;

int sonar[180 / ACCURACY];

/*************************/
/* SYSTEM INITIALIZATION */
/*************************/
void setup()
{

    pinMode(13, OUTPUT);


    // Initialize all serial ports:
//    Serial.begin(115200);                                  // Bluetooth serial port
    Serial.begin(9600);                                    // Bluetooth serial port


    turret.attach(4);



    /******************************/
    /* Initialization of the code */
    /******************************/

    // Global enable interrupts
    sei();

    digitalWrite(13, HIGH);
    delay_ms(300);
    digitalWrite(13, LOW);
    delay_ms(300);
    digitalWrite(13, HIGH);
    delay_ms(300);


    delay_ms(1000);

}

void loop()
{

    float volts;
    float distance;
    delay_ms(50);

    int angle = 0;

    for (angle = 75; angle < 105; angle += ACCURACY) {

        turret.write(angle);
        // Compute sensors
        delay_ms(40);

        volts = analogRead(0) * 0.0048828125;
        distance = 65 * pow(volts, -1.10);
        sonar[(angle - 30) / ACCURACY] = (int) distance;

        volts = analogRead(1) * 0.0048828125;
        distance = 65 * pow(volts, -1.10);
        sonar[(angle) / ACCURACY] = (int) distance;

        volts = analogRead(2) * 0.0048828125;
        distance = 65 * pow(volts, -1.10);
        sonar[(angle + 30) / ACCURACY] = (int) distance;
    }
    turret.write(30);
    flush_sonar_datas();
}

void flush_sonar_datas(void)
{

    Serial.write('S');

    for (int i = 45 / ACCURACY; i < 135 / ACCURACY; i++) {

        entier = (unsigned int) abs(sonar[i]);
        display4 = (entier % 10) + 48;
        entier = (unsigned int) (entier / 10);
        display3 = (entier % 10) + 48;
        entier = (unsigned int) (entier / 10);
        display2 = (entier % 10) + 48;
        entier = (unsigned int) (entier / 10);
        display1 = (entier % 10) + 48;

        Serial.write(display1);
        Serial.write(display2);
        Serial.write(display3);
        Serial.write(display4);


    }


}
