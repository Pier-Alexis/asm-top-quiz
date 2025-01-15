%macro CREATE_WINDOW 4
    push dword %4        ; hMenu
    push dword %3        ; hInstance
    push dword 0         ; lpParam
    push dword %2        ; hWndParent
    push dword %1        ; Class Name
    call [CreateWindowExA]
%endmacro

%macro MESSAGE_BOX 2
    push dword 0         ; uType (OK only)
    push dword %2        ; lpCaption
    push dword %1        ; lpText
    push dword 0         ; hWnd
    call [MessageBoxA]
%endmacro
