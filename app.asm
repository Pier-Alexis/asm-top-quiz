; Assemble with: nasm -f win32 quiz.asm -o quiz.obj
; Link with: gcc quiz.obj -o quiz.exe -lkernel32 -luser32 -lgdi32
%include "constants.inc"
%include "macros.inc"
%include "windows_api.inc"

section .data
    ; Fenêtre et messages
    className db "QuizClass", 0
    windowTitle db "twenty one pilots Quiz", 0
    correctMsg db "Correct! Well done.", 0
    wrongMsg db "Wrong answer! Try again.", 0
    endQuizMsg db "Quiz finished! Your score: %d", 0

    ; Fichiers
    questionsFile db "questions.txt", 0
    imagesPath db "images/", 0

section .bss
    hwndMain resd 1
    hwndStatic resd 1
    hwndInput resd 1
    hwndButton resd 1
    hwndImage resd 1
    currentQuestion resd 1
    userScore resd 1
    totalQuestions resd 1
    buffer resb 128

section .text
global _start

_start:
    ; Charger les données
    call LoadQuestions

    ; Créer la fenêtre principale
    invoke RegisterClassExA, classStruct
    test eax, eax
    jz quit

    invoke CreateWindowExA, 0, className, windowTitle, WS_OVERLAPPEDWINDOW, \
           CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, 0, 0, hInstance, 0
    test eax, eax
    jz quit

    ; Afficher la fenêtre
    invoke ShowWindow, eax, SW_SHOWDEFAULT
    invoke UpdateWindow, eax

    ; Boucle principale
msgLoop:
    invoke GetMessageA, msg, 0, 0, 0
    cmp eax, 0
    je quit
    invoke TranslateMessage, msg
    invoke DispatchMessageA, msg
    jmp msgLoop

quit:
    invoke ExitProcess, 0

WndProc:
    ; Traiter les messages
    cmp [msg+4], WM_COMMAND
    jne defProc
    ; Gérer les clics sur le bouton
    cmp [msg+8], hwndButton
    jne defProc
    call CheckAnswer
    jmp defProc

CheckAnswer:
    ; Lire la réponse de l'utilisateur
    invoke GetDlgItemTextA, [hwndMain], hwndInput, buffer, 128
    invoke lstrcmpiA, buffer, [answers + currentQuestion*128]
    test eax, eax
    jnz WrongAnswer

    ; Bonne réponse
    inc dword [userScore]
    call NextQuestion
    ret

WrongAnswer:
    ; Mauvaise réponse
    invoke MessageBoxA, [hwndMain], wrongMsg, "Result", MB_OK
    ret

NextQuestion:
    ; Charger la question suivante
    inc dword [currentQuestion]
    cmp dword [currentQuestion], [totalQuestions]
    jge EndQuiz
    
    ; Mettre à jour la question et l'image
    invoke SetDlgItemTextA, [hwndMain], hwndStatic, [questions + currentQuestion*128]
    call UpdateImage
    ret

EndQuiz:
    ; Afficher le score final
    invoke wsprintfA, buffer, endQuizMsg, [userScore]
    invoke MessageBoxA, [hwndMain], buffer, "Quiz Complete", MB_OK
    invoke PostQuitMessage, 0
    ret

UpdateImage:
    ; Charger l'image correspondante
    lea eax, [imagesPath]
    add eax, [currentQuestion]
    invoke LoadImageA, 0, eax, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
    mov [hBitmap], eax
    invoke SendMessageA, [hwndImage], STM_SETIMAGE, IMAGE_BITMAP, eax
    ret

defProc:
    invoke DefWindowProcA, [hwndMain], [msg+4], [msg+8], [msg+12]
    ret

LoadQuestions:
    ; Charger les questions depuis un fichier
    invoke CreateFileA, questionsFile, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0
    test eax, eax
    jz quit
    mov ebx, eax

    ; Lire les questions et réponses dans la mémoire
    ; (Implémentez la logique pour parser les questions/réponses)

    invoke CloseHandle, ebx
    ret
