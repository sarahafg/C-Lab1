;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
; NOTES: The input button is on P1.1 and the output LED is on P1.0
;-------------------------------------------------------------------------------


setup:      bis.b   #BIT1, &P1REN       ; Connect resistor on P1.1 to P1OUT
            bis.b   #BIT1, &P1OUT       ; Set output register for P1.1 to '1'
            bis.b   #BIT0, &P1DIR       ; Make P1.0 an output
            bic.w   #LOCKLPM5, &PM5CTL0 ; Unlock ports from power manager

mainloop:                               ; The main polling loop

            mov.w   #25000, R4          ; Start the delay counter at 50,000
delay:      dec.w   R4                  ; Decrement the delay counter for each loop
            jnz     delay               ; Keep looping until the counter becomes 0

readinput:  bit.b   #BIT1, &P1IN        ; Read the input from P1.1 and check its state
            jnz     notpressed
pressed:    bis.b   #BIT0, &P1OUT       ; If the button is pressed, turn on the LED
            jmp     mainloop
notpressed: bic.b   #BIT0, &P1OUT       ; If the button isn't pressed, turn off the LED
            jmp     mainloop



;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET

