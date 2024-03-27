/*******************************************************
This program was created by the CodeWizardAVR V3.29
Automatic Program Generator
© Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 31.12.2016
Author  :
Company :
Comments:


Chip type               : ATtiny2313
AVR Core Clock frequency: 4,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*******************************************************/

#include <io.h>
#include <tiny2313.h>
#include <doorhan.h>
#include <delay.h>

void main(void)
{
	 InitMCU();
	 DR_CL = 0;
	 DR_OP = 0;
    SA = SA_STOP;

#asm("sei")

	 while (1)
		  {
		    ReadKey();
            ReadSenCL();
            ReadSenOP();
            SwitchState();
#asm("cli")
#asm("wdr") // сброс сторожевого таймера!!! [1sec]
#asm("sei")
		  };
};

void SwitchState(void)
{
    switch(PressedKey)
		  {
		  case key_none : break;
		  case key_bt_st :
				{
				SA = SA_STOP;
                DR_CL = DR_OP = 0;
				delay_ms(DEL_ACTION);
                break;
				};
		  case key_bt_cl :
				{
				if(SA == SA_OPEN)
                    {
                        SA = SA_STOP; 
                        DR_CL = DR_OP = 0;
                        delay_ms(DEL_ACTION);
                    }
                else 
                    {
                        SA = SA_CLOSE;
                        DR_CL = 1;
				        DR_OP = 0;
                    };
				break;
				};
		  case key_bt_op :
				{
				if(SA == SA_CLOSE)
                    {
                        SA = SA_STOP; 
                        DR_CL = DR_OP = 0;
                        delay_ms(DEL_ACTION);
                    } 
                else 
                    {
                        SA = SA_OPEN;
                        DR_CL = 0;
				        DR_OP = 1;
                    };
				break;
				};
		  };
        if(sen_sn_cl)
        {
         if(SA == SA_CLOSE) 
            {
                SA = SA_STOP; 
                DR_CL = DR_OP = 0;
                delay_ms(DEL_ACTION);
            };
        };
        if(sen_sn_op)
        {
         if(SA == SA_OPEN) 
            {
                SA = SA_STOP; 
                DR_CL = DR_OP = 0;
                delay_ms(DEL_ACTION);
            };
        }; 
};

void ReadSenCL(void)
{
    static unsigned int CountSen1;
    
    sen_sn_cl = key_none; 
    
    if(SN_CL)
     {
      if(CountSen1 >= ONE_PRESS_SEN)
      {
         sen_sn_cl = 1;
         CountSen1 -= 10;
         return;
      }
      else CountSen1++;                 
      }
     else CountSen1 = 0;
};

void ReadSenOP(void)
{
     static unsigned int CountSen2;

     sen_sn_op = key_none;
    
     if(SN_OP)
     {
      if(CountSen2 >= ONE_PRESS_SEN)
      {
         sen_sn_op = 1;
         CountSen2 -= 10;
         return;
      }
      else CountSen2++;                 
      }
     else CountSen2 = 0; 
};

void ReadKey(void)
{
	 static unsigned char key;
	 static unsigned int CountKey;
    
    PressedKey = key_none;
    if(BT_ST == 1)key = key_bt_st;
	 else if(BT_CL == 0)key = key_bt_cl;
	 else if(BT_OP == 0)key = key_bt_op;
	 else key = key_none;

	 if(key)                                        // Если нажата клавиша, то считаем
		  {                                          // до тех пор пока счетчик не сравняется 
		   if(CountKey == ONE_PRESS_KEY)                 // с ONE_PRESS.  
         {
            PressedKey = key;
            CountKey++;                            // Увеличиваем счетчик, чтобы больше сюда не заходить.
            return;
         }
         else
         {
            if(CountKey < ONE_PRESS_KEY)CountKey++;     // Это позволяет считывать одно нажатие,
         };                                         // не зависимо от времени удержания.
		  }
	 else CountKey = 0;                              // Обнуляем счетчик, если нажатие не уложилось во время ONE_PRESS.
};

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)  // 100Hz, 10ms
{
	 TCNT1H = 0x63C0 >> 8;
	 TCNT1L = 0x63C0 & 0xff;
};

void InitMCU(void)
{

	 // Crystal Oscillator division factor: 1
#pragma optsize-
	 CLKPR = (1 << CLKPCE);
	 CLKPR = (0 << CLKPCE) | (0 << CLKPS3) | (0 << CLKPS2) | (0 << CLKPS1) | (0 << CLKPS0);
	 #ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	 #endif

	 // Input/Output Ports initialization
	 // Port A initialization
	 // Function: Bit2=In Bit1=In Bit0=In
	 DDRA = (0 << DDA2) | (0 << DDA1) | (0 << DDA0);
	 // State: Bit2=T Bit1=T Bit0=T
	 PORTA = (0 << PORTA2) | (0 << PORTA1) | (0 << PORTA0);

	 // Port B initialization
	 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
	 DDRB = (0 << DDB7) | (0 << DDB6) | (0 << DDB5) | (0 << DDB4) | (0 << DDB3) | (0 << DDB2) | (1 << DDB1) | (1 << DDB0);
	 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
	 PORTB = (0 << PORTB7) | (0 << PORTB6) | (0 << PORTB5) | (0 << PORTB4) | (0 << PORTB3) | (0 << PORTB2) | (0 << PORTB1) | (0 << PORTB0);

	 // Port D initialization
	 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
	 DDRD = (0 << DDD6) | (0 << DDD5) | (0 << DDD4) | (0 << DDD3) | (0 << DDD2) | (0 << DDD1) | (0 << DDD0);
	 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
	 PORTD = (0 << PORTD6) | (0 << PORTD5) | (0 << PORTD4) | (0 << PORTD3) | (0 << PORTD2) | (0 << PORTD1) | (0 << PORTD0);

	 // Timer/Counter 0 initialization
	 // Clock source: System Clock
	 // Clock value: Timer 0 Stopped
	 // Mode: Normal top=0xFF
	 // OC0A output: Disconnected
	 // OC0B output: Disconnected
	 TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (0 << COM0B1) | (0 << COM0B0) | (0 << WGM01) | (0 << WGM00);
	 TCCR0B = (0 << WGM02) | (0 << CS02) | (0 << CS01) | (0 << CS00);
	 TCNT0 = 0x00;
	 OCR0A = 0x00;
	 OCR0B = 0x00;

	 // Timer/Counter 1 initialization
	 // Clock source: System Clock
	 // Clock value: 4000,000 kHz
	 // Mode: Normal top=0xFFFF
	 // OC1A output: Disconnected
	 // OC1B output: Disconnected
	 // Noise Canceler: Off
	 // Input Capture on Falling Edge
	 // Timer Period: 10 ms
	 // Timer1 Overflow Interrupt: On
	 // Input Capture Interrupt: Off
	 // Compare A Match Interrupt: Off
	 // Compare B Match Interrupt: Off
	 TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
	 TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (0 << CS12) | (0 << CS11) | (0 << CS10);
	 TCNT1H = 0x63;
	 TCNT1L = 0xC0;
	 ICR1H = 0x00;
	 ICR1L = 0x00;
	 OCR1AH = 0x00;
	 OCR1AL = 0x00;
	 OCR1BH = 0x00;
	 OCR1BL = 0x00;

	 // Timer(s)/Counter(s) Interrupt(s) initialization
	 TIMSK = (1 << TOIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << ICIE1) | (0 << OCIE0B) | (0 << TOIE0) | (0 << OCIE0A);

	 // External Interrupt(s) initialization
	 // INT0: Off
	 // INT1: Off
	 // Interrupt on any change on pins PCINT0-7: Off
	 GIMSK = (0 << INT1) | (0 << INT0) | (0 << PCIE);
	 MCUCR = (0 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);

	 // USI initialization
	 // Mode: Disabled
	 // Clock source: Register & Counter=no clk.
	 // USI Counter Overflow Interrupt: Off
	 USICR = (0 << USISIE) | (0 << USIOIE) | (0 << USIWM1) | (0 << USIWM0) | (0 << USICS1) | (0 << USICS0) | (0 << USICLK) | (0 << USITC);

	 // USART initialization
	 // USART disabled
	 UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (0 << TXEN) | (0 << UCSZ2) | (0 << RXB8) | (0 << TXB8);

	 // Analog Comparator initialization
	 // Analog Comparator: Off
	 // The Analog Comparator's positive input is
	 // connected to the AIN0 pin
	 // The Analog Comparator's negative input is
	 // connected to the AIN1 pin
	 ACSR = (1 << ACD) | (0 << ACBG) | (0 << ACO) | (0 << ACI) | (0 << ACIE) | (0 << ACIC) | (0 << ACIS1) | (0 << ACIS0);
	 // Digital input buffer on AIN0: On
	 // Digital input buffer on AIN1: On
	 DIDR = (0 << AIN0D) | (0 << AIN1D);


	 // Watchdog Timer initialization
	 // Watchdog Timer Prescaler: OSC/128k
	 // Watchdog timeout action: Reset
#pragma optsize-
#asm("wdr")
	 WDTCR |= (1 << WDCE) | (1 << WDE);
	 WDTCR = (0 << WDIF) | (0 << WDIE) | (0 << WDP3) | (0 << WDCE) | (1 << WDE) | (1 << WDP2) | (1 << WDP1) | (0 << WDP0);
	 #ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	 #endif
};
