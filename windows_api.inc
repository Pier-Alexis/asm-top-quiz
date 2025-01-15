extern CreateWindowExA
extern DefWindowProcA
extern RegisterClassExA
extern GetMessageA
extern TranslateMessage
extern DispatchMessageA
extern PostQuitMessage
extern MessageBoxA
extern LoadImageA
extern SendMessageA
extern SetWindowTextA
extern GetWindowTextA
extern DeleteObject

section .data
    user32  db "user32.dll", 0
    gdi32   db "gdi32.dll", 0
    kernel32 db "kernel32.dll", 0
    msgBox  db "MessageBoxA", 0
