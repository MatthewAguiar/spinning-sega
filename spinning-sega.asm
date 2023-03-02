; ------------------------------------------------------------------------------
;
; 	Title:			spinning-sega.asm
; 	Date:			February 25, 2023
;
; 	Author:			Matthew Aguiar
;
;	Description: 	Spins the Sonic 2 SEGA Logo.
;
; -------------------------------------------------------------------------------

;-------------------------------------------------------------
; ROM HEADER - EXCEPTION HANDLERS
; -------------------------------------------------------------
HEADER:					DC.L   $00FFFFFC        				;INITIAL STACK POINTER POSITION
						DC.L   START      						;START OF THE PROGRAM
						DC.L   IGNORE_HANDLER   				;BUS ERROR
						DC.L   IGNORE_HANDLER   				;ADDRESS ERROR
						DC.L   IGNORE_HANDLER   				;ILLEGAL INSTRUCTION
						DC.L   IGNORE_HANDLER   				;DIVISION BY ZERO
						DC.L   IGNORE_HANDLER   				;CHK EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAPV EXCEPTION
						DC.L   IGNORE_HANDLER   				;PRIVILEDGE EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRACE EXCEPTION
						DC.L   IGNORE_HANDLER   				;LINE-A EMULATOR
						DC.L   IGNORE_HANDLER   				;LINE-F EMULATOR
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;SPURIOUS EXCEPTION
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 1
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 2
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 3
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 4 (HORIZONTAL RETRACE INT.)
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 5
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 6 (VERTICAL RETRACE INT.)
						DC.L   IGNORE_HANDLER   				;IRQ LEVEL 7
						DC.L   IGNORE_HANDLER   				;TRAP #00 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #01 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #02 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #03 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #04 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #05 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #06 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #07 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #08 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #09 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #10 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #11 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #12 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #13 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #14 EXCEPTION
						DC.L   IGNORE_HANDLER   				;TRAP #15 EXCEPTION
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						DC.L   IGNORE_HANDLER   				;UNUSED (RESERVED)
						
; -------------------------------------------------------------
; ROM HEADER - GAME INFORMATION
; -------------------------------------------------------------
						DC.B "SEGA GENESIS    " 				;CONSOLE NAME
						DC.B "AGMAT 2020.AUG  " 				;COPYRIGHT HOLDER
						DC.B "SPINNING SEGA                                   " ;DOMESTIC NAME
						DC.B "SPINNING SEGA                                   " ;INTERNATIONAL NAME
						DC.B "AL 00000000-01  " 				;VERSION NUMBER
						DC.W $0000              				;CHECKSUM
						DC.B "J               " 				;I/O SUPPORT
						DC.L $00000000          				;START ADDRESS OF ROM
						DC.L END              					;END ADDRESS OF ROM
						DC.L $00FF0000          				;START ADDRESS OF RAM
						DC.L $00FFFFFF          				;END ADDRESS OF RAM
						DC.L $00000000          				;SRAM ENABLED
						DC.L $00000000          				;UNUSED
						DC.L $00000000          				;START ADDRESS OF SRAM
						DC.L $00000000          				;END ADDRESS OF SRAM
						DC.L $00000000          				;UNUSED
						DC.L $00000000          				;UNUSED
						DC.B "                " 				;NOTES
						DC.B "JUE             " 				;COUNTRY CODES
						
; -------------------------------------------------------------
; CONSTANTS AND GLOBAL VARIABLES
; -------------------------------------------------------------
VDP_CONTROL:			EQU		$00C00004 						;VDP CONTROL ADDRESS
VDP_DATA:				EQU 	$00C00000 						;VDP DATA ADDRESS
VERSION:				EQU 	$00A10001						;ADDRESS OF GENESIS VERSION
TMSS:					EQU		$00A14000						;ADDRESS OF TMSS SIGNATURE
Z80BUS:					EQU		$00A11100						;ADDRESS FOR REQUESTING ACCESS TO Z80 BUS
Z80RESET:				EQU 	$00A11200						;ADDRESS FOR RESETING Z80
Z80_ADDR_SPACE:			EQU		$00A00000						;Z80 ADDRESSING SPACE
VDP_REG_BASE:			EQU		$00008000						;THE BASE ADDRESS OF THE VDP

; -------------------------------------------------------------
; COLOR PALETTES
; -------------------------------------------------------------
PALETTE0:				DC.W	$0000 ;BLACK
						DC.W	$0EEE ;WHITE
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK
						DC.W	$0000 ;BLACK


; -------------------------------------------------------------
; HARDWARE INITIALIZATION
; -------------------------------------------------------------
START:					MOVE.W 	#$2700,SR     					;DISABLE INTURUPTS
						MOVEA.L	SP,A6							;SET BASE POINTER TO SAME A STACK POINTER
; --- TMSS ----------------------------------------------------
						MOVE.B 	VERSION,D0  					;MOVE GENESIS HARDWARE VERSION TO D0 (***TAKE A LOOK AT THIS***)
						ANDI.B 	#$0F,D0       					;MASK OFF THE VERSION WHICH IS STORED IN THE LOWER 4 BITS
						BEQ     SKIP_TMSS      	 				;IF THE VERSION IS 0, SKIP THE TMSS SIGNATURE
						MOVE.L  #'SEGA',TMSS					;OTHERWISE, MOVE STRING "SEGA" TO $A14000
; --- Z80 INIT ------------------------------------------------
SKIP_TMSS:				MOVE.W  #$0100,Z80BUS 					;REQUEST ACCESS TO Z80 BUS
						MOVE.W  #$0100,Z80RESET					;HOLD Z80 IN A RESET STATE
Z80WAIT:				BTST    #$0,Z80BUS+1   					;CHECK IF WE HAVE ACCESS TO Z80 BUS YET
						BNE     Z80WAIT         				;WAIT FOR BUS TO GRANT ACCESS
						MOVEA.L #Z80_ADDR_SPACE,A1 				;COPY Z80 RAM ADDRESS TO A1
						MOVE.L  #$00C30000,(A1) 				;COPY DATA AND INCREMENT A1
						MOVE.W  #$0000,Z80RESET 				;RELEASE RESET STATE
						MOVE.W  #$0000,Z80BUS 					;RELEASE CONTROL OF BUS
; --- VDP INIT ------------------------------------------------
						MOVEA.L #VDP_REGISTERS,A0 				;LOAD THE ADDRESS OF THE FIRST VDP REGISTER
						MOVEQ.L #$18,D0         				;24 REGISTERS TO INITIALIZE USED IN LOOP BELOW
						MOVE.L  #VDP_REG_BASE,D1 				;PUT REFERENCE TO VDP REGISTER 0 IN D1
VDP_INIT:				MOVE.B  (A0)+,D1        				;COPY REGISTER VALUES TO D1
						MOVE.W  D1,VDP_CONTROL  				;INIT REGISTER
						ADDI.W  #$0100,D1       				;INCREMENT REGISTER NUMBER
						DBRA    D0,VDP_INIT						;LOOP THROUGH ALL REGISTERS
; --- CLEAR VRAM (REMOVE LISENCING SCREEN) --------------------
						MOVE.L	#$40000000,VDP_CONTROL 			;SET VDP TO VRAM WRITE
						MOVE.L	#$00007FFF,D0					;USE D0 AS INDEX VARIABLE
VRAM_CLEAR:				MOVE.W	#0,VDP_DATA						;WRITE 0 TO CURRENT VRAM ADDRESS
						DBRA	D0,VRAM_CLEAR					;LOOP UNTIL ALL 64K OF MEMORY IS CLEARED


; -------------------------------------------------------------
; GAME CODE
; -------------------------------------------------------------
MAIN:					LEA		VDP_CONTROL,A0					;A0 = VDP_CONTROL PORT
						LEA		VDP_DATA,A1						;A1 = VDP_DATA PORT
						MOVE.W	#$8134,(A0)						;DISABLE DISPLAY TO TRANSFER GRAPHICS DATA QUICKLY

						MOVEQ.L	#15,D0							;16 WORDS TO WRITE
						LEA		SEGA_PALETTE,A2					;PALETTE DATA AT A2
						MOVE.L	#$C0000000,(A0)					;TELL VDP TO WRITE TO CRAM
WRITE_PALETTE:			MOVE.W	(A2)+,(A1)						;TRANSFER COLOR TO CRAM
						DBRA	D0,WRITE_PALETTE				;LOOP THROUGH COLORS
						
						MOVE.W	#((SEGA_PALETTE-SEGA_LOGO)/2)-1,D0	;NUMBER OF TILES, IN WORDS - 1, TO TRANSFER
						LEA		SEGA_LOGO,A2					;LOAD POINTER TO SEGA LOGO TILES
						MOVE.L	#$40000000,(A0)					;TELL VDP TO WRITE TO VRAM
WRITE_LOGO:				MOVE.W	(A2)+,(A1)						;WRITE TILE DATA TO VRAM
						DBRA	D0,WRITE_LOGO
						
						MOVE.L	#($2000/2)-1,D0					;D0 = NUMBER OF WORDS TO WRITE TO PLANE A MAP
						MOVE.L	#$60000002,(A0)					;TELL VDP TO WRITE TO VRAM PLANE A
						LEA		SEGA_TILEMAP,A2					;A2 = ADDRESS OF SEGA TILEMAP
WRITE_PLANEA:			MOVE.W	(A2)+,(A1)						;MOVE TILEMAP INFO TO PLANE A
						DBRA	D0,WRITE_PLANEA					;KEEP WRITING TO PLANE A
						
						MOVE.W	#$8174,(A0)						;DISABLE DISPLAY TO TRANSFER GRAPHICS DATA QUICKLY
						
						
; --- HOLD GAME IN AN IDLE STATE ------------------------------
GAME_LOOP:				BRA		GAME_LOOP						;CONTINUE IN ENDLESS LOOP

						
; -------------------------------------------------------------
; EXCEPTION AND INTERRUPT HANDLERS
; -------------------------------------------------------------
; -------------------------------------------------------------		
; --- IGNORE HANDLER ------------------------------------------
						align 2 								;WORD ALIGN
IGNORE_HANDLER:			RTE 									;RETURN FROM EXCEPTION


; -------------------------------------------------------------
; GRAPHICS DATA
; -------------------------------------------------------------
SEGA_LOGO:				incbin "sega-logo.bin"					;SEGA LOGO TILES
SEGA_PALETTE:			incbin "sega-palette.bin"				;SEGA PALETTE
SEGA_TILEMAP:			incbin "sega-tilemap.bin"				;SEGA TILEMAP
					

; -------------------------------------------------------------
; VDP REGISTERS
; -------------------------------------------------------------
						align 2									;WORD ALIGN
VDP_REGISTERS:
VDP_REG0:   			DC.B $14 								;0:  H INTURRUPT ON PALETTES ON
VDP_REG1:   			DC.B $74 								;1:  V INTURRUPT ON PALETTES ON
VDP_REG2:   			DC.B $28 								;2:  PATTERN TABLE FOR SCROLL PLANE A AT VRAM ADDRESS $A000
VDP_REG3:   			DC.B $3E 								;3:  PATTERN TABLE FOR WINDOW PLANE AT VRAM ADDRESS $F000
VDP_REG4:   			DC.B $07 								;4:  PATTERN TABLE FOR SCROLL PLANE B AT VRAM ADDRESS $E000
VDP_REG5:   			DC.B $6C 								;5:  SPRITE TABLE AT VRAM $D800
VDP_REG6:   			DC.B $00 								;6:  UNUSED
VDP_REG7:   			DC.B $00 								;7:  BACKGROUND COLOR
VDP_REG8:   			DC.B $00 								;8:  UNUSED
VDP_REG9:   			DC.B $00 								;9:  UNUSED
VDP_REGA:   			DC.B $FF 								;10: FREQUENXY OF HORIZONTAL INTERRUPT IN RASTERS
VDP_REGB:   			DC.B $00 								;11: EXTERNAL INTERRUPTS
VDP_REGC:   			DC.B $81 								;12: SHADOWS AND HIGHLIGHTS OFF, INTERLACE OFF, H40 MODE (320 X 224)
VDP_REGD:   			DC.B $3F 								;13: HORIZONTAL SCROLL TABLE AT VRAM ADDRESS $FC00
VDP_REGE:   			DC.B $00 								;14: UNUSED
VDP_REGF:   			DC.B $02 								;15: AUTOINCREMENT 2-BYTES
VDP_REG10:  			DC.B $03 								;16: VERTICAL SCROLL 32, HORIZONTAL SCROLL 64
VDP_REG11:  			DC.B $00 								;17: WINDOW PLANE X POS - LEFT
VDP_REG12:  			DC.B $00 								;18: WINDOW PLANE Y POS 0 UP
VDP_REG13:  			DC.B $FF 								;19: DMA LENGTH LOW BYTE
VDP_REG14:  			DC.B $FF 								;20: DMA LENGTH HIGH BYTE
VDP_REG15:  			DC.B $00 								;21: DMA SOURCE ADDRESS LOW BYTE
VDP_REG16:  			DC.B $00 								;22: DMA SOURCE ADDRESS MID BYTE
VDP_REG17:  			DC.B $80 								;23: DMA SOURCE ADDRESS HIGH BYTE
END: