k0 = 0x12345678                  ; 128-bit secret key (example)
k1 = 0x12345678
k2 = 0x12345678
k3 = 0x12345678

l0 = 0x13371337                  ; 64- bit 2nd secret key (example)
l1 = 0x73317331

m0 = 0x12345678                  ; 64- bit 3rd secret key (example)
m1 = 0x12345678

IniFile = Alone.ini

CheckAuth:
   url = http://worldclockapi.com/api/json/utc/now
   WinHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   WinHttp.SetTimeouts(0,30000,30000,600000)
   WinHttp.Open("GET", url, false), WinHttp.Send()
   WinHttp.WaitForResponse(), str := StrReplace(Trim(WinHttp.ResponseText, "{}"), """"), arr := {}
   Loop, Parse, str, `,
   key := StrSplit(A_LoopField,":").1, arr[key] := SubStr(A_LoopField, StrLen(key) + 2)
   FormatTime, dt, % StrReplace(SubStr(arr.currentDateTime, 1, 10), "-"), ddMMyyyy
   dt := d3 d1 d2
   FormatTime, AIOWeek, %date%, YWeek


   ComObjError(0)
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   whr.Open("GET", "https://raw.githubusercontent.com/AloneCodeA/Testing/main/Version", true)
   whr.Send()
   Try whr.WaitForResponse(3000)
   VersionText := whr.ResponseText
   Version := RegExReplace(VersionText, "\D")

   InputBox Fingerprint,Fingerprint, Enter the PC ID,,220,140

   Together = %AIOWeek%.%Version%.%Fingerprint%
   AuthData := XCBC(Hex(Together,StrLen(Together)), 0,0, k0,k1,k2,k3, l0,l1, m0,m1)


   If (Code <> AuthData)
   {
	   ;MsgBox, %AuthData%
      clipboard := AuthData
      ExitApp
   }
Return


TEA(ByRef y,ByRef z, k0,k1,k2,k3)
{                                   ; need  SetFormat Integer, D
   s = 0
   d = 0x9E3779B9
   Loop 32                          ; could be reduced to 8 for speed
   {
      k := "k" . s & 3              ; indexing the key
      y := 0xFFFFFFFF & (y + ((z << 4 ^ z >> 5) + z  ^  s + %k%))
      s := 0xFFFFFFFF & (s + d)  ; simulate 32 bit operations
      k := "k" . s >> 11 & 3
      z := 0xFFFFFFFF & (z + ((y << 4 ^ y >> 5) + y  ^  s + %k%))
   }
}

XCBC(x, u,v, k0,k1,k2,k3, l0,l1, m0,m1)
{
   Loop % Ceil(StrLen(x)/16)-1   ; full length intermediate message blocks
   XCBCstep(u, v, x, k0,k1,k2,k3)
   If (StrLen(x) = 16)              ; full length last message block
   {
      u := u ^ l0                   ; l-key modifies last state
      v := v ^ l1
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Else {                           ; padded last message block
      u := u ^ m0                   ; m-key modifies last state
      v := v ^ m1
      x = %x%100000000000000
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Return Hex8(u) . Hex8(v)         ; 16 hex digits returned
}

XCBCstep(ByRef u, ByRef v, ByRef x, k0,k1,k2,k3)
{
   StringLeft  p, x, 8              ; Msg blocks
   StringMid   q, x, 9, 8
   StringTrimLeft x, x, 16
   p = 0x%p%
   q = 0x%q%
   u := u ^ p
   v := v ^ q
   TEA(u,v,k0,k1,k2,k3)
}

Hex8(i)                             ; 32-bit integer -> 8 hex digits
{
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex
   i += 0x100000000                 ; convert to hex, set MS bit
   StringTrimLeft i, i, 3           ; remove leading 0x1
   SetFormat Integer, %format%      ; restore original format
   Return i
}



Hex(ByRef b, n=0)                   ; n bytes data -> stream of 2-digit hex
{                                   ; n = 0: all (SetCapacity can be larger than used!)
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex           ; for converting bytes to hex
   m := VarSetCapacity(b)
   If (n < 1 or n > m)
       n := m
   Loop %n%
   {
      x := 256 + *(&b+A_Index-1)    ; get byte in hex, set 17th bit
      StringTrimLeft x, x, 3        ; remove 0x1
      h = %h%%x%
   }
   SetFormat Integer, %format%      ; restore original format
   Return h
}

k0 = 0x20221506                  ; 128-bit secret key (example)
k1 = 0x20031216
k2 = 0x95731898
k3 = 0x52013140

l0 = 0x13371337                  ; 64- bit 2nd secret key (example)
l1 = 0x73317331

m0 = 0x13145205                  ; 64- bit 3rd secret key (example)
m1 = 0x13145205

IniFile = Alone.ini

CheckAuth:
   ComObjError(0)
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   whr.Open("GET", "http://worldtimeapi.org/api/ip/8.8.8.8.txt", true)
   whr.Send()
   Try whr.WaitForResponse(3000)
   VersionText := whr.ResponseText
   AIOWeek := SubStr(VersionText,-1)

   ComObjError(0)
   whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   whr.Open("GET", "https://raw.githubusercontent.com/AloneCodeT/Testing/main/Version", true)
   whr.Send()
   Try whr.WaitForResponse(3000)
   VersionText := whr.ResponseText
   Version := RegExReplace(VersionText, "\D")

   InputBox Fingerprint,Fingerprint, Enter the PC ID,,220,140

   Together = %AIOWeek%%Version%%Fingerprint%
   AuthData := XCBC(Hex(Together,StrLen(Together)), 0,0, k0,k1,k2,k3, l0,l1, m0,m1)


   ;MsgBox, %AuthData%
   clipboard := AuthData
   IniWrite %AuthData%, %IniFile%, Alone#1337, Code
   ExitApp      


TEA(ByRef y,ByRef z, k0,k1,k2,k3)
{                                   ; need  SetFormat Integer, D
   s = 0
   d = 0x9E3779B9
   Loop 32                          ; could be reduced to 8 for speed
   {
      k := "k" . s & 3              ; indexing the key
      y := 0xFFFFFFFF & (y + ((z << 4 ^ z >> 5) + z  ^  s + %k%))
      s := 0xFFFFFFFF & (s + d)  ; simulate 32 bit operations
      k := "k" . s >> 11 & 3
      z := 0xFFFFFFFF & (z + ((y << 4 ^ y >> 5) + y  ^  s + %k%))
   }
}

XCBC(x, u,v, k0,k1,k2,k3, l0,l1, m0,m1)
{
   Loop % Ceil(StrLen(x)/16)-1   ; full length intermediate message blocks
   XCBCstep(u, v, x, k0,k1,k2,k3)
   If (StrLen(x) = 16)              ; full length last message block
   {
      u := u ^ l0                   ; l-key modifies last state
      v := v ^ l1
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Else {                           ; padded last message block
      u := u ^ m0                   ; m-key modifies last state
      v := v ^ m1
      x = %x%100000000000000
      XCBCstep(u, v, x, k0,k1,k2,k3)
   }
   Return Hex8(u) . Hex8(v)         ; 16 hex digits returned
}

XCBCstep(ByRef u, ByRef v, ByRef x, k0,k1,k2,k3)
{
   StringLeft  p, x, 8              ; Msg blocks
   StringMid   q, x, 9, 8
   StringTrimLeft x, x, 16
   p = 0x%p%
   q = 0x%q%
   u := u ^ p
   v := v ^ q
   TEA(u,v,k0,k1,k2,k3)
}

Hex8(i)                             ; 32-bit integer -> 8 hex digits
{
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex
   i += 0x100000000                 ; convert to hex, set MS bit
   StringTrimLeft i, i, 3           ; remove leading 0x1
   SetFormat Integer, %format%      ; restore original format
   Return i
}



Hex(ByRef b, n=0)                   ; n bytes data -> stream of 2-digit hex
{                                   ; n = 0: all (SetCapacity can be larger than used!)
   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex           ; for converting bytes to hex
   m := VarSetCapacity(b)
   If (n < 1 or n > m)
       n := m
   Loop %n%
   {
      x := 256 + *(&b+A_Index-1)    ; get byte in hex, set 17th bit
      StringTrimLeft x, x, 3        ; remove 0x1
      h = %h%%x%
   }
   SetFormat Integer, %format%      ; restore original format
   Return h
}