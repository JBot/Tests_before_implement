
/* This file was autogenerated as a part of the avr_bridge pkg

avr_bridge was written by 
Adam Stambler and Phillip Quiza of Rutgers University.

*/

#include "Ros.h"

char Ros::getTopicTag(char * topic){
if (strcmp(topic, "call") ==0)
	 return 0;
if (strcmp(topic, "response") ==0)
	 return 1;


	return 0;
}
Ros ros("callResponse", 2); //autogenerated Ros object