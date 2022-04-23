
// ATTINY2313 as remote control for BENQ MS513 projector (power button only)
// Pin PB2 user for IR led output.
// Lasse Latva 2014
// LICENSE: MIT

#define F_CPU 1000000UL

#include <avr/io.h>
#include <util/delay.h>

#define IR_LED_PORT PORTB
#define IR_LED_PIN PB2
    
void rc5_send_pulses(void) {
   unsigned char i = 32;   
   while(i--) {
      PORTB = ~(_BV(IR_LED_PIN));
      _delay_us(7);
      PORTB = _BV(IR_LED_PIN);									
      _delay_us(19);
   }
}

void rc5_send(char address, char command) {
   unsigned int code;
   unsigned char i;
    
  code = 0x07;                  
  code <<= 5;
  code |= (address & 0x1F);     
  code <<= 6;
  code |= (command & 0x3F);     
  code <<= 2;                   

  i = 14;             // sending 14 bits
  while (i--) {
     if (code & 0x8000) { // bit 1
	_delay_us(889);	
	rc5_send_pulses();
     }
     
     else { // bit 0
	rc5_send_pulses();
	_delay_us(889);
     }
     
     code <<= 1;     // next bit
  }
}

int main(void) {
   DDRB = _BV(2); // pin 2 as output
   /* PORTB = _BV(2); */
   /* _delay_ms(100); */
   /* PORTB = 0x00; */
   // BENQ MS513 POWER BUTTON:
   rc5_send(141,130);
   _delay_ms(250);
   return 0;
}

