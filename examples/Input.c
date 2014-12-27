// This file is automatically generated.

#include <avr/io.h>
#include <stdbool.h>

static void clock();

static void stream_1();

static void stream_2(bool input_0);

static void stream_3(unsigned int input_0);

static void stream_4(bool input_0);

static void clock() {
  unsigned int output;
  static unsigned int temp0 = 0U;
  temp0++;
  output = temp0;
  stream_3(output);
}

static void stream_1() {
  bool output;
  output = (PINB & 0x10U) == 0x10U;
  stream_2(output);
}

static void stream_2(bool input_0) {
  bool output;
  if (input_0) {
    PORTB |= 0x20U;
  } else {
    PORTB &= ~(0x20U);
  }
}

static void stream_3(unsigned int input_0) {
  bool output;
  output = (input_0) % 2 == 0;
  stream_4(output);
}

static void stream_4(bool input_0) {
  bool output;
  if (input_0) {
    PORTB |= 0x08U;
  } else {
    PORTB &= ~(0x08U);
  }
}

int main(void) {
  TCCR1B = (1 << CS12) | (1 << CS10);
  DDRB &= ~(0x10U);
  PORTB |= 0x10U;
  DDRB |= 0x20U;
  DDRB |= 0x08U;
  while (1) {
    if (TCNT1 >= 10000) {
      TCNT1 = 0;
      clock();
    }
    stream_1();
  }
  return 0;
}