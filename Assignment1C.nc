#include "Timer.h"
#include "Assignment1.h"
#include "printf.h"
#include "utils.h"

module Assignment1C @safe() {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as AMControl;
    interface Packet;
  }
}
implementation {

  message_t packet;

  bool locked;
  uint16_t counter = 0;
  
  void turnOfAll() {
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Off();
  }
  
  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {

    if (err == SUCCESS) {
      call MilliTimer.startPeriodic(getNodeFrequency(TOS_NODE_ID));
    } else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
  
  event void MilliTimer.fired() {
  
    if (locked) {
      return;
    } else {
      radio_count_msg_t* rcm = (radio_count_msg_t*)call Packet.getPayload(&packet, sizeof(radio_count_msg_t));
  
      if (rcm == NULL) {
	    return;
      }

      rcm->counter = counter;
      rcm->node_id = TOS_NODE_ID;
 
      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) == SUCCESS) {
	    locked = TRUE;
      }
    }
  }

  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
    counter++;
    if (len != sizeof(radio_count_msg_t)) {
        return bufPtr;
    } else {
        radio_count_msg_t* rcm = (radio_count_msg_t*)payload;

        if (rcm->counter % 10 == 0) {
            turnOfAll();
        } else {
            switch(rcm->node_id) {
                case 1: 
                    call Leds.led0Toggle();
                    break;
                case 2:
                    call Leds.led1Toggle();
                    break;
                case 3:
                    call Leds.led2Toggle();
                    break;
            }
        }

        
        return bufPtr;
    }
    
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

}




