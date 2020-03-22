#include "Assignment1.h"

uint16_t getNodeFrequency(int sender_id) { 
    uint16_t timer;

    switch (TOS_NODE_ID)
  	{
  	    case 1:
  	        timer = MOTE_1_FREQ;
  	        break;
  	    case 2:
  	        timer = MOTE_2_FREQ;
  	        break;
  	    case 3:
  	        timer = MOTE_3_FREQ;
  	        break;
  	    default:
  	        timer = DEFAULT_FREQ;
  	}
  	
  	return timer;
}



