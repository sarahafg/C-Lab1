#include <msp430.h>

/*
 * Swtich S1 - P1.1
 * LED1      - P1.0
 */

void delay(void) {
    volatile unsigned loops = 25000; // Start the delay counter at 25,000
    while (--loops > 0);             // Count down until the delay counter reaches 0
}

void main(void) {
    WDTCTL = WDTPW | WDTHOLD; // Stop watchdog timer

    P1REN |= BIT1;            // Connect resistor on P1.1 to P1OUT
    P2DIR |= BIT6;            // Make P2.6 an output
    PM5CTL0 &= ~LOCKLPM5;     // Unlock ports from power manager

    for (;;) {
      delay();              // Runs the delay sub-routine
      if (!(P1IN & BIT1))   // Reads the input from P1.1 and check its state
          P2OUT |= BIT6;    // If the button is pressed, turn on the LED
      else
          P2OUT &= ~BIT6;   // If the button isn't pressed, turn off the LED
    }
}
