#include "Timer.h"
#include "Assignment1.h"
#include "utils.h"

module Assignment1C @safe() {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MTimer;
    interface SplitControl as AMControl;
    interface Packet;
  }
}
implementation {

    message_t packet;

    bool locked;
    uint16_t counter = 0;
    uint16_t retryCounter = 0;

    // method for turning off all leds
    void turnOfAll() {
        call Leds.led0Off();
        call Leds.led1Off();
        call Leds.led2Off();
    }

    // set message payload
    message_t* setPayload(message_t* pck) {
        msg_template_t* msg = (msg_template_t*)call Packet.getPayload(pck, sizeof(msg_template_t));
        msg->counter = counter;
        msg->sender_id = TOS_NODE_ID;

        return pck;
    }

    void retryOrTimeout() {
        retryCounter++;
        if (retryCounter < RADIO_START_TIMEOUT_LIMIT) {
            // retry starting
            call AMControl.start();
        } else {
            // retry limit reached, timeout
            call AMControl.stop();
        }
    }

    // booting, initializing the radio
    event void Boot.booted() {
        call AMControl.start();
    }

    // check if radio started succesfully. 
    event void AMControl.startDone(error_t err) {
        if (err == SUCCESS) {
            // radio booted. Start timer.
            call MTimer.startPeriodic(getNodeFrequency(TOS_NODE_ID));
        } else {
            retryOrTimeout();
        }
    }

    event void AMControl.stopDone(error_t err) { }

    event void MTimer.fired() {
        if (locked) {
            return;
        } else {
            // Radio not busy. Get payload and send message
            if (call AMSend.send(AM_BROADCAST_ADDR, setPayload(&packet), sizeof(msg_template_t)) == SUCCESS) {
                locked = TRUE;
            }
        }
    }

    // message send. Clear the radio lock
    event void AMSend.sendDone(message_t* bufPtr, error_t error) {
        if (&packet == bufPtr) {
            locked = FALSE;
        }
    }

    event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len) {
        // message received. Increase the counter
        counter++;

        // check message correctness
        if (len != sizeof(msg_template_t)) {
            return bufPtr;
        } else {
            // cast the message payload to the known template
            msg_template_t* msg = (msg_template_t*)payload;

            if (msg->counter % 10 == 0) {
                turnOfAll();
            } else {
                switch(msg->sender_id) {
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
}
