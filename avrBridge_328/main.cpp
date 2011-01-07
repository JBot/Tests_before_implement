#include "WProgram.h"
#include <stdio.h>
#include "avrRos/Ros.h"
#include "avrRos/String.h"

extern "C" void __cxa_pure_virtual()
{
  cli();
  for (;;);
}


Publisher resp;

std_msgs::String call_msg;
std_msgs::String response_msg;

void toggle(){
	static char t=0;
	if (!t ) {
			 digitalWrite(13, HIGH);   // set the LED on
			 t = 1;
		 }
	else {
			 digitalWrite(13, LOW);    // set the LED off
			 t = 0;
		 }
}

void response(Msg *msg){
	toggle();
	
	//make sure that if you are manipulating the raw string, there is enough space in it
	//to handle all of the data
	sprintf(response_msg.data.getRawString(), "You sent : %s", call_msg.data.getRawString());
	ros.publish(resp, &response_msg);
}


// Since we are hooking into a standard arduino sketch, we must define our program in
// terms of the arduino setup and loop functions.

void setup(){
	ros.initCommunication();

	pinMode(13, OUTPUT);
	resp = ros.advertise("response");
	ros.subscribe("call",response, &call_msg);

	call_msg.data.setMaxLength(30);
	response_msg.data.setMaxLength(60);
}

void loop(){
	ros.spin();
	delay(10);
}

