section .data               

section .text            


;Subbrutines d'assemblador que es diuen des de C.
global posCurScreen, getMove, showBoard
global moveCursor, moveCursorContinuo, moveTile


;Variables definidas en C.
extern puzzle, RowScreenIni, ColScreenIni 
extern row, col, colCursor, rowScreen, colScreen
extern indexMat, rowEmpty, colEmpty, carac, carac2, tecla
 
;Funcions de C que es diuen des d'assemblador.
extern gotoxy_C, getch_C, printch_C



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓ: Recordeu que en assemblador les variables i els paràmetres
;; de tipus 'char' s'han d'assignar a registres de tipus
;; BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;; les de tipus 'short' s'han d'assignar a registres de tipus
;; WORD (2 bytes): ax, bx, cx, dx, si, digues, ...., r15w
;; les de tipus 'int' s'han d'assignar a registres de tipus
;; DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;; les de tipus 'long' s'han d'assignar a registres de tipus
;; QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutines en assemblador que cal modificar són:
;; postCurScreen, showDigits, updateBoard,
;; moveCursor, openCard.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR.
; Situar el cursor a una fila i una columna de la pantalla
; en funció de la fila (edi) i de la columna (esi) rebuts com
; paràmetre trucant a la funció gotoxyP2_C.
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada:
; (rowScreen): rdi(edi): Fila
; (colScreen): rsi(esi): Columna;
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;
gotoxy:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Quan cridem la funció gotoxyP2_C(int rowScreen, int colScreen)
   ; des d'assemblador el primer paràmetre (rowScreen) s'ha de
   ; passar pel registre rdi(edi), i el segon paràmetre (colScreen)
   ; cal passar pel registre rsi(esi).
   mov esi, DWORD[colScreen]
   mov edi, DWORD[rowScreen]
   call gotoxy_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR.
; Mostrar un caràcter (dil) a la pantalla, rebut com a paràmetre,
; a la posició on està el cursor cridant a la funció printch_C.
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada:
; rdi(dil): registre on enmagatzamem el caràcter que volem mostrar
; carac: caracter que volem mostrar
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   ; Quan cridem a la funció printchP2_C(char c) des d'assemblador,
   ; el paràmetre (c) s'ha de passar pel registre rdi(dil).
   mov dil,[carac]
   call printch_C
 
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR.
; Llegir una tecla i retornar el caràcter associat (al) sense
; mostrar-ho en pantalla, crida a la funció getch_C
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada:
; Cap
;
; Paràmetres de sortida:
; (c): rax(al): caràcter que llegim de teclat i es guarda a charac2
; tecla : variable que conté el caracter que s'ha capturat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;
getch:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   mov rax, 0
   ; cridem a la funció getchP2_C(char c) des d'assemblador,
   ; retorna sobre el registre rax(al) el caràcter llegit.
   call getch_C
   ; Al guardem a la variable tecla
   mov BYTE[tecla], al
   
  
   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   
   mov rsp, rbp
   pop rbp
   ret 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la pantalla, dins el tauler, en funció de
; les variables (row) fila (int) i (col) columna (char), a partir dels
; valors de les constants RowScreenIni i ColScreenIni.
; Primer cal convertir el char de la columna (A..D) a un número
; entre 0 i 3, i el int de la fila (1..4) a un número entre 0 i 3.
; Per calcular la posició del cursor a pantalla (rowScreen) i 
; (colScreen) utilitzar aquestes fórmules:
; rowScreen=rowScreenIni+(row*2)
; colScreen=colScreenIni+(col*4)
; Per a posicionar el cursor cridar a la subrutina gotoxy.
;
; Variables utilitzades:	
;	row       : fila per a accedir a la matriu sea
;	col       : columna per a accedir a la matriu sea
;	rowScreen : fila on volem posicionar el cursor a la pantalla.
;	colScreen : columna on volem posicionar el cursor a la pantalla.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
posCurScreen:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne
   push RAX
   push RBX

	mov EAX, [row]
	dec EAX
	mov EBX, 0
	mov BL, [col]
	sub BL, 'A'

	shl EAX, 1
	add EAX, [RowScreenIni]
	mov [rowScreen], EAX

	shl EBX, 2
	add EBX, [ColScreenIni]
	mov [colScreen], EBX
	CALL gotoxy

   pop rbx
   pop rax
   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un caràcter de teclat   
; cridant a la subrutina getch
; Verificar que solament es pot introduir valors entre 'i' i 'l', 
; o les tecles espai 'm' o 's'.
; 
; Variables utilitzades: 
;	tecla : Variable on s'emmagatzema el caràcter llegit
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getMove:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne

   bucle:	
   call getch
	cmp byte [tecla], 'm'
	je fiCo
	cmp byte [tecla], 's'
	je fiCo
	cmp byte [tecla], 'o'
	je fiCo
	cmp byte [tecla], ' '
	je fiCo
	cmp byte [tecla], 'i'
	jl bucle
	cmp byte [tecla], 'l'
	jg bucle
   fiCo:

   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calcular l'índex per a accedir a les matrius en assemblador.
; puzzle[row][col] en C, és [puzzle+indexMat] en assemblador.
; on indexMat = row*4 + col (col convertir a número).
;
; Variables utilitzades:	
;	row       : fila per a accedir a la matriu puzzle
;	col       : columna per a accedir a la matriu puzzle
;	indexMat  : índex per a accedir a la matriu puzzle
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex:
   push rbp
   mov rbp, rsp
   ;inici codi alumne

   dec dword [row] 
   sub byte [col], 'A'

   mov edx, dword [row]
   shl edx, 2
   add dl, byte [col]
   mov dword [indexMat], edx 

   inc dword [row]
   add byte [col], 'A'

   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Actualitzar les variables (row) i (col) en funció de 
; la tecla premuda que tenim a la variable (tecla)
; (i: amunt, j:esquerra, k:avall, l:dreta).
; Comprovar que no sortim del taulell, (row) i (col) només poden 
; prendre els valors [1..4] i [A..D]. Si al fer el moviment es surt 
; del tauler, no fer el moviment.
; No posicionar el cursor a la pantalla, es fa a posCurScreen.
; 
; Variables utilitzades: 
;	tecla : caràcter llegit de teclat
;          'i': amunt, 'j':esquerra, 'k':avall, 'l':dreta
;	row   : fila del cursor a la matriu puzzle.
;	col   : columna del cursor a la matriu puzzle.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne
      
   	mov al, byte [tecla]
   	cmp al, 's'
   	je End	
      cmp al, 'm'
   	je End
      cmp al, ' '
      je End
   ;canviar tots els valors de 0-3
   	dec dword [row] 
   	sub byte [col], 'A'
   	sub al, 'i'
   ;si tecla es l:3:dreta no canviar fila, ves directe a columna
   	cmp al, 3
   	je lr
   	;cmp al, 0
   	;je cheC
   ;canviar fila
   	dec byte [row]
   	add byte [row], al
   ;si tecla es i:0:amunt no canviar columna, ves al cheC
   lr:	 
      cmp al, 0
   	je cheC
   ;canviar columna
   	sub byte [col], 2
   	add byte [col], al
   	;jmp Fi
   cheC:
      cmp byte [col], 0
   	jge colB
   	inc byte [col]
   	jmp Fi
   colB:
      cmp byte [col], 3
   	jle cheR
   	dec byte [col]
      jmp Fi
   cheR:
      cmp dword [row], 255
   	jne rowB
   	mov dword [row], 0
   	jmp Fi
   rowB:
      cmp dword [row], 3
   	jle Fi
   	dec dword [row]
   Fi:
      add dword [row], 1
   	add byte [col], 'A'
   End:



   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continuo. 
;
; Variables utilitzades: 
;	tecla    : variable on s'emmagatzema el caràcter llegit
;	row      : Fila per a accedir a la matriu puzzle
;	col      : Columna per a accedir a la matriu puzzle
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuo:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne

   cont:
      call getMove
      mov al, byte[tecla]
      cmp al, 'm'
      je FiCont
      cmp al, 's'
      je FiCont
      cmp al, ' '
      je FiCont
      call moveCursor
      call posCurScreen
      jmp cont

   FiCont:

   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Desplaçar una fitxa cap al forat. La fitxa ha desplaçar serà la que
; indiquin les variables (row) i (col) i primerament s'ha de comprovar
; si és una posició vàlida per ser desplaçada. Una posició vàlida vol
; dir que és contigua al forat, sense comptar diagonals. Si no és una
; posició vàlida no fer el moviment.
; També s'ha de desplaçar el forat cap a la casella que s'ha mogut.
;
; Variables utilitzades: 
;	tecla  : caràcter llegit de teclat
;          'i': amunt, 'j':esquerra, 'k':avall, 'l':dreta
;	row    : fila del cursor a la matriu puzzle.
;	col    : columna del cursor a la matriu puzzle.
;	rowEmpty : fila de la casella buida
;	colEmpty : columna de la casella buida
;	puzzle : matriu on es guarda l'estat del joc.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveTile:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne
   push rax
   push rbx
   push rcx
   push rdx

      mov al, byte [colEmpty]
      mov ebx, dword [rowEmpty]
      call calcIndex
      mov edx, dword [indexMat] ;edx index of cursor
      mov cl, byte [puzzle+edx] ;cl es la lletra on esta el cursor

      ; inc cl
      ; mov byte [puzzle+edx], cl       
      ; mov byte [carac], cl  ;carac name of charachter you  want to place at cursor
      ; call printch    ;print charachter

   ;col c1/2
      cmp byte [col], al
      jne c34
   ;c1
      dec ebx  ;ebx=rowE-1
      cmp dword [row], ebx
      jne c2
      ;change current pos to space
      mov byte [carac], ' ' ;replace current space with ' ' in screen
      call printch
      mov byte [puzzle+edx], ' ' ;change to space in matrix
      ;change space to charach in current pos
      inc dword [row] ; you are now in the empty position
      call calcIndex
      mov edx, dword [indexMat] ;edx index of cursor
      mov byte [puzzle+edx], cl
      mov byte [carac], cl
      call posCurScreen
      call printch

      jmp fiMov
   c2:
      add ebx, 2   ;ebx=rowE+1
      cmp dword [row], ebx
      jne c34
      ;change current pos to space
      mov byte [carac], ' ' ;replace current space with ' ' in screen
      call printch
      mov byte [puzzle+edx], ' ' ;change to space in matrix
      ;change space to charach in current pos
      dec dword [row] ; you are now in the empty position
      call calcIndex
      mov edx, dword [indexMat] ;edx index of cursor
      mov byte [puzzle+edx], cl
      mov byte [carac], cl
      call posCurScreen
      call printch

      jmp fiMov
   c34:
   ;c3
      ; dec ebx ;ebx=rowE
      dec al ;al=colE-1
      cmp byte [col], al
      jne c4
      ;change current pos to space
      mov byte [carac], ' ' ;replace current space with ' ' in screen
      call printch
      mov byte [puzzle+edx], ' ' ;change to space in matrix
      ;change space to charach in current pos
      inc byte [col] ; you are now in the empty position
      call calcIndex
      mov edx, dword [indexMat] ;edx index of cursor
      mov byte [puzzle+edx], cl
      mov byte [carac], cl
      call posCurScreen
      call printch

      jmp fiMov
   c4:
      add al, 2 ;al=colE+1
      cmp byte [col], al
      jne correctCol
      ;change current pos to space
      mov byte [carac], ' ' ;replace current space with ' ' in screen
      call printch
      mov byte [puzzle+edx], ' ' ;change to space in matrix
      ;change space to charach in current pos
      dec byte [col] ; you are now in the empty position
      call calcIndex
      mov edx, dword [indexMat] ;edx index of cursor
      mov byte [puzzle+edx], cl
      mov byte [carac], cl
      call posCurScreen
      call printch

      jmp fiMov
   correctCol:
      dec al ;al=colE
   fiMov:
      mov byte [colEmpty], al
      mov dword [rowEmpty], ebx


   pop rdx
   pop rcx
   pop rbx
   pop rax

   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Comprovar si s'ha guanyat el joc. Es considera una victòria si totes
; les lletres estan ordenades i el forat està al final.
;
; Variables utilitzades: 
; puzzle : matriu on es guarda l'estat del joc.
; victory: variable que ens indica que s'ha guanyat el joc
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
checkVictory:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne



   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
; Actualitzar el nombre de moviments realitzats, tenint en compte que
; quan es mouen més d'una fitxa a l'hora són tants moviments com fitxes
; es desplacen.
; Imprimir el nou valor a la posició indicada (rowScreen = 2, colScreen = 58), tenint
; en compte que hi haurem de sumar el valor '0' pel format ASCII.
;
; Variables utilitzades: 
; rowScreen : Fila de la pantalla
; colScreen : Columna de la pantalla
; moves : Comptador de moviments
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateMovements:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne



   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continuo de fitxes. S'ha
; d'utilitzar la tecla 'm' per moure una fitxa i la tecla 's' per
; sortir del joc. 
;
; Variables utilitzades: 
;	tecla   : variable on s'emmagatzema el caràcter llegit
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
playTile:
   push rbp
   mov  rbp, rsp
   ;Inici codi alumne



   ;Final codi alumne
   mov rsp, rbp
   pop rbp
   ret


