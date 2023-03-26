{ Copyright (c) 2023 dedm0zaj                                            }
{                                                                        }
{ Permission is hereby granted, free of charge, to any person obtaining  }
{ a copy of this software and associated documentation files (the        }
{ "Software"), to deal in the Software without restriction, including    }
{ without limitation the rights to use, copy, modify, merge, publish,    }
{ distribute, sublicense, and/or sell copies of the Software, and to     }
{ permit persons to whom the Software is furnished to do so, subject to  }
{ the following conditions:                                              }
{                                                                        }
{ The above copyright notice and this permission notice shall be         }
{ included in all copies or substantial portions of the Software.        }
{                                                                        }
{ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        }
{ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     }
{ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. }
{ IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   }
{ CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   }
{ TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      }
{ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 }

unit WindowWin;

{$mode objfpc}{$H+}

interface

uses
  Windows,
  dglopengl;

const
  MOUSE_LEFT    = 1;
  MOUSE_MIDDLE  = 2;
  MOUSE_RIGHT   = 3;

type
  ProcKeyType        = procedure(keycode : word);
  ProcMouseType      = procedure(button : word; x, y : word);
  ProcMouseMoveType  = procedure(x, y : word);
  ProcResizeType     = procedure(x, y : integer);
  ProcPaintType      = procedure();

  TWindWin = class
    private
      hmsg  : TMsg;
      wnd2  : hwnd;
      wnd   : TWndClassEx;
      thID  : DWORD;

      procKeyDown   : ProcKeyType;
      procKeyUp     : ProcKeyType;
      procMouseDown : ProcMouseType;
      procMouseUp   : ProcMouseType;
      procMouseMove : ProcMouseMoveType;
      procResize    : ProcResizeType;
      procPaint     : ProcPaintType;

    public
      make : boolean;

      dc    : HDC;
      hrc   : HGLRC;

      constructor Create;

      procedure CreateWind(title: PAnsiChar;  width, height: integer);
      procedure ReadMessage;
      function SetProcKeyDown   (proc : ProcKeyType)       : boolean;
      function SetProcKeyUp     (proc : ProcKeyType)       : boolean;
      function SetProcMouseDown (proc : ProcMouseType)     : boolean;
      function SetProcMouseUp   (proc : ProcMouseType)     : boolean;
      function SetProcMouseMove (proc : ProcMouseMoveType) : boolean;
      function SetProcResize    (proc : ProcResizeType)    : boolean;
      function SetProcPaint     (proc : ProcPaintType)     : boolean;
  end;

function WindProc (Window : HWnd; Message, WParam : Word;
                   LParam : LongInt) : LongInt; export; stdcall;



implementation

constructor TWindWin.Create();
begin
  procKeyDown   := nil;
  procKeyUp     := nil;
  procMouseDown := nil;
  procMouseUp   := nil;
  procMouseMove := nil;
  procResize    := nil;
  procPaint     := nil;

  make := true;
end;

function TWindWin.SetProcKeyDown(proc : ProcKeyType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procKeyDown := proc;
  result := true;
end;

function TWindWin.SetProcKeyUp(proc : ProcKeyType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procKeyUp := proc;
  result := true;
end;

function TWindWin.SetProcMouseDown(proc : ProcMouseType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procMouseDown := proc;
  result := true;
end;

function TWindWin.SetProcMouseUp(proc : ProcMouseType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procMouseUp := proc;
  result := true;
end;

function TWindWin.SetProcMouseMove(proc : ProcMouseMoveType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procMouseMove := proc;
  result := true;
end;

function TWindWin.SetProcResize(proc : ProcResizeType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procResize := proc;
  result := true;
end;

function TWindWin.SetProcPaint(proc : ProcPaintType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procPaint := proc;
  result := true;
end;

procedure TWindWin.CreateWind(title: PAnsiChar; width, height: integer);
begin
  with wnd do begin
    cbSize        := sizeof(WNDCLASSEX);
    style         := CS_OWNDC;
    lpfnWndProc   := WNDPROC(@WindProc);
    cbClsExtra    := 0;
    cbWndExtra    := 0;
    hInstance     := GetModuleHandle('');
    hIcon         := 0;
    hIconSm       := 0;
    hCursor       := LoadCursor (0, IDC_ARROW);
    hbrBackground := HBRUSH(COLOR_WINDOW);
    lpszMenuName  := '';
    lpszClassName := 'bla_bla_bla';
  end;

  RegisterClassEx(@wnd);
  wnd2 := CreateWindowEx(
          0,
          'bla_bla_bla',
          title,
          WS_SYSMENU or WS_MINIMIZEBOX or WS_MAXIMIZEBOX or WS_SIZEBOX,
          cw_UseDefault,
          cw_UseDefault,
          width,
          height,
          0,
          0,
          GetModuleHandle(''),
          self);

  SetWindowLongPtr(wnd2, GWL_USERDATA, LONG_PTR(self));

  dc  := GetDC(wnd2);
  InitOpenGL;
  hrc := CreateRenderingContext(dc,[opDoubleBuffered],32,24,0,0,0,0);

  ActivateRenderingContext(dc, hrc);

  ShowWindow (wnd2, SW_SHOW);

  writeln('create wind');
end;

procedure TWindWin.ReadMessage();
begin
  if GetMessage (hmsg, 0, 0, 0) then begin
    TranslateMessage (hmsg);
    DispatchMessage (hmsg);
  end;
end;

function WindProc (Window : HWnd; Message, WParam : Word;
         LParam : LongInt) : LongInt; export; stdcall;
var
  wind : TWindWin;
begin
  result := 0;
  wind := TWindWin(GetWindowLongPtr(Window, GWL_USERDATA));

  case message of
    WM_CLOSE: begin
      wind.make := false;
      PostQuitMessage(0);
      Result := 0;
    end;

    WM_DESTROY: begin
      Result := 0;
    end;

    WM_CREATE: begin
      Result := 0;
    end;

    WM_KEYDOWN: begin
      if wind <> nil then
        if wind.procKeyDown <> nil then
          wind.procKeyDown(WParam);
    end;

    WM_KEYUP: begin
      if wind <> nil then
        if wind.procKeyUp <> nil then
          wind.procKeyUp(WParam);
    end;

    WM_LBUTTONDOWN: begin
      if wind <> nil then
        if wind.procMouseDown <> nil then
          wind.procMouseDown(MOUSE_LEFT, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_LBUTTONUP: begin
      if wind <> nil then
        if wind.procMouseUp <> nil then
          wind.procMouseUp(MOUSE_LEFT, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_MBUTTONDOWN: begin
      if wind <> nil then
        if wind.procMouseDown <> nil then
          wind.procMouseDown(MOUSE_MIDDLE, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_MBUTTONUP: begin
      if wind <> nil then
        if wind.procMouseUp <> nil then
          wind.procMouseUp(MOUSE_MIDDLE, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_RBUTTONDOWN: begin
      if wind <> nil then
        if wind.procMouseDown <> nil then
          wind.procMouseDown(MOUSE_RIGHT, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_RBUTTONUP: begin
      if wind <> nil then
        if wind.procMouseUp <> nil then
          wind.procMouseUp(MOUSE_RIGHT, LOWORD(LParam), HIWORD(LParam));
    end;

    WM_MOUSEMOVE: begin
      if wind <> nil then
        if wind.procMouseMove <> nil then
          wind.procMouseMove(LOWORD(LParam), HIWORD(LParam));
    end;

    WM_SIZE: begin
      if wind <> nil then
        if wind.procResize <> nil then
          wind.procResize(LOWORD(LParam), HIWORD(LParam));
    end;

    WM_PAINT: begin
      if wind <> nil then
        if wind.procPaint <> nil then begin
          wind.procPaint;
          SwapBuffers(wind.dc);
        end;
    end;

    else begin
      Result := DefWindowProc(window, message, wParam, lParam);
    end;
  end;
end;

end.

