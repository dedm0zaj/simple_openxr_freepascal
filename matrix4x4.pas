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

unit Matrix4x4;

{$mode objfpc}{$H+}

interface

uses
  math;

const
  AXIS_X = 1;
  AXIS_Y = 2;
  AXIS_Z = 3;

type
  //PArr0to15 = ^Arr0to15;
  Arr0to15 = array[0..15] of single;

  TMatrix4x4 = class
    private
      matrix: Arr0to15;
    public
      constructor   Create;
      procedure     Rotate(oxyz: byte; angle: single);
      procedure     RotateQuat(x, y, z, w: single);
      procedure     Translate(x, y, z: single);
      procedure     Scale(x, y, z : single);
      procedure     Multiply(const mat : Arr0to15);
      procedure     ToProjectionMatrix (fov, nearPl, farPl, width, height : single);
      procedure     ToProjectionMatrixFromAngles(
                      angleLeft,
                      angleRight,
                      angleUp,
                      angleDown,
                      nearPl,
                      farPl : single);
      function      GetMatrix: PSingle;
      procedure     Null;
  end;

implementation

function GradToRad(x: single): single; inline;
begin
  result := x * 0.01745329251994;
end;

constructor TMatrix4x4.Create;
begin
  matrix[0]  := 1;  matrix[1]  := 0;  matrix[2]  := 0;  matrix[3]  := 0;
  matrix[4]  := 0;  matrix[5]  := 1;  matrix[6]  := 0;  matrix[7]  := 0;
  matrix[8]  := 0;  matrix[9]  := 0;  matrix[10] := 1;  matrix[11] := 0;
  matrix[12] := 0;  matrix[13] := 0;  matrix[14] := 0;  matrix[15] := 1;
end;

procedure TMatrix4x4.Rotate(oxyz: byte; angle: single);
var
  ca, sa: single;
  mat_new: Arr0to15;
begin
  if (oxyz<1) or (oxyz>3) then
    exit;

  ca := cos(GradToRad(angle));
  sa := sin(GradToRad(angle));

  if oxyz = AXIS_X then begin
    mat_new[0]  := matrix[0];
    mat_new[1]  := matrix[1]*ca + matrix[2]*sa;
    mat_new[2]  := -matrix[1]*sa + matrix[2]*ca;
    mat_new[3]  := matrix[3];

    mat_new[4]  := matrix[4];
    mat_new[5]  := matrix[5]*ca + matrix[6]*sa;
    mat_new[6]  := -matrix[5]*sa + matrix[6]*ca;
    mat_new[7]  := matrix[7];

    mat_new[8]  := matrix[8];
    mat_new[9]  := matrix[9]*ca + matrix[10]*sa;
    mat_new[10] := -matrix[9]*sa + matrix[10]*ca;
    mat_new[11] := matrix[11];

    mat_new[12] := matrix[12];
    mat_new[13] := matrix[13]*ca + matrix[14]*sa;
    mat_new[14] := -matrix[13]*sa + matrix[14]*ca;
    mat_new[15] := matrix[15];
  end;

  if oxyz = AXIS_Y then begin
    mat_new[0]  := matrix[0]*ca - matrix[2]*sa;
    mat_new[1]  := matrix[1];
    mat_new[2]  := matrix[0]*sa + matrix[2]*ca;
    mat_new[3]  := matrix[3];

    mat_new[4]  := matrix[4]*ca - matrix[6]*sa;
    mat_new[5]  := matrix[5];
    mat_new[6]  := matrix[4]*sa + matrix[6]*ca;
    mat_new[7]  := matrix[7];

    mat_new[8]  := matrix[8]*ca - matrix[10]*sa;
    mat_new[9]  := matrix[9];
    mat_new[10] := matrix[8]*sa + matrix[10]*ca;
    mat_new[11] := matrix[11];

    mat_new[12] := matrix[12]*ca - matrix[14]*sa;
    mat_new[13] := matrix[13];
    mat_new[14] := matrix[12]*sa + matrix[14]*ca;
    mat_new[15] := matrix[15];
  end;

  if oxyz = AXIS_Z then begin
    mat_new[0]  := matrix[0]*ca + matrix[1]*sa;
    mat_new[1]  := -matrix[0]*sa + matrix[1]*ca;
    mat_new[2]  := matrix[2];
    mat_new[3]  := matrix[3];

    mat_new[4]  := matrix[4]*ca + matrix[5]*sa;
    mat_new[5]  := -matrix[4]*sa + matrix[5]*ca;
    mat_new[6]  := matrix[6];
    mat_new[7]  := matrix[7];

    mat_new[8]  := matrix[8]*ca + matrix[9]*sa;
    mat_new[9]  := -matrix[8]*sa + matrix[9]*ca;
    mat_new[10] := matrix[10];
    mat_new[11] := matrix[11];

    mat_new[12] := matrix[12]*ca + matrix[13]*sa;
    mat_new[13] := -matrix[12]*sa + matrix[13]*ca;
    mat_new[14] := matrix[14];
    mat_new[15] := matrix[15];
  end;

  matrix := mat_new;
end;

procedure TMatrix4x4.RotateQuat(x, y, z, w: single);
var
  x2, y2, z2 : single;
  xx2, yy2, zz2 : single;
  xy2, xz2, yz2, wx2, wy2, wz2 : single;
  mat_new : Arr0to15;
begin
  x2 := x * 2;
	y2 := y * 2;
	z2 := z * 2;

	xx2 := x * x2;
	yy2 := y * y2;
	zz2 := z * z2;

	yz2 := y * z2;
	wx2 := w * x2;
	xy2 := x * y2;
	wz2 := w * z2;
	xz2 := x * z2;
	wy2 := w * y2;

  mat_new[0] := 1.0 - yy2 - zz2;
	mat_new[1] := xy2 + wz2;
	mat_new[2] := xz2 - wy2;
	mat_new[3] := 0.0;

	mat_new[4] := xy2 - wz2;
	mat_new[5] := 1.0 - xx2 - zz2;
	mat_new[6] := yz2 + wx2;
	mat_new[7] := 0.0;

	mat_new[8] := xz2 + wy2;
	mat_new[9] := yz2 - wx2;
	mat_new[10] := 1.0 - xx2 - yy2;
	mat_new[11] := 0.0;

	mat_new[12] := 0.0;
	mat_new[13] := 0.0;
	mat_new[14] := 0.0;
	mat_new[15] := 1.0;

  Multiply(mat_new);
end;

procedure TMatrix4x4.Translate(x, y, z: single);
begin
  matrix[3]  := matrix[0]*x  + matrix[1]*y  + matrix[2]*z  + matrix[3];
  matrix[7]  := matrix[4]*x  + matrix[5]*y  + matrix[6]*z  + matrix[7];
  matrix[11] := matrix[8]*x  + matrix[9]*y  + matrix[10]*z + matrix[11];
  matrix[15] := matrix[12]*x + matrix[13]*y + matrix[14]*z + matrix[15];
end;

procedure TMatrix4x4.Scale(x, y, z : single);
begin
  matrix[0]  := matrix[0] * x;
  matrix[1]  := matrix[1] * y;
  matrix[2]  := matrix[2] * z;

  matrix[4]  := matrix[4] * x;
  matrix[5]  := matrix[5] * y;
  matrix[6]  := matrix[6] * z;

  matrix[8]  := matrix[8] * x;
  matrix[9]  := matrix[9] * y;
  matrix[10] := matrix[10] * z;

  matrix[12] := matrix[12] * x;
  matrix[13] := matrix[13] * y;
  matrix[14] := matrix[14] * z;
end;

procedure TMatrix4x4.Multiply(const mat : Arr0to15);
var
  mat_new : Arr0to15;
begin
  mat_new[0] := matrix[0] * mat[0] + matrix[4] * mat[1] + matrix[8] * mat[2] + matrix[12] * mat[3];
	mat_new[1] := matrix[1] * mat[0] + matrix[5] * mat[1] + matrix[9] * mat[2] + matrix[13] * mat[3];
	mat_new[2] := matrix[2] * mat[0] + matrix[6] * mat[1] + matrix[10] * mat[2] + matrix[14] * mat[3];
	mat_new[3] := matrix[3] * mat[0] + matrix[7] * mat[1] + matrix[11] * mat[2] + matrix[15] * mat[3];

	mat_new[4] := matrix[0] * mat[4] + matrix[4] * mat[5] + matrix[8] * mat[6] + matrix[12] * mat[7];
	mat_new[5] := matrix[1] * mat[4] + matrix[5] * mat[5] + matrix[9] * mat[6] + matrix[13] * mat[7];
	mat_new[6] := matrix[2] * mat[4] + matrix[6] * mat[5] + matrix[10] * mat[6] + matrix[14] * mat[7];
	mat_new[7] := matrix[3] * mat[4] + matrix[7] * mat[5] + matrix[11] * mat[6] + matrix[15] * mat[7];

	mat_new[8] := matrix[0] * mat[8] + matrix[4] * mat[9] + matrix[8] * mat[10] + matrix[12] * mat[11];
	mat_new[9] := matrix[1] * mat[8] + matrix[5] * mat[9] + matrix[9] * mat[10] + matrix[13] * mat[11];
	mat_new[10] := matrix[2] * mat[8] + matrix[6] * mat[9] + matrix[10] * mat[10] + matrix[14] * mat[11];
	mat_new[11] := matrix[3] * mat[8] + matrix[7] * mat[9] + matrix[11] * mat[10] + matrix[15] * mat[11];

	mat_new[12] := matrix[0] * mat[12] + matrix[4] * mat[13] + matrix[8] * mat[14] + matrix[12] * mat[15];
	mat_new[13] := matrix[1] * mat[12] + matrix[5] * mat[13] + matrix[9] * mat[14] + matrix[13] * mat[15];
	mat_new[14] := matrix[2] * mat[12] + matrix[6] * mat[13] + matrix[10] * mat[14] + matrix[14] * mat[15];
	mat_new[15] := matrix[3] * mat[12] + matrix[7] * mat[13] + matrix[11] * mat[14] + matrix[15] * mat[15];

  matrix := mat_new;
end;

procedure TMatrix4x4.ToProjectionMatrix(fov, nearPl, farPl, width, height : single);
var
  f, A, B, asp : single;
begin
  f   := 1 / tan(gradToRad(fov) * 0.5);
  A   := (farPl + nearPl) / (nearPl - farPl);
  B   := (2 * farPl * nearPl) / (nearPl - farPl);
  asp := width / height;

  matrix[0]  := f/asp;  matrix[1]  := 0;  matrix[2]  := 0;   matrix[3]  := 0;
  matrix[4]  := 0;      matrix[5]  := f;  matrix[6]  := 0;   matrix[7]  := 0;
  matrix[8]  := 0;      matrix[9]  := 0;  matrix[10] := A;   matrix[11] := B;
  matrix[12] := 0;      matrix[13] := 0;  matrix[14] := -1;  matrix[15] := 0;
end;

procedure TMatrix4x4.ToProjectionMatrixFromAngles(
  angleLeft,
  angleRight,
  angleUp,
  angleDown,
  nearPl,
  farPl: single);
var
  tanAngleLeft : single;
  tanAngleRight : single;
  tanAngleDown : single;
  tanAngleUp : single;
  tanAngleWidth : single;
  tanAngleHeight : single;
  offsetZ : single;
begin

  tanAngleLeft := tan(angleLeft);
	tanAngleRight := tan(angleRight);

	tanAngleDown := tan(angleDown);
	tanAngleUp := tan(angleUp);

	tanAngleWidth := tanAngleRight - tanAngleLeft;

  tanAngleHeight := tanAngleUp - tanAngleDown;

  offsetZ := nearPl;

  matrix[0] := 2 / tanAngleWidth;
	matrix[4] := 0;
	matrix[8] := (tanAngleRight + tanAngleLeft) / tanAngleWidth;
	matrix[12] := 0;

	matrix[1] := 0;
	matrix[5] := 2 / tanAngleHeight;
	matrix[9] := (tanAngleUp + tanAngleDown) / tanAngleHeight;
	matrix[13] := 0;

	matrix[2] := 0;
	matrix[6] := 0;
	matrix[10] := -(farPl + offsetZ) / (farPl - nearPl);
	matrix[14] := -(farPl * (nearPl + offsetZ)) / (farPl - nearPl);

	matrix[3] := 0;
	matrix[7] := 0;
	matrix[11] := -1;
	matrix[15] := 0;
end;

procedure TMatrix4x4.Null;
begin
  matrix[0]  := 1;  matrix[1]  := 0;  matrix[2]  := 0;  matrix[3]  := 0;
  matrix[4]  := 0;  matrix[5]  := 1;  matrix[6]  := 0;  matrix[7]  := 0;
  matrix[8]  := 0;  matrix[9]  := 0;  matrix[10] := 1;  matrix[11] := 0;
  matrix[12] := 0;  matrix[13] := 0;  matrix[14] := 0;  matrix[15] := 1;
end;

function TMatrix4x4.GetMatrix: PSingle;
begin
  result := @matrix[0];
end;

end.
