#ifndef ASSIGNMENT_1_H
#define ASSIGNMENT_1_H

typedef nx_struct radio_count_msg {
  nx_uint16_t counter;
  nx_uint16_t node_id;
} radio_count_msg_t;

enum {
  AM_RADIO_COUNT_MSG = 6,
};

#endif
