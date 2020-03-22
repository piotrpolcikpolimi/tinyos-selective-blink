#define NEW_PRINTF_SEMANTICS
#include "Assignment1.h"
#include "printf.h"


configuration Assignment1AppC {}
implementation {
    components MainC, LedsC, ActiveMessageC;

    components new AMSenderC(AM_ID) as Sender;
    components new AMReceiverC(AM_ID) as Receiver;
    components new TimerMilliC() as Timer;

    components Assignment1C as App;

    // linking 

    App.Boot -> MainC;

    App.AMSend -> Sender;
    App.Packet -> Sender;
    App.Receive -> Receiver;
    App.AMControl -> ActiveMessageC;
    App.MilliTimer -> Timer;

    App.Leds -> LedsC;
}
