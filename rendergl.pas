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

unit renderGl;

{$mode objfpc}{$H+}

interface

uses
  SysUtils,
  TimerWin,
  Matrix4x4,
  dglopengl,
  openxr,
  openxr_platform;

function  initRenderGl : boolean;
procedure renderGlFrame(
  view: TXrView;
  image: TXrSwapchainImageOpenGLKHR;
  depthImage: TXrSwapchainImageOpenGLKHR;
  frameBuffer: GLuint;
  width: GLuint;
  height: GLuint
  );

implementation

var
  programID   : GLint;
  posID       : GLint;
  projmatID   : GLint;
  posatribID  : GLint;
  coloratribID  : GLint;

  MatModelView  : TMatrix4x4;
  MatProjection : TMatrix4x4;

  fps_redraw : integer = 0;
  TimerFPS   : TTimerWin;

  vertexBuffer : GLuint;
  colorBuffer : GLuint;

  vertexCube : array[0..107] of GLfloat = (
    -0.3,-0.3,-0.3,
    -0.3,-0.3, 0.3,
    -0.3, 0.3, 0.3,
    0.3, 0.3,-0.3,
    -0.3,-0.3,-0.3,
    -0.3, 0.3,-0.3,
    0.3,-0.3, 0.3,
    -0.3,-0.3,-0.3,
    0.3,-0.3,-0.3,
    0.3, 0.3,-0.3,
    0.3,-0.3,-0.3,
    -0.3,-0.3,-0.3,
    -0.3,-0.3,-0.3,
    -0.3, 0.3, 0.3,
    -0.3, 0.3,-0.3,
    0.3,-0.3, 0.3,
    -0.3,-0.3, 0.3,
    -0.3,-0.3,-0.3,
    -0.3, 0.3, 0.3,
    -0.3,-0.3, 0.3,
    0.3,-0.3, 0.3,
    0.3, 0.3, 0.3,
    0.3,-0.3,-0.3,
    0.3, 0.3,-0.3,
    0.3,-0.3,-0.3,
    0.3, 0.3, 0.3,
    0.3,-0.3, 0.3,
    0.3, 0.3, 0.3,
    0.3, 0.3,-0.3,
    -0.3, 0.3,-0.3,
    0.3, 0.3, 0.3,
    -0.3, 0.3,-0.3,
    -0.3, 0.3, 0.3,
    0.3, 0.3, 0.3,
    -0.3, 0.3, 0.3,
    0.3,-0.3, 0.3
  );

  colorCube : array[0..107] of GLfloat = (
    0.583,  0.771,  0.014,
    0.609,  0.115,  0.436,
    0.327,  0.483,  0.844,
    0.822,  0.569,  0.201,
    0.435,  0.602,  0.223,
    0.310,  0.747,  0.185,
    0.597,  0.770,  0.761,
    0.559,  0.436,  0.730,
    0.359,  0.583,  0.152,
    0.483,  0.596,  0.789,
    0.559,  0.861,  0.639,
    0.195,  0.548,  0.859,
    0.014,  0.184,  0.576,
    0.771,  0.328,  0.970,
    0.406,  0.615,  0.116,
    0.676,  0.977,  0.133,
    0.971,  0.572,  0.833,
    0.140,  0.616,  0.489,
    0.997,  0.513,  0.064,
    0.945,  0.719,  0.592,
    0.543,  0.021,  0.978,
    0.279,  0.317,  0.505,
    0.167,  0.620,  0.077,
    0.347,  0.857,  0.137,
    0.055,  0.953,  0.042,
    0.714,  0.505,  0.345,
    0.783,  0.290,  0.734,
    0.722,  0.645,  0.174,
    0.302,  0.455,  0.848,
    0.225,  0.587,  0.040,
    0.517,  0.713,  0.338,
    0.053,  0.959,  0.120,
    0.393,  0.621,  0.362,
    0.673,  0.211,  0.457,
    0.820,  0.883,  0.371,
    0.982,  0.099,  0.879
  );

procedure printFPS;
begin
  writeln('FPS - ' + intToStr(round(fps_redraw * 0.5)));
  fps_redraw := 0;
end;

procedure matProjectionForXr(fov_in: TXrFovf);
begin
  MatProjection.ToProjectionMatrixFromAngles(
    fov_in.angleLeft,
    fov_in.angleRight,
    fov_in.angleUp,
    fov_in.angleDown,
    0.1,
    100);
end;

function initRenderGl : boolean;
const
  simpleVertexShader : AnsiString =
    'attribute vec4 a_position;                          '+
    'attribute vec3 a_color;                             '+
    'uniform mat4 projmat;                               '+
    'uniform mat4 position;                              '+
    'varying vec4 v_color;                               '+
    'void main()                                         '+
    '{                                                   '+
    '    gl_Position = (projmat * position) * a_position;'+
    '    v_color = vec4(a_color, 1.0f);                  '+
    '}';
  simpleFragmentShaderColor : AnsiString =
    'varying vec4 v_color;                               '+
    'void main()                                         '+
    '{                                                   '+
    '    gl_FragColor = v_color;                         '+
    '}';
var
  vertexShaderID    : GLuint;
  fragmentShaderID  : GLuint;
  resGL             : GLint;
  infoLogLength     : integer;
begin
  wglSwapIntervalEXT(0);

  glClearColor(0.5, 0.8, 0.9, 1.0);
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_TEXTURE_2D);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_ALPHA_TEST);
  //
  glAlphaFunc(GL_GREATER, 0.1);

  vertexShaderID   := glCreateShader(GL_VERTEX_SHADER);
  fragmentShaderID := glCreateShader(GL_FRAGMENT_SHADER);

  glShaderSource (vertexShaderID, 1, @simpleVertexShader, nil);
  glCompileShader(vertexShaderID);
  glGetShaderiv  (vertexShaderID, GL_COMPILE_STATUS, @resGL);
  glGetShaderiv  (vertexShaderID, GL_INFO_LOG_LENGTH, @infoLogLength);
  if resGL = 0 then begin
    writeln('initRenderGl glCompileShader Vertex Error');
    result := false;
    exit;
  end;

  glShaderSource (fragmentShaderID, 1, @simpleFragmentShaderColor, nil);
  glCompileShader(fragmentShaderID);
  glGetShaderiv  (fragmentShaderID, GL_COMPILE_STATUS, @resGL);
  glGetShaderiv  (fragmentShaderID, GL_INFO_LOG_LENGTH, @infoLogLength);
  if resGL = 0 then begin
    writeln('initRenderGl glCompileShader Fragment Error');
    result := false;
    exit;
  end;

  programID := glCreateProgram();
  glAttachShader (programID, vertexShaderID);
  glAttachShader (programID, fragmentShaderID);
  glLinkProgram  (programID);
  glGetProgramiv (programID, GL_LINK_STATUS, @resGL);
  glGetProgramiv (programID, GL_INFO_LOG_LENGTH, @infoLogLength);
  if resGL = 0 then begin
    writeln('initRenderGl glGetProgramiv Error');
    result := false;
    exit;
  end;

  glDeleteShader(vertexShaderID);
  glDeleteShader(fragmentShaderID);

  glUseProgram(programID);

  posID       := glGetUniformLocation(programID, 'position');
  projmatID   := glGetUniformLocation(programID, 'projmat');
  posatribID  := glGetAttribLocation (programID, 'a_position');
  coloratribID  := glGetAttribLocation (programID, 'a_color');

  glEnableVertexAttribArray(posatribID);
  glEnableVertexAttribArray(coloratribID);

  glGenBuffers(1, @vertexBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(vertexCube), @vertexCube[0], GL_STATIC_DRAW);

  glGenBuffers(1, @colorBuffer);
  glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);
  glBufferData(GL_ARRAY_BUFFER, sizeof(colorCube), @colorCube[0], GL_STATIC_DRAW);

  MatProjection := TMatrix4x4.Create;
  MatModelView  := TMatrix4x4.Create;

  TimerFPS := TTimerWin.Create(1000);
  TimerFPS.SetProcTimer(@printFPS);
  TimerFPS.TimerOn;

  result := true;
end;

procedure renderGlFrame(
  view: TXrView;
  image: TXrSwapchainImageOpenGLKHR;
  depthImage: TXrSwapchainImageOpenGLKHR;
  frameBuffer: GLuint;
  width: GLuint;
  height: GLuint
  );
var
  orient : TXrQuaternionf;
  pos : TXrVector3f;
begin
  orient := view.pose.orientation;
  pos := view.pose.position;

  glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);

  glViewport(0, 0, width, height);
  glScissor(0, 0, width, height);

  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, image.image, 0);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthImage.image, 0);

  matProjectionForXr(view.fov);


  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glUniformMatrix4fv(projmatID, 1, GL_FALSE, MatProjection.GetMatrix);


  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);

  glVertexAttribPointer(
    posatribID,
    3,
    GL_FLOAT,
    GL_FALSE,
    3*sizeof(GLfloat),
    GLvoid(0));

  glBindBuffer(GL_ARRAY_BUFFER, colorBuffer);

  glVertexAttribPointer(
    coloratribID,
    3,
    GL_FLOAT,
    GL_FALSE,
    0,
    GLvoid(0));

  MatModelView.Null;

  MatModelView.RotateQuat(orient.x, orient.y, orient.z, orient.w);
  MatModelView.Translate(-pos.x,
                         -pos.y + 0.5,
                         -pos.z - 1.0);

  glUniformMatrix4fv(posID, 1, GL_TRUE, MatModelView.GetMatrix);
  glDrawArrays(GL_TRIANGLES, 0, 12*3);

  inc(fps_redraw);

  glBindFramebuffer(GL_FRAMEBUFFER, 0);
end;

end.

