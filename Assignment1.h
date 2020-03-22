#ifndef ASSIGNMENT_1_H
#define ASSIGNMENT_1_H

typedef nx_struct msg_template_t {
  nx_uint16_t counter;
  nx_uint8_t node_id;
} msg_template_t;

enum {
  AM_ID = 6,
  MOTE_1_FREQ = 1000,
  MOTE_2_FREQ = 333,
  MOTE_3_FREQ = 200,
  DEFAULT_FREQ = 1000
};

#endif
