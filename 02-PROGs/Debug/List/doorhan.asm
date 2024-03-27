
;CodeVisionAVR C Compiler V3.29 Evaluation
;(C) Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 4,000000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sen_sn_cl=R3
	.DEF _sen_sn_op=R2
	.DEF _PressedKey=R5
	.DEF _SA=R4

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*******************************************************
;This program was created by the CodeWizardAVR V3.29
;Automatic Program Generator
;© Copyright 1998-2016 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 31.12.2016
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 4,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*******************************************************/
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <tiny2313.h>
;#include <doorhan.h>
;#include <delay.h>
;
;void main(void)
; 0000 001C {

	.CSEG
_main:
; .FSTART _main
; 0000 001D 	 InitMCU();
	RCALL _InitMCU
; 0000 001E 	 DR_CL = 0;
	CBI  0x18,0
; 0000 001F 	 DR_OP = 0;
	CBI  0x18,1
; 0000 0020     SA = SA_STOP;
	CLR  R4
; 0000 0021 
; 0000 0022 #asm("sei")
	SEI
; 0000 0023 
; 0000 0024 	 while (1)
_0x7:
; 0000 0025 		  {
; 0000 0026 		    ReadKey();
	RCALL _ReadKey
; 0000 0027             ReadSenCL();
	RCALL _ReadSenCL
; 0000 0028             ReadSenOP();
	RCALL _ReadSenOP
; 0000 0029             SwitchState();
	RCALL _SwitchState
; 0000 002A #asm("cli")
	CLI
; 0000 002B #asm("wdr") // сброс сторожевого таймера!!! [1sec]
	WDR
; 0000 002C #asm("sei")
	SEI
; 0000 002D 		  };
	RJMP _0x7
; 0000 002E };
_0xA:
	RJMP _0xA
; .FEND
;
;void SwitchState(void)
; 0000 0031 {
_SwitchState:
; .FSTART _SwitchState
; 0000 0032     switch(PressedKey)
	MOV  R30,R5
	LDI  R31,0
; 0000 0033 		  {
; 0000 0034 		  case key_none : break;
	SBIW R30,0
	BREQ _0xD
; 0000 0035 		  case key_bt_st :
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF
; 0000 0036 				{
; 0000 0037 				SA = SA_STOP;
	RCALL SUBOPT_0x0
; 0000 0038                 DR_CL = DR_OP = 0;
; 0000 0039 				delay_ms(DEL_ACTION);
; 0000 003A                 break;
	RJMP _0xD
; 0000 003B 				};
; 0000 003C 		  case key_bt_cl :
_0xF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14
; 0000 003D 				{
; 0000 003E 				if(SA == SA_OPEN)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x15
; 0000 003F                     {
; 0000 0040                         SA = SA_STOP;
	RCALL SUBOPT_0x0
; 0000 0041                         DR_CL = DR_OP = 0;
; 0000 0042                         delay_ms(DEL_ACTION);
; 0000 0043                     }
; 0000 0044                 else
	RJMP _0x1A
_0x15:
; 0000 0045                     {
; 0000 0046                         SA = SA_CLOSE;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0047                         DR_CL = 1;
	SBI  0x18,0
; 0000 0048 				        DR_OP = 0;
	CBI  0x18,1
; 0000 0049                     };
_0x1A:
; 0000 004A 				break;
	RJMP _0xD
; 0000 004B 				};
; 0000 004C 		  case key_bt_op :
_0x14:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD
; 0000 004D 				{
; 0000 004E 				if(SA == SA_CLOSE)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x20
; 0000 004F                     {
; 0000 0050                         SA = SA_STOP;
	RCALL SUBOPT_0x0
; 0000 0051                         DR_CL = DR_OP = 0;
; 0000 0052                         delay_ms(DEL_ACTION);
; 0000 0053                     }
; 0000 0054                 else
	RJMP _0x25
_0x20:
; 0000 0055                     {
; 0000 0056                         SA = SA_OPEN;
	LDI  R30,LOW(2)
	MOV  R4,R30
; 0000 0057                         DR_CL = 0;
	CBI  0x18,0
; 0000 0058 				        DR_OP = 1;
	SBI  0x18,1
; 0000 0059                     };
_0x25:
; 0000 005A 				break;
; 0000 005B 				};
; 0000 005C 		  };
_0xD:
; 0000 005D         if(sen_sn_cl)
	TST  R3
	BREQ _0x2A
; 0000 005E         {
; 0000 005F          if(SA == SA_CLOSE)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x2B
; 0000 0060             {
; 0000 0061                 SA = SA_STOP;
	RCALL SUBOPT_0x0
; 0000 0062                 DR_CL = DR_OP = 0;
; 0000 0063                 delay_ms(DEL_ACTION);
; 0000 0064             };
_0x2B:
; 0000 0065         };
_0x2A:
; 0000 0066         if(sen_sn_op)
	TST  R2
	BREQ _0x30
; 0000 0067         {
; 0000 0068          if(SA == SA_OPEN)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x31
; 0000 0069             {
; 0000 006A                 SA = SA_STOP;
	RCALL SUBOPT_0x0
; 0000 006B                 DR_CL = DR_OP = 0;
; 0000 006C                 delay_ms(DEL_ACTION);
; 0000 006D             };
_0x31:
; 0000 006E         };
_0x30:
; 0000 006F };
	RET
; .FEND
;
;void ReadSenCL(void)
; 0000 0072 {
_ReadSenCL:
; .FSTART _ReadSenCL
; 0000 0073     static unsigned int CountSen1;
; 0000 0074 
; 0000 0075     sen_sn_cl = key_none;
	CLR  R3
; 0000 0076 
; 0000 0077     if(SN_CL)
	SBIS 0x10,0
	RJMP _0x36
; 0000 0078      {
; 0000 0079       if(CountSen1 >= ONE_PRESS_SEN)
	LDS  R26,_CountSen1_S0000002000
	LDS  R27,_CountSen1_S0000002000+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x37
; 0000 007A       {
; 0000 007B          sen_sn_cl = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 007C          CountSen1 -= 10;
	LDS  R30,_CountSen1_S0000002000
	LDS  R31,_CountSen1_S0000002000+1
	SBIW R30,10
	STS  _CountSen1_S0000002000,R30
	STS  _CountSen1_S0000002000+1,R31
; 0000 007D          return;
	RET
; 0000 007E       }
; 0000 007F       else CountSen1++;
_0x37:
	LDI  R26,LOW(_CountSen1_S0000002000)
	RCALL SUBOPT_0x1
; 0000 0080       }
; 0000 0081      else CountSen1 = 0;
	RJMP _0x39
_0x36:
	LDI  R30,LOW(0)
	STS  _CountSen1_S0000002000,R30
	STS  _CountSen1_S0000002000+1,R30
; 0000 0082 };
_0x39:
	RET
; .FEND
;
;void ReadSenOP(void)
; 0000 0085 {
_ReadSenOP:
; .FSTART _ReadSenOP
; 0000 0086      static unsigned int CountSen2;
; 0000 0087 
; 0000 0088      sen_sn_op = key_none;
	CLR  R2
; 0000 0089 
; 0000 008A      if(SN_OP)
	SBIS 0x10,1
	RJMP _0x3A
; 0000 008B      {
; 0000 008C       if(CountSen2 >= ONE_PRESS_SEN)
	LDS  R26,_CountSen2_S0000003000
	LDS  R27,_CountSen2_S0000003000+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLO _0x3B
; 0000 008D       {
; 0000 008E          sen_sn_op = 1;
	LDI  R30,LOW(1)
	MOV  R2,R30
; 0000 008F          CountSen2 -= 10;
	LDS  R30,_CountSen2_S0000003000
	LDS  R31,_CountSen2_S0000003000+1
	SBIW R30,10
	STS  _CountSen2_S0000003000,R30
	STS  _CountSen2_S0000003000+1,R31
; 0000 0090          return;
	RET
; 0000 0091       }
; 0000 0092       else CountSen2++;
_0x3B:
	LDI  R26,LOW(_CountSen2_S0000003000)
	RCALL SUBOPT_0x1
; 0000 0093       }
; 0000 0094      else CountSen2 = 0;
	RJMP _0x3D
_0x3A:
	LDI  R30,LOW(0)
	STS  _CountSen2_S0000003000,R30
	STS  _CountSen2_S0000003000+1,R30
; 0000 0095 };
_0x3D:
	RET
; .FEND
;
;void ReadKey(void)
; 0000 0098 {
_ReadKey:
; .FSTART _ReadKey
; 0000 0099 	 static unsigned char key;
; 0000 009A 	 static unsigned int CountKey;
; 0000 009B 
; 0000 009C     PressedKey = key_none;
	CLR  R5
; 0000 009D     if(BT_ST == 1)key = key_bt_st;
	SBIS 0x10,3
	RJMP _0x3E
	LDI  R30,LOW(2)
	RJMP _0x49
; 0000 009E 	 else if(BT_CL == 0)key = key_bt_cl;
_0x3E:
	SBIC 0x10,2
	RJMP _0x40
	LDI  R30,LOW(1)
	RJMP _0x49
; 0000 009F 	 else if(BT_OP == 0)key = key_bt_op;
_0x40:
	SBIC 0x10,4
	RJMP _0x42
	LDI  R30,LOW(3)
	RJMP _0x49
; 0000 00A0 	 else key = key_none;
_0x42:
	LDI  R30,LOW(0)
_0x49:
	STS  _key_S0000004000,R30
; 0000 00A1 
; 0000 00A2 	 if(key)                                        // Если нажата клавиша, то считаем
	CPI  R30,0
	BREQ _0x44
; 0000 00A3 		  {                                          // до тех пор пока счетчик не сравняется
; 0000 00A4 		   if(CountKey == ONE_PRESS_KEY)                 // с ONE_PRESS.
	RCALL SUBOPT_0x2
	BRNE _0x45
; 0000 00A5          {
; 0000 00A6             PressedKey = key;
	LDS  R5,_key_S0000004000
; 0000 00A7             CountKey++;                            // Увеличиваем счетчик, чтобы больше сюда не заходить.
	LDI  R26,LOW(_CountKey_S0000004000)
	RCALL SUBOPT_0x1
; 0000 00A8             return;
	RET
; 0000 00A9          }
; 0000 00AA          else
_0x45:
; 0000 00AB          {
; 0000 00AC             if(CountKey < ONE_PRESS_KEY)CountKey++;     // Это позволяет считывать одно нажатие,
	RCALL SUBOPT_0x2
	BRSH _0x47
	LDI  R26,LOW(_CountKey_S0000004000)
	RCALL SUBOPT_0x1
; 0000 00AD          };                                         // не зависимо от времени удержания.
_0x47:
; 0000 00AE 		  }
; 0000 00AF 	 else CountKey = 0;                              // Обнуляем счетчик, если нажатие не уложилось во время ONE_PRESS.
	RJMP _0x48
_0x44:
	LDI  R30,LOW(0)
	STS  _CountKey_S0000004000,R30
	STS  _CountKey_S0000004000+1,R30
; 0000 00B0 };
_0x48:
	RET
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)  // 100Hz, 10ms
; 0000 00B4 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R30
; 0000 00B5 	 TCNT1H = 0x63C0 >> 8;
	RCALL SUBOPT_0x3
; 0000 00B6 	 TCNT1L = 0x63C0 & 0xff;
; 0000 00B7 };
	LD   R30,Y+
	RETI
; .FEND
;
;void InitMCU(void)
; 0000 00BA {
_InitMCU:
; .FSTART _InitMCU
; 0000 00BB 
; 0000 00BC 	 // Crystal Oscillator division factor: 1
; 0000 00BD #pragma optsize-
; 0000 00BE 	 CLKPR = (1 << CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00BF 	 CLKPR = (0 << CLKPCE) | (0 << CLKPS3) | (0 << CLKPS2) | (0 << CLKPS1) | (0 << CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00C0 	 #ifdef _OPTIMIZE_SIZE_
; 0000 00C1 #pragma optsize+
; 0000 00C2 	 #endif
; 0000 00C3 
; 0000 00C4 	 // Input/Output Ports initialization
; 0000 00C5 	 // Port A initialization
; 0000 00C6 	 // Function: Bit2=In Bit1=In Bit0=In
; 0000 00C7 	 DDRA = (0 << DDA2) | (0 << DDA1) | (0 << DDA0);
	OUT  0x1A,R30
; 0000 00C8 	 // State: Bit2=T Bit1=T Bit0=T
; 0000 00C9 	 PORTA = (0 << PORTA2) | (0 << PORTA1) | (0 << PORTA0);
	OUT  0x1B,R30
; 0000 00CA 
; 0000 00CB 	 // Port B initialization
; 0000 00CC 	 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=Out Bit0=Out
; 0000 00CD 	 DDRB = (0 << DDB7) | (0 << DDB6) | (0 << DDB5) | (0 << DDB4) | (0 << DDB3) | (0 << DDB2) | (1 << DDB1) | (1 << DDB0);
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 00CE 	 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=0 Bit0=0
; 0000 00CF 	 PORTB = (0 << PORTB7) | (0 << PORTB6) | (0 << PORTB5) | (0 << PORTB4) | (0 << PORTB3) | (0 << PORTB2) | (0 << PORTB1)  ...
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00D0 
; 0000 00D1 	 // Port D initialization
; 0000 00D2 	 // Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D3 	 DDRD = (0 << DDD6) | (0 << DDD5) | (0 << DDD4) | (0 << DDD3) | (0 << DDD2) | (0 << DDD1) | (0 << DDD0);
	OUT  0x11,R30
; 0000 00D4 	 // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00D5 	 PORTD = (0 << PORTD6) | (0 << PORTD5) | (0 << PORTD4) | (0 << PORTD3) | (0 << PORTD2) | (0 << PORTD1) | (0 << PORTD0);
	OUT  0x12,R30
; 0000 00D6 
; 0000 00D7 	 // Timer/Counter 0 initialization
; 0000 00D8 	 // Clock source: System Clock
; 0000 00D9 	 // Clock value: Timer 0 Stopped
; 0000 00DA 	 // Mode: Normal top=0xFF
; 0000 00DB 	 // OC0A output: Disconnected
; 0000 00DC 	 // OC0B output: Disconnected
; 0000 00DD 	 TCCR0A = (0 << COM0A1) | (0 << COM0A0) | (0 << COM0B1) | (0 << COM0B0) | (0 << WGM01) | (0 << WGM00);
	OUT  0x30,R30
; 0000 00DE 	 TCCR0B = (0 << WGM02) | (0 << CS02) | (0 << CS01) | (0 << CS00);
	OUT  0x33,R30
; 0000 00DF 	 TCNT0 = 0x00;
	OUT  0x32,R30
; 0000 00E0 	 OCR0A = 0x00;
	OUT  0x36,R30
; 0000 00E1 	 OCR0B = 0x00;
	OUT  0x3C,R30
; 0000 00E2 
; 0000 00E3 	 // Timer/Counter 1 initialization
; 0000 00E4 	 // Clock source: System Clock
; 0000 00E5 	 // Clock value: 4000,000 kHz
; 0000 00E6 	 // Mode: Normal top=0xFFFF
; 0000 00E7 	 // OC1A output: Disconnected
; 0000 00E8 	 // OC1B output: Disconnected
; 0000 00E9 	 // Noise Canceler: Off
; 0000 00EA 	 // Input Capture on Falling Edge
; 0000 00EB 	 // Timer Period: 10 ms
; 0000 00EC 	 // Timer1 Overflow Interrupt: On
; 0000 00ED 	 // Input Capture Interrupt: Off
; 0000 00EE 	 // Compare A Match Interrupt: Off
; 0000 00EF 	 // Compare B Match Interrupt: Off
; 0000 00F0 	 TCCR1A = (0 << COM1A1) | (0 << COM1A0) | (0 << COM1B1) | (0 << COM1B0) | (0 << WGM11) | (0 << WGM10);
	OUT  0x2F,R30
; 0000 00F1 	 TCCR1B = (0 << ICNC1) | (0 << ICES1) | (0 << WGM13) | (0 << WGM12) | (0 << CS12) | (0 << CS11) | (0 << CS10);
	OUT  0x2E,R30
; 0000 00F2 	 TCNT1H = 0x63;
	RCALL SUBOPT_0x3
; 0000 00F3 	 TCNT1L = 0xC0;
; 0000 00F4 	 ICR1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 00F5 	 ICR1L = 0x00;
	OUT  0x24,R30
; 0000 00F6 	 OCR1AH = 0x00;
	OUT  0x2B,R30
; 0000 00F7 	 OCR1AL = 0x00;
	OUT  0x2A,R30
; 0000 00F8 	 OCR1BH = 0x00;
	OUT  0x29,R30
; 0000 00F9 	 OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 00FA 
; 0000 00FB 	 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00FC 	 TIMSK = (1 << TOIE1) | (0 << OCIE1A) | (0 << OCIE1B) | (0 << ICIE1) | (0 << OCIE0B) | (0 << TOIE0) | (0 << OCIE0A);
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 00FD 
; 0000 00FE 	 // External Interrupt(s) initialization
; 0000 00FF 	 // INT0: Off
; 0000 0100 	 // INT1: Off
; 0000 0101 	 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0102 	 GIMSK = (0 << INT1) | (0 << INT0) | (0 << PCIE);
	LDI  R30,LOW(0)
	OUT  0x3B,R30
; 0000 0103 	 MCUCR = (0 << ISC11) | (0 << ISC10) | (0 << ISC01) | (0 << ISC00);
	OUT  0x35,R30
; 0000 0104 
; 0000 0105 	 // USI initialization
; 0000 0106 	 // Mode: Disabled
; 0000 0107 	 // Clock source: Register & Counter=no clk.
; 0000 0108 	 // USI Counter Overflow Interrupt: Off
; 0000 0109 	 USICR = (0 << USISIE) | (0 << USIOIE) | (0 << USIWM1) | (0 << USIWM0) | (0 << USICS1) | (0 << USICS0) | (0 << USICLK)  ...
	OUT  0xD,R30
; 0000 010A 
; 0000 010B 	 // USART initialization
; 0000 010C 	 // USART disabled
; 0000 010D 	 UCSRB = (0 << RXCIE) | (0 << TXCIE) | (0 << UDRIE) | (0 << RXEN) | (0 << TXEN) | (0 << UCSZ2) | (0 << RXB8) | (0 << TX ...
	OUT  0xA,R30
; 0000 010E 
; 0000 010F 	 // Analog Comparator initialization
; 0000 0110 	 // Analog Comparator: Off
; 0000 0111 	 // The Analog Comparator's positive input is
; 0000 0112 	 // connected to the AIN0 pin
; 0000 0113 	 // The Analog Comparator's negative input is
; 0000 0114 	 // connected to the AIN1 pin
; 0000 0115 	 ACSR = (1 << ACD) | (0 << ACBG) | (0 << ACO) | (0 << ACI) | (0 << ACIE) | (0 << ACIC) | (0 << ACIS1) | (0 << ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0116 	 // Digital input buffer on AIN0: On
; 0000 0117 	 // Digital input buffer on AIN1: On
; 0000 0118 	 DIDR = (0 << AIN0D) | (0 << AIN1D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0119 
; 0000 011A 
; 0000 011B 	 // Watchdog Timer initialization
; 0000 011C 	 // Watchdog Timer Prescaler: OSC/128k
; 0000 011D 	 // Watchdog timeout action: Reset
; 0000 011E #pragma optsize-
; 0000 011F #asm("wdr")
	WDR
; 0000 0120 	 WDTCR |= (1 << WDCE) | (1 << WDE);
	IN   R30,0x21
	ORI  R30,LOW(0x18)
	OUT  0x21,R30
; 0000 0121 	 WDTCR = (0 << WDIF) | (0 << WDIE) | (0 << WDP3) | (0 << WDCE) | (1 << WDE) | (1 << WDP2) | (1 << WDP1) | (0 << WDP0);
	LDI  R30,LOW(14)
	OUT  0x21,R30
; 0000 0122 	 #ifdef _OPTIMIZE_SIZE_
; 0000 0123 #pragma optsize+
; 0000 0124 	 #endif
; 0000 0125 };
	RET
; .FEND

	.DSEG
_CountSen1_S0000002000:
	.BYTE 0x2
_CountSen2_S0000003000:
	.BYTE 0x2
_key_S0000004000:
	.BYTE 0x1
_CountKey_S0000004000:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x0:
	CLR  R4
	CBI  0x18,1
	CBI  0x18,0
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDS  R26,_CountKey_S0000004000
	LDS  R27,_CountKey_S0000004000+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(99)
	OUT  0x2D,R30
	LDI  R30,LOW(192)
	OUT  0x2C,R30
	RET

;RUNTIME LIBRARY

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x3E8
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
