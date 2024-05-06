TITLE HANGMAN 

DATA SEGMENT
 LOGO DB 10,13
      DB  " 888",10,13
      DB  " 888",10,13
      DB  " 888",10,13
      DB  " 88888b.   8888b.  88888b.   .d88b.  88888b.d88b.   8888b.  88888b.",10,13
      DB  " 888  88b     '88b 888 '88b d88P'88b 888 '888 '88b     '88b 888 '88b",10,13
      DB  " 888  888 .d888888 888  888 888  888 888  888  888 .d888888 888  888",10,13
      DB  " 888  888 888  888 888  888 Y88b 888 888  888  888 888  888 888  888",10,13
      DB  " 888  888 'Y888888 888  888  'Y88888 888  888  888 'Y888888 888  888",10,13 
      DB  "                               888P",10,13
      DB  "                         Y8b d88P",10,13
      DB  "                           'Y88P'",10,13,"$"     
  
 DICTIONARY DB   "HELLO$ ","WORLD$ ","ABYSS$ ","ACROSS$","APPLE$ ","ART$   ","BASE$  ","BIRD$  ","PARROT$","BRAIN$ ","COLD$  ","CANDY$ ","ROBOT$ ","DANGER$","LAPTOP$","FARM$  ","FACT$  ","BREEZE$","GRASS$ ","HAIR$  "
 
 PLAY_WORD DW ?

 LETTER DB ? 
 
 LETTERS_COUNT DW 0
 WORD_LENGTH DB 0
 
 LETTERS_FOUND DW 0
 ERROR_COUNT DB 0
 MAX_ERRORS DB 0
 
 COLUMN DB 0
 ROW DB 0
 
 CURRENT_LETTER DB 0
 LETTER_BUFFER_INDEX DW 0
 WORD_BUFFER_INDEX DW 0
 
 LET_X_POS DB 200
 LET_Y_POS DB 200 
 
 UNDERSCORE_POS_X DB 55

 
 WORD_BUFFER DB 7 DUP(0)
 LETTER_BUFFER DB 14 DUP(0)
 PRINT_WORD DB 7 DUP(0)
  
 RULES DB 10,13,10,13,"RULES:",10,13,"1.GAME IS PLAYED ONLY WITH CAPITAL LETTERS",10,13,"2.FIND THE GUESS WORD TO WIN THE GAME",10,13,"3.MAKE 6 ERRORS TO LOSE",10,13,"PRESS S TO START",10,13,"$"
 LOSE_MSG DB "YOU LOST. THE HIDDEN WORD WAS: $"
 STATEMSG DB 10,13,"PRESS 'R' TO RESTART THE GAME, OTHERWISE PRESS 'E' TO EXIT GAME.",10,13,"$"
 WIN_MSG DB "CONGRATULATIONS! YOU WON THE GAME. DO YOU WISH TO PLAY AGAIN?$"
 BUFFER_MSG DB "AlREADY GIVEN LETTERS: ",10,13,"$"   
 DEBUG_MSG DB "DEBUG WORD: ",10,13,"$"
 
DATA ENDS

CODE SEGMENT
    START:
        MOV AX,DATA                               
        MOV DS,AX  
        LEA DX,LOGO
        MOV AH,09h
        INT 21H
        
        LEA DX,DEBUG_MSG
        MOV AH,09h
        INT 21H
        CALL GENERATE_WORD 
        
        CALL START_SCREEN 
        CALL SET_GRAPHICS
        CALL DRAW_HANG 
        CALL DRAW_WORD_LINES
    
     
    PLAY: 
       
       MOV MAX_ERRORS,7
       
       MOV SI,0
       
       MOV [LETTER_BUFFER_INDEX],SI
       
       NEWLETTER:
 
       MOV SI,[LETTER_BUFFER_INDEX]
       
       CALL USER_INPUT
       
       MOV DI,0 
       
       CALL DRAW_INPUT_LETTER
        
       SEARCH_CHAR:
       
       MOV AL,LETTER_BUFFER[SI]
       MOV AH,WORD_BUFFER[DI]
            
       CMP AL,AH
       JNE INC_DI
       
       MOV SI,[LETTER_BUFFER_INDEX]
       
       MOV WORD_BUFFER[DI],"#" ;REMOVE CURRENT LETTER FROM WORD_BUFFER SO THAT WE WONT CHECK IT AGAIN(REPLACE WITH #)
       
       MOV WORD_BUFFER_INDEX,DI
       
       JMP CONTINUE
        
       INC_DI:
       INC DI
  
       MOV AL,WORD_LENGTH
       MOV AH,0
       
       CMP DI,AX      
       JE DRAW_BODYPART
       JMP SEARCH_CHAR
       
       
       DRAW_BODYPART:
       
       MOV AH,0
       MOV AL,ERROR_COUNT
       
       INC AL
       MOV ERROR_COUNT,AL
       
       
       CMP AL,MAX_ERRORS
       JE LOSE
       
       CMP AL,1
       JE TAG_DRAW_HEAD
        
       CMP AL,2
       JE TAG_DRAW_TORSO
       
       CMP AL,3
       JE TAG_DRAW_L_ARM
       
       CMP AL,4
       JE TAG_DRAW_R_ARM
       
       CMP AL,5
       JE TAG_DRAW_L_LEG
       
       CMP AL,6
       JE TAG_DRAW_R_LEG
       
       
       TAG_DRAW_HEAD:
        CALL DRAW_HEAD
        JMP NEWLETTER
        
       TAG_DRAW_TORSO:
        CALL DRAW_TORSO
        JMP NEWLETTER
       
       TAG_DRAW_L_ARM:
        CALL DRAW_L_ARM
        JMP NEWLETTER
       
       TAG_DRAW_R_ARM:
        CALL DRAW_R_ARM
        JMP NEWLETTER
       
       TAG_DRAW_L_LEG:
        CALL DRAW_L_LEG
        JMP NEWLETTER
       
       TAG_DRAW_R_LEG:
        CALL DRAW_R_LEG
        JMP NEWLETTER
      
      CONTINUE:
        
        CALL DRAW_LETTER
        
        ADD LETTERS_FOUND,1
        
        MOV AX,LETTERS_FOUND
        
        CMP WORD_LENGTH,AL
        JE WIN
        
        JMP NEWLETTER
 
      
      LOSE:
        
        MOV AH,0H
        MOV AL,3H
        INT 10H
        
        LEA DX,LOSE_MSG
        MOV AH,09
        INT 21H
        
        MOV SI,0
        
        LEA DX,PRINT_WORD
        MOV AH,09
        INT 21H
        
        LEA DX,STATEMSG
        MOV AH,09
        INT 21H
        
        AGAIN_LETTER_LOSE:
        
        MOV AH,07
        INT 21H
        
        CMP AL,'R'
        JE REPLAY
        
        CMP AL,'E'
        JE EXIT_PROGRAM
        JMP AGAIN_LETTER_LOSE
        
      WIN:
        
        MOV AH,0H
        MOV AL,3H
        INT 10H
        
        LEA DX,WIN_MSG
        MOV AH,09
        INT 21H
        
        LEA DX,STATEMSG
        MOV AH,09
        INT 21H
        
        
        AGAIN_LETTER_WIN:
        
        MOV AH,07
        INT 21H
        
        
        CMP AL,'R'
        JE REPLAY
        
        CMP AL,'E'
        JE EXIT_PROGRAM
        JMP AGAIN_LETTER_WIN
        
    ;DEN DOYLEYEI. PREPEI NA BROUME TO PWS THA KANOYME RESET TO GAME.
    REPLAY:
    
        MOV AX,0
        MOV BX,0
        MOV DX,0
        MOV DI,0
        
        MOV LETTERS_COUNT,AX
        MOV WORD_LENGTH,AL
        MOV LETTERS_FOUND,AX
        MOV ERROR_COUNT,AL
        MOV CURRENT_LETTER,AL
        MOV LETTER_BUFFER_INDEX,AX
        MOV WORD_BUFFER_INDEX,AX
        MOV COLUMN,AL
        MOV ROW,AL
        
        MOV AL,55
        MOV UNDERSCORE_POS_X,AL
        MOV AL,0
        
        MOV CX,7
        MOV SI,0
        
        SLOOP1:
           
           MOV WORD_BUFFER[SI],0
           MOV PRINT_WORD[SI],0
           INC SI
           
        LOOP SLOOP1
        
        
        MOV CX,14
        MOV SI,0
        
        SLOOP2:
               
           MOV LETTER_BUFFER[SI],0
           INC SI
        LOOP SLOOP2
        
        MOV CX,0
        MOV SI,0
        
        JMP START    
          
    EXIT_PROGRAM:
        MOV AH,4CH
        INT 21H  
     
;-----------------------------------------------------------------------
;MPAINEI SE LEITOURGIA GRAFIKON
SET_GRAPHICS PROC 
 PUSH AX
   
 MOV AL,13H
 MOV AH,0 
 INT 10H
  
 POP AX 
 RET
SET_GRAPHICS ENDP

DRAW_HANG PROC
 PUSH CX
 PUSH DX
 PUSH AX 
 
 
 MOV CX,5
 MOV DX,10
 
 AGAIN_X:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CX 
    CMP CX,70
 JNZ AGAIN_X
 
 AGAIN_y:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC DX 
    CMP DX,20
 JNZ AGAIN_Y 
 
 MOV CX,5
 MOV DX,10
 
 POLE:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC DX 
    CMP DX,150 
 JNZ POLE
 
 POP AX 
 POP DX  
 POP CX 
 RET
DRAW_HANG ENDP

;Sxediazei ena tetrapleuro gia kefali
;Arxika sxediazei mia grammi apo pixel
;Ayksanei thn metatopisi y kata 1 kai sxediazei ki alles grammes mexri na bgei ena sxima
DRAW_HEAD PROC 
 PUSH CX 
 PUSH DX 
 PUSH AX 
 
 MOV CX,60 ;Arxiko offset 
 MOV DX,20 ;Arxiko offset
 MOV AH,0CH 
 MOV AL,3
 HEAD:     
    INT 10H
    INC CX 
    CMP CX,80
 JNZ HEAD
    
    MOV CX,60 ; midenizei to offset tou x
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC DX 
    CMP DX,30
 JNZ HEAD
 
 
 POP AX
 POP DX 
 POP CX 
 RET    
    
DRAW_HEAD ENDP

DRAW_TORSO PROC
 PUSH CX 
 PUSH DX 
 PUSH AX 
 PUSH BX
 
 MOV CX,70 ;Arxiko offset 
 MOV DX,30
 
 TORSO:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC DX 
    CMP DX,70
 JNZ TORSO 
 
 POP BX 
 POP AX 
 POP DX 
 POP CX 
 RET  
DRAW_TORSO ENDP 

DRAW_L_ARM PROC
 PUSH CX
 PUSH DX
 PUSH AX
 PUSH BX
 
 MOV CX,40 ;Arxiko offset 
 MOV DX,50
 
 L_ARM:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CX 
    CMP CX,70
 JNZ L_ARM 
 
 POP BX
 POP AX
 POP DX
 POP CX
 RET  
DRAW_L_ARM ENDP   

DRAW_R_ARM PROC
 PUSH  CX 
 PUSH  DX
 PUSH  AX 
 PUSH  BX 
 
 MOV CX,70 ;Arxiko offset 
 MOV DX,50
 
 R_ARM:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CX 
    CMP CX,100
 JNZ R_ARM 
 
 POP BX  
 POP AX 
 POP DX 
 POP CX
 RET  
DRAW_R_ARM ENDP

DRAW_L_LEG PROC
 PUSH CX 
 PUSH DX 
 PUSH AX 
 
 MOV CX,40 ;Arxiko offset 
 MOV DX,100
 
 L_LEG:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CX
    DEC DX 
    CMP CX,70
 JNZ L_LEG 
  
 POP AX 
 POP DX 
 POP CX 
 RET  
DRAW_L_LEG ENDP

DRAW_R_LEG PROC
 PUSH CX 
 PUSH DX
 PUSH AX 
 PUSH BX
 
 MOV CX,70 ;Arxiko offset 
 MOV DX,70
 
 R_LEG:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CX
    INC DX 
    CMP CX,100
 JNZ R_LEG 
 
 POP BX 
 POP AX 
 POP DX 
 POP CX 
 RET  
DRAW_R_LEG ENDP 
  
DRAW_UNDERSCORE PROC 
 PUSH CX 
 PUSH DX 
 PUSH BX 
 PUSH AX  
 
 MOV CL,UNDERSCORE_POS_X ;Arxiko offset 
 MOV DX,150
 MOV BL,UNDERSCORE_POS_X
 ADD BL,10
 
 UNDERSCORE:
    MOV AH,0CH
    MOV AL,3
    INT 10H
    INC CL 
    CMP CL,BL
 JNE UNDERSCORE
 
 MOV UNDERSCORE_POS_X,CL  
 
 POP AX 
 POP BX 
 POP DX 
 POP CX  
 RET    
DRAW_UNDERSCORE ENDP 

DRAW_WORD_LINES  PROC
 PUSH BX  
 
 MOV BH,WORD_LENGTH 
 LINE_ITERATE:
    CALL DRAW_UNDERSCORE
    DEC BH
    MOV BL,UNDERSCORE_POS_X
    ADD BL,5
    MOV UNDERSCORE_POS_X,BL   
 CMP BH,0
 JNE LINE_ITERATE 
 
 POP BX  
 RET    
DRAW_WORD_LINES ENDP

DRAW_LETTER PROC
    PUSH BX
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    
    MOV AL,2
    MUL WORD_BUFFER_INDEX
    
    MOV DL,7
    ADD DL,AL
    
    MOV DH,17
    
    MOV BH,0
    MOV AH,02H
    INT 10H
    
    MOV AL,CURRENT_LETTER
    
    MOV BL,0CH
    MOV BH,0
    
    MOV AH,0EH
    INT 10H
    
    POP DX
    POP CX
    POP SI
    POP AX
    POP BX
    RET
 DRAW_LETTER ENDP

DRAW_INPUT_LETTER PROC
    PUSH AX
    PUSH SI
    PUSH CX
    PUSH DX
    PUSH BX
    
    MOV AX,SI
    MOV CL,5
    
    DIV CL
    
    CMP AL,0
    JE PRINT
        
    CMP AH,0
    JE CHANGE_R_C_OFFSET
    JMP PRINT
        
    CHANGE_R_C_OFFSET:
    
    ADD ROW,2
    MOV DX,0
    MOV COLUMN,DL
    
    
    PRINT:
    
    MOV DL,30
    ADD DL,COLUMN
    
    MOV DH,3
    ADD DH,ROW
    MOV AH,02H
    INT 10H
    
    MOV AL,LETTER_BUFFER[SI]
    
    MOV BH,0
    MOV BH,0
    
    MOV AH,0EH
    INT 10H
    
    MOV DL,30
    ADD DL,COLUMN
    ADD DL,1
    
    MOV DH,3
    ADD DH,ROW
    MOV AH,02
    INT 10H
    
    MOV AL,2CH
    
    MOV BH,0
    MOV AH,0EH
    INT 10H
    
    ADD COLUMN,2
    
    
    POP BX
    POP DX
    POP CX
    POP SI
    POP AX
    RET
    
 DRAW_INPUT_LETTER ENDP
        
;--------------------------------------------------------------   

GENERATE_WORD PROC
 PUSH AX 
 PUSH DX 
 PUSH BX 
 PUSH SI 
 PUSH DI 
 
 
 MOV AH,00H
 INT 1AH ;CX:DX  EXEI TA CLOCKS APO TA MESANIXTA OS TORA  
    
 MOV AX,DX
 XOR DX,DX  ;MIDENIZEI TON DX 
    
 MOV CX,20  ;BAZEI STON CX TO MEGETHOS TOU LEKSILOGIOU 
 DIV CX     ;DIAIREI ME TON CX TO APOTELESMA APOTHIKEUETAI STON AX  KAI TO UPOLOIPO TIS DIAIRESIS STO DX 
                                                                  
 MOV AX,DX  ;METAKINOUME TO UPOLOIPO (TIXAIO ARITHMO APO TO DX STO AX)
    
 MOV BX,07H ;METAFEREI STON BX THN TIMH 7
 MUL BX     ;POLLAPLASIAZEI  TON AX ME TO 7 TO APOTELESMA APOTHIKEUETAI STON AX AUTO THA EINAI TO INDEX TIS TIXAIAS LEKSIS 
    
 MOV SI,AX  
     
 MOV DI,OFFSET DICTIONARY    ;DINOUME TO OFFSET TOU DICTIONARY STON DI 
 ADD DI,SI                   ;METAKINOUME TON DI KATA SI BIT  ARA STO "INDEX" TIS TIXAIAS LEKSIS
 
 CALL GETLENGTH
 
 POP DI
 POP SI 
 POP BX 
 POP DX 
 POP AX  
 RET    
GENERATE_WORD ENDP

USER_INPUT PROC
 PUSH AX
 PUSH DX
 PUSH CX 
 PUSH SI 
 PUSH DI
 
 AGAIN:
    MOV AH,07
    INT 21H

 CMP AL,'A'
 JB AGAIN

 CMP AL,'z'
 JA AGAIN

 CMP AL,'Z'
 JBE CONT1

 CMP AL,'a'
 JAE TO_UPPERCASE
 
 ;ADD AL,30H
 
 JMP AGAIN
 
 TO_UPPERCASE:
 
    SUB AL,32
 
 CONT1:
 
 INC SI
 MOV [LETTER_BUFFER_INDEX],SI
 DEC SI
 
 MOV CURRENT_LETTER,AL
  
  ;H SYNARTHSH LETTER CHECK ELEGXEI AN O USER EXEI KSANADWSEI TO IDIO GRAMMA KAI TON KSANASTELNEI PANW
  ;NA DWSEI KAINOYRIO AMA ISXYEI. MPOREI NA MHN XREIASTEI STON KWDIKA, OPOTE MENEI SE COMMENTS PROS TO PARON
  LETTER_CHECK:
   
   ;MOV DI,0
 
   ;CMP LETTER_BUFFER[DI],AL
   ;JE AGAIN
   
   ;CMP DI,SI
   ;JE CONT
   
   ;INC DI
   ;JMP LETTER_CHECK

 CONT: 
 
 MOV LETTER_BUFFER[SI], AL
 
 POP DI 
 POP SI
 POP CX
 POP DX 
 POP AX
 RET
 USER_INPUT ENDP

START_SCREEN PROC
 PUSH DX 
 PUSH AX 

 LEA DX,RULES
 MOV AH,09H
 INT 21H

 NOT_START: 
    MOV AH,07
    INT 21H
    CMP AL,'s'
    JE START_G
    CMP AL,'S'
 JNE NOT_START

 START_G:
 POP AX 
 POP DX 
 RET
START_SCREEN ENDP  

PRINT_BUFFER PROC 
 PUSH AX 
 PUSH BX 
 PUSH DX 
 PUSH SI 
 PUSH CX 

 PRINT_BUF:
    ;MOV DL,[SI] 
    MOV AH,0CH
    MOV AL,[si]
    MOV BH,0
    MOV BL,3
    MOV DH,LET_Y_POS
    MOV DL,LET_X_POS

    ADD LET_X_POS,10

    CMP LET_X_POS,200
    JB NEXT_LETTER

    MOV LET_X_POS,130
    ADD LET_Y_POS,20

    NEXT_LETTER:
        INC SI
        INC CX
        CMP CX,LETTERS_COUNT
    JBE PRINT_BUF
    INT 10h


 POP CX 
 POP SI 
 POP DX 
 POP BX 
 POP AX 
 RET
PRINT_BUFFER ENDP

GETLENGTH PROC 
    PUSH CX 
    PUSH SI 
    PUSH AX 
    PUSH DI 
    PUSH DX 
    
   
    XOR CL,CL ;LEITOURGEI SAN COUNTER   
    XOR SI,SI ;KATHARIZEI TON KATAXORITI 
    ITERATE:   
        MOV AL,BYTE [DI]
        
        MOV WORD_BUFFER[SI],AL
        MOV PRINT_WORD[SI],AL
                
        CMP byte [di],'$'  ;kanei compare to byte pou deixnei o si me to $ 
        JE FOUNDLENGTH  
        
        INC CL
        INC DI 
        INC SI 
    JMP ITERATE
    
    FOUNDLENGTH:   
        
        LEA DX,WORD_BUFFER 
        MOV AH,09 
        INT 21H
        MOV WORD_LENGTH,CL
    
    
    
    POP DX 
    POP DI 
    POP AX 
    POP SI 
    POP CX
    RET
GETLENGTH ENDP

CODE ENDS 

STACK SEGMENT
  DB 256 DUP(0)
STACK ENDS 

END START