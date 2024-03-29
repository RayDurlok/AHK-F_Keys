#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
#WinActivateForce

Menu, Tray, Icon, shell32.dll, 16 ;this changes the icon into a little laptop thingy. just useful for making it distinct from the others.

; GUI and Variable Storage
;______________________________________________________________________________________________________________________

Drive := A_WorkingDir

; Define the INI file path
myinipath := A_WorkingDir . "\Storage.ini"

CreateTheIni(myinipath) {
    ; Check if the file already exists
    if (!FileExist(myinipath)) {
        ; If the file doesn't exist, create it
        FileAppend,, %myinipath%

        ; Display the path to the INI file for debugging
        ;MsgBox, The path to the INI file is: %myinipath%


    }
}



; Hotkey to show the GUI (Strg+I)
^i::
guiopen:
    Gui, destroy
    yPos := 20

; Define variables and their titles in the order of F numbers
; Define variables and their titles in the order of F numbers
variableOrder := ["F1Key", "F2Key", "F3Key", "F4Key", "F5Key", "F6Key", "F7Key", "F8Key", "F9Key", "F10Key", "F11Key", "F12Key"]
variables := {"F1Key": "F1 Key","F2Key": "F2 Key","F3Key": "F3 Key","F4Key": "F4 Key","F5Key": "F5 Key","F6Key": "F6 Key","F7Key": "F7 Key","F8Key": "F8 Key","F9Key": "F9 Key","F10Key": "F10 Key","F11Key": "F11 Key","F12Key": "F12 Key"}



    ; Loop through variableOrder to create GUI controls in the specified order
    for _, key in variableOrder
    {
        title := variables[key]
        Gui, Add, Text, x12 y%yPos%, %title%
        yPos += 20
        Gui, Add, Edit, x12 y%yPos% w370 h20 v%key%
        yPos += 30
    }


   ; Add the additional text
    Gui, Add, Text,,
    Gui, Add, Text,,Add paths to any folder, .exe or website links, to launch them with F1-F12.
    Gui, Add, Text,,Example: C:\Windows\system32\SnippingTool.exe
    Gui, Add, Text,,Name Screenshots: explorer.png & explorer1.png and place them in same Folder.
    Gui, Add, Text,,Shortcuts: Press Insert to Suspend Hotkeys & CTRL+Insert to Exit.

    ; Add extra space for buttons
    yPos += 150
    ;Gui, Add, Button, x82 y%yPos% w100 h30 gcreatetheini, Create ini
    Gui, Add, Button, x130 y%yPos% w100 h30 gsavetoini, Save



    GuiHeight := yPos + 40  ; Calculate total GUI height

    ; Change: Automatically read and populate the GUI with values from the INI file
    gosub, readtheini

    ; Show the GUI
    Gui, Show, x769 y200 h%GuiHeight% w400, F-Keys Launcher Paths


Return


GuiClose:
    Gui, destroy
Return

createtheini:
    CreateTheIni(myinipath)  ; Call the function to create an empty INI file
Return

readtheini:
    for _, key in variableOrder  ; Use the ordered list for reading
    {
        IniRead, value, %myinipath%, Variables, %key%
        GuiControl,, %key%, %value%
    }
Return

savetoini:
gosub, createtheini
    Gui, Submit  ; Retrieve the latest values from the GUI controls
    errorOccurred := false  ; Flag to track if any errors occurred during the loop

    for _, key in variableOrder  ; Use the ordered list for saving
    {
        GuiControlGet, value,, %key%
        IniWrite, %value%, %myinipath%, Variables, %key%  ; Attempt to write the information to the INI file
        if (ErrorLevel)  ; Check if IniWrite encountered an error
        {
            errorOccurred := true
            break  ; Exit the loop on the first error
        }
    }

    if (errorOccurred)
        MsgBox, 16, Error, An error occurred while writing to the INI file. Please check the file path and permissions.
Return
;_________________________
;End of GUI

;^!1::Suspend
;^!5::Edit
;F12::Reload
Insert::Suspend
^Insert::ExitApp


F1::
IniRead, F1Value, %myinipath%, Variables, F1Key  ; Read the value from the INI file
NavRun(F1Value)  ; Call the existing NavRun function with the value
return

F2::
IniRead, F2Value, %myinipath%, Variables, F2Key
NavRun(F2Value)
return

F3::
IniRead, F3Value, %myinipath%, Variables, F3Key
NavRun(F3Value)
return

F4::
IniRead, F4Value, %myinipath%, Variables, F4Key
NavRun(F4Value)
return

F5::
IniRead, F5Value, %myinipath%, Variables, F5Key
NavRun(F5Value)
return

F6::
IniRead, F6Value, %myinipath%, Variables, F6Key
NavRun(F6Value)
return

F7::
IniRead, F7Value, %myinipath%, Variables, F7Key
NavRun(F7Value)
return

F8::
IniRead, F8Value, %myinipath%, Variables, F8Key
NavRun(F8Value)
return

F9::
IniRead, F9Value, %myinipath%, Variables, F9Key
NavRun(F9Value)
return

F10::
IniRead, F10Value, %myinipath%, Variables, F10Key
NavRun(F10Value)
return

F11::
IniRead, F11Value, %myinipath%, Variables, F11Key
NavRun(F11Value)
return

F12::
IniRead, F12Value, %myinipath%, Variables, F12Key
NavRun(F12Value)
return



^F1::
IniRead, F1Value, %myinipath%, Variables, F1Key  ; Read the value from the INI file
	; find orientetion element in explorer to insert the directory
		Drive := A_WorkingDir
		MouseGetPos, mouseX, mouseY
		; Store the mouse position in variables + block input
		currentX := mouseX
		currentY := mouseY
		BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ;imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and leftclicks it.
			If (ErrorLevel = 0) {

			MouseClick, left, imageX-30, imageY+10
			ToolTip, It worked!
			sleep 100
			;send variable Directory 1
			SendInput, %F1Value%  ; Sends the F1Value as keystrokes
			Send, {enter}
			ToolTip,
			;deselect path window
			MouseClick, left, imageX+150, imageY+100
			;move cursor back to previous position
			MouseMove, currentX, currentY


        return
}

			;if an error occurs, program jumps to this function
			If (ErrorLevel = 1) {
				   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

				MouseClick, left, imageX-30, imageY+10
			ToolTip, It worked!
			sleep 100
			;send variable Directory 1
			SendInput, %F1Value%
			Send, {enter}
			ToolTip,
			;deselect path window
			MouseClick, left, imageX+150, imageY+100
			;move cursor back to previous position
			MouseMove, currentX, currentY


			ToolTip, second img
			sleep 150
			ToolTip,
			return
}

			If(ErrorLevel = 2){
				ToolTip, cant be found
			sleep 500
			ToolTip,
			}


^F2::
IniRead, F2Value, %myinipath%, Variables, F2Key  ; Read the value from the INI file
    ; find orientetion element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ;imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and leftclicks it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ;send variable Directory 1
            SendInput, %F2Value%  ; Sends the F1Value as keystrokes
            Send, {enter}
            ToolTip,
            ;deselect path window
            MouseClick, left, imageX+150, imageY+100
            ;move cursor back to previous position
            MouseMove, currentX, currentY


        return
}

            ;if an error occurs, program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ;send variable Directory 1
            SendInput, %F2Value%
            Send, {enter}
            ToolTip,
            ;deselect path window
            MouseClick, left, imageX+150, imageY+100
            ;move cursor back to previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, cant be found
            sleep 500
            ToolTip,
            }

^F4::
IniRead, F4Value, %myinipath%, Variables, F4Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F4Value%  ; Sends the F4Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F4Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

^F5::
IniRead, F5Value, %myinipath%, Variables, F5Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F5Value%  ; Sends the F5Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F5Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }


^F6::
IniRead, F6Value, %myinipath%, Variables, F6Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F6Value%  ; Sends the F6Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F6Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

; Repeat the above pattern for F7 to F12
^F7::
IniRead, F7Value, %myinipath%, Variables, F7Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F7Value%  ; Sends the F7Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F7Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

^F8::
IniRead, F8Value, %myinipath%, Variables, F8Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F8Value%  ; Sends the F8Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F8Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

; Repeat the above pattern for F9 to F12
^F9::
IniRead, F9Value, %myinipath%, Variables, F9Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F9Value%  ; Sends the F9Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F9Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

^F10::
IniRead, F10Value, %myinipath%, Variables, F10Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F10Value%  ; Sends the F10Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F10Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

^F11::
IniRead, F11Value, %myinipath%, Variables, F11Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F11Value%  ; Sends the F11Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F11Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }

^F12::
IniRead, F12Value, %myinipath%, Variables, F12Key  ; Read the value from the INI file
    ; find orientation element in explorer to insert the directory
        Drive := A_WorkingDir
        MouseGetPos, mouseX, mouseY
        ; Store the mouse position in variables + block input
        currentX := mouseX
        currentY := mouseY
        BlockInput, Mouse

    ; Search for the image in the current working directory, place image in the directory so the image search can look for it on the screen.
    ; imageX and imageY are the coordinates of the image
    ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer1.png
    ; If the image is found, move the mouse to its position and left-click it.
            If (ErrorLevel = 0) {

            MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F12Value%  ; Sends the F12Value as keystrokes
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


        return
}

            ; If an error occurs, the program jumps to this function
            If (ErrorLevel = 1) {
                   ImageSearch, imageX, imageY, 0, 0, A_ScreenWidth, A_ScreenHeight, %Drive%\explorer2.png

                MouseClick, left, imageX-30, imageY+10
            ToolTip, It worked!
            sleep 100
            ; Send variable Directory 1
            SendInput, %F12Value%
            Send, {enter}
            ToolTip,
            ; Deselect path window
            MouseClick, left, imageX+150, imageY+100
            ; Move cursor back to the previous position
            MouseMove, currentX, currentY


            ToolTip, second img
            sleep 150
            ToolTip,
            return
}

            If(ErrorLevel = 2){
                ToolTip, can't be found
            sleep 500
            ToolTip,
            }



;_________________________________________________
; http://msdn.microsoft.com/en-us/library/bb774094
GetActiveExplorer() {
	;tooltip, getactiveexplorer code now
    static objShell := ComObjCreate("Shell.Application")
    WinHWND := WinActive("A")    ; Active window
    for Item in objShell.Windows
        if (Item.HWND = WinHWND)
           return Item        ; Return active window object
    return -1    ; No explorer windows match active window
}

NavRun(Path) {
    if (-1 != objIE := GetActiveExplorer())
        objIE.Navigate(Path)
    else
        Run, % Path
}
;--------The above script originally from: https://autohotkey.com/board/topic/102127-navigating-explorer-directories/
