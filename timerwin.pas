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

unit TimerWin;

{$mode objfpc}{$H+}

interface

uses
  Windows;

type
  ProcTimerType = procedure;

  TTimerWin = class
    private
      period   : integer; // 1000 = 1 sec
      timer_on : boolean;
      thID     : DWORD;

      procTimer : ProcTimerType;
    public
      constructor Create (per : integer);

      procedure TimerOn;
      procedure TimerOff;

      function SetProcTimer (proc : ProcTimerType) : boolean;
  end;

function TickTimer (ipParam : Pointer) : DWORD; stdcall;

implementation

constructor TTimerWin.Create(per : integer);
begin
  procTimer := nil;
  timer_on  := false;

  period := per;
  if period < 1 then
    period := 1;

  IsMultiThread := true;
  CreateThread(nil, 0, @TickTimer, self, 0, thID);
end;

procedure TTimerWin.TimerOn;
begin
  timer_on := true;
end;

procedure TTimerWin.TimerOff;
begin
  timer_on := false;
end;

function TTimerWin.SetProcTimer(proc : ProcTimerType) : boolean;
begin
  if proc = nil then begin
    result := false;
    exit;
  end;

  procTimer := proc;
  result := true;
end;

function TickTimer(ipParam : Pointer) : DWORD; stdcall;
var
  tim    : TTimerWin;
  time_s : TLargeInteger;
  freq   : TLargeInteger;
  time_1 : int64;
  time_2 : int64;
begin
  tim := TTimerWin(ipParam);

  freq := 0;
  time_s := 0;
  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(time_s);
  writeln(freq);
  writeln(time_s);

  time_1 := round(time_s / freq * 1000);

  while true do begin
    QueryPerformanceCounter(time_s);
    time_2 := round(time_s / freq * 1000);

    if (time_2 > time_1) and (tim.timer_on) then begin
      time_1 := time_1 + tim.period;

      if time_2 > time_1 then
        time_1 := time_2 + tim.period;

      if tim <> nil then
        if tim.procTimer <> nil then
          tim.procTimer;
    end;
    Sleep(1);
  end;

  result := 1;
end;

end.

