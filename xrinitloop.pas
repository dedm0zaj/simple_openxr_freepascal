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

unit XrInitLoop;

{$mode objfpc}{$H+}

interface

uses
  Windows,
  openxr,
  openxr_platform,
  dglopengl;

const
  EYE_COUNT = 2;

type
  ArrXrSwapchainImageOpenGLKHR = array of TXrSwapchainImageOpenGLKHR;
  TwoArrXrSwapchainImageOpenGLKHR = array[0..EYE_COUNT-1] of ArrXrSwapchainImageOpenGLKHR;

  ArrGLuint = array of GLuint;
  ArrArrGLuint = array of ArrGLuint;

  TSwapchain = record
    swapchainXr: XrSwapchain;
    format : int64_t;
    width: uint32_t;
    height: uint32_t;
  end;

  ArrSwapchain = array[0..1] of TSwapchain;

  TXrDataInit = record
    instance: XrInstance;
    systemID: XrSystemId;
  end;

  TXrDataPostInit = record
    session : XrSession;
    swapchains : ArrSwapchain;
    swapchainImages : TwoArrXrSwapchainImageOpenGLKHR;
    swapchainsDepth : ArrSwapchain;
    swapchainsDepthImages : TwoArrXrSwapchainImageOpenGLKHR;
    frameBuffers : ArrArrGLuint;
    space : XrSpace;
  end;

  ProcRenderGl = procedure(
    view: TXrView;
    image: TXrSwapchainImageOpenGLKHR;
    depthImage: TXrSwapchainImageOpenGLKHR;
    frameBuffer: GLuint;
    width: GLuint;
    height: GLuint
    );

  function initXr(): TXrDataInit;
  function postInitXr(xrDataInit: TXrDataInit; dc: HDC; hrc: HGLRC): TXrDataPostInit;
procedure loopXr(xrDataInit: TXrDataInit; xrDataPostInit: TXrDataPostInit);
procedure xrSetProcRenderGl(proc: ProcRenderGl);

implementation

var
  renderGl : ProcRenderGl;
  quitLoop : boolean;
  runningLoop : boolean;

procedure xrSetProcRenderGl(proc: ProcRenderGl);
begin
  renderGl := proc;
end;

function getXRFunction(instance: XrInstance; name: PAnsiChar): PFN_xrVoidFunction;
var
  func : PFN_xrVoidFunction;
  resultXr : XrResult;
begin
  resultXr := xrGetInstanceProcAddr(instance, name, @func);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to load OpenXR extension function   ', name, ': ', resultXr);
    exit(nil);
  end;

  result := func;
end;

function handleXRError(
    severity: XrDebugUtilsMessageSeverityFlagsEXT;
    type_: XrDebugUtilsMessageTypeFlagsEXT;
    callbackData: PXrDebugUtilsMessengerCallbackDataEXT;
    userData: Pointer): XrBool32;
var
  error : String;
begin
  error := 'OpenXR ';

  case type_ of
    XR_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT:
      error += 'general ';
    XR_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT:
      error += 'validation ';
    XR_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT:
      error += 'performance ';
    XR_DEBUG_UTILS_MESSAGE_TYPE_CONFORMANCE_BIT_EXT:
      error += 'conformance ';
  end;

  case severity of
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT:
      error += '(verbose): ';
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT:
      error += '(info): ';
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT:
      error += '(warning): ';
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT:
      error += '(error): ';
  end;

    error += callbackData^.message;

    writeln(error);

    result := XR_FALSE;
end;

function createXrInstance() : XrInstance;
const
  APPLICATION_NAME = 'OpenXR Example';
  MAJOR_VERSION = 0;
  MINOR_VERSION = 1;
  PATCH_VERSION = 0;
  LAYER_NAMES : array of PAnsiChar = ('XR_APILAYER_LUNARG_core_validation');
  EXTENSION_NAMES : array of PAnsiChar = ('XR_KHR_opengl_enable',
                                          'XR_EXT_debug_utils',
                                          'XR_KHR_composition_layer_depth'
                                          );
  EMPTY_ARRAY : array of PAnsiChar = ();
var
  resultXr : XrResult;
  instance : XrInstance;
  instanceCreateInfo : TXrInstanceCreateInfo;
begin
  initOpenXr();

  instanceCreateInfo.type_ := XR_TYPE_INSTANCE_CREATE_INFO;
  instanceCreateInfo.next := nil;
  instanceCreateInfo.createFlags := 0;
  instanceCreateInfo.applicationInfo.applicationName := APPLICATION_NAME;
  instanceCreateInfo.applicationInfo.engineName := APPLICATION_NAME;

  instanceCreateInfo.applicationInfo.applicationVersion := 1;
  instanceCreateInfo.applicationInfo.engineVersion := 0;
  instanceCreateInfo.applicationInfo.apiVersion := xrMakeVersion(1, 0, 26);

  instanceCreateInfo.enabledApiLayerCount := length(EMPTY_ARRAY);
  instanceCreateInfo.enabledApiLayerNames := EMPTY_ARRAY;
  instanceCreateInfo.enabledExtensionCount := length(EXTENSION_NAMES);
  instanceCreateInfo.enabledExtensionNames := EXTENSION_NAMES;

  instance := 0;
  resultXr := xrCreateInstance(@instanceCreateInfo, @instance);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to create OpenXR instance   ', resultXr);
    exit(XR_NULL_HANDLE);
  end;

  result := instance;
end;

procedure destroyInstance(instance: XrInstance);
begin
  xrDestroyInstance(instance);
end;

function createDebugMessenger(instance: XrInstance): XrDebugUtilsMessengerEXT;
var
  debugMessenger : XrDebugUtilsMessengerEXT;
  debugMessengerCreateInfo : TXrDebugUtilsMessengerCreateInfoEXT;
  xrCreateDebugUtilsMessengerEXT : PFN_xrCreateDebugUtilsMessengerEXT;
  resultXr : XrResult;
begin
  debugMessengerCreateInfo.type_ := XR_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
  debugMessengerCreateInfo.messageSeverities :=
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT or
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT or
    XR_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
  debugMessengerCreateInfo.messageTypes :=
    XR_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT or
    XR_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT or
    XR_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT or
    XR_DEBUG_UTILS_MESSAGE_TYPE_CONFORMANCE_BIT_EXT;
  debugMessengerCreateInfo.userCallback := @handleXRError;
  debugMessengerCreateInfo.userData := nil;

  xrCreateDebugUtilsMessengerEXT := PFN_xrCreateDebugUtilsMessengerEXT(
    getXRFunction(instance, 'xrCreateDebugUtilsMessengerEXT'));

  resultXr := xrCreateDebugUtilsMessengerEXT(
    instance,
    @debugMessengerCreateInfo,
    @debugMessenger);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to create OpenXR debug messenger   ', resultXr);
    exit(XR_NULL_HANDLE);
  end;

  result := debugMessenger;
end;

procedure destroyDebugMessenger(instance: XrInstance; debugMessenger: XrDebugUtilsMessengerEXT);
var
  xrDestroyDebugUtilsMessengerEXT : PFN_xrDestroyDebugUtilsMessengerEXT;
begin
  xrDestroyDebugUtilsMessengerEXT := PFN_xrDestroyDebugUtilsMessengerEXT(
    getXRFunction(instance, 'xrDestroyDebugUtilsMessengerEXT'));

  xrDestroyDebugUtilsMessengerEXT(debugMessenger);
end;

function getSystem(instance: XrInstance): XrSystemId;
var
  systemID : XrSystemId;
  systemGetInfo : TXrSystemGetInfo;
  resultXr : XrResult;
begin
  systemGetInfo.type_ := XR_TYPE_SYSTEM_GET_INFO;
  systemGetInfo.formFactor := XR_FORM_FACTOR_HEAD_MOUNTED_DISPLAY;

  resultXr := xrGetSystem(instance, @systemGetInfo, @systemID);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to get system:   ', resultXr);
    exit(XR_NULL_SYSTEM_ID);
  end;

  result := systemID;
end;

function getOpenGLInstanceRequirements(instance: XrInstance;
    system: XrSystemId) : PXrGraphicsRequirementsOpenGLKHR;
var
  xrGetOpenGLGraphicsRequirementsKHR : PFN_xrGetOpenGLGraphicsRequirementsKHR;
  resultXr : XrResult;
  graphicsRequirements : TXrGraphicsRequirementsOpenGLKHR;
begin
  xrGetOpenGLGraphicsRequirementsKHR := PFN_xrGetOpenGLGraphicsRequirementsKHR(
    getXRFunction(instance, 'xrGetOpenGLGraphicsRequirementsKHR'));

  graphicsRequirements.type_ := XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_KHR;

  resultXr := xrGetOpenGLGraphicsRequirementsKHR(
    instance,
    system,
    @graphicsRequirements);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to get OpenGL instance requirements:   ', resultXr);
    exit(nil);
  end;

  result := @graphicsRequirements;
end;

function createSessionXr(
  instance: XrInstance;
  systemID: XrSystemId;
  dc: HDC;
  hrc: HGLRC
  ): XrSession;
var
  session : XrSession;
  graphicsBinding : TXrGraphicsBindingOpenGLWin32KHR;
  sessionCreateInfo : TXrSessionCreateInfo;
  resultXr : XrResult;
begin
  graphicsBinding.type_ := XR_TYPE_GRAPHICS_BINDING_OPENGL_WIN32_KHR;
  graphicsBinding.hDC := dc;
  graphicsBinding.hGLRC := hrc;

  sessionCreateInfo.type_ := XR_TYPE_SESSION_CREATE_INFO;
  sessionCreateInfo.next := @graphicsBinding;
  sessionCreateInfo.createFlags := 0;
  sessionCreateInfo.systemId := systemID;

  resultXr := xrCreateSession(instance, @sessionCreateInfo, @session);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to create OpenXR session:   ', resultXr);
    exit(XR_NULL_HANDLE);
  end;

  result := session;
end;

procedure destroySession(session: XrSession);
begin
  xrDestroySession(session);
end;

function createSwapchains(
  instance: XrInstance;
  system: XrSystemId;
  session: XrSession
  ): ArrSwapchain;
var
  swapchains : ArrSwapchain;
  configViewsCount : uint32_t = EYE_COUNT;
  configViews : array[0..EYE_COUNT-1] of TXrViewConfigurationView;
  resultXr : XrResult;
  formatCount : uint32_t = 0;
  formats : array of int64_t;
  format : int64_t;
  chosenFormat : int64_t;
  swapchainsXr : array[0..EYE_COUNT-1] of XrSwapchain;
  i : uint32_t;
  swapchainCreateInfo : TXrSwapchainCreateInfo;
begin
  configViews[0].type_ := XR_TYPE_VIEW_CONFIGURATION_VIEW;
  configViews[1].type_ := XR_TYPE_VIEW_CONFIGURATION_VIEW;

  resultXr := xrEnumerateViewConfigurationViews(
    instance,
    system,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO,
    configViewsCount,
    @configViewsCount,
    @configViews[0]);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate view configuration views:   ', resultXr);
    exit(swapchains);
  end;

  resultXr := xrEnumerateSwapchainFormats(session, 0, @formatCount, nil);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain formats:   ', resultXr);
    exit(swapchains);
  end;

  SetLength(formats, formatCount);

  resultXr := xrEnumerateSwapchainFormats(session, formatCount, @formatCount, @formats[0]);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain formats:   ', resultXr);
    exit(swapchains);
  end;

  chosenFormat := formats[0];

  for format in formats do begin
    if format = GL_SRGB8_ALPHA8 then begin
      chosenFormat := format;
      break;
    end;
  end;

  for i := 0 to EYE_COUNT-1 do begin
    swapchainCreateInfo.type_ := XR_TYPE_SWAPCHAIN_CREATE_INFO;
    swapchainCreateInfo.usageFlags :=
      XR_SWAPCHAIN_USAGE_SAMPLED_BIT or XR_SWAPCHAIN_USAGE_COLOR_ATTACHMENT_BIT;
    swapchainCreateInfo.format := chosenFormat;
    swapchainCreateInfo.sampleCount := configViews[i].recommendedSwapchainSampleCount;
    swapchainCreateInfo.width := configViews[i].recommendedImageRectWidth;
    swapchainCreateInfo.height := configViews[i].recommendedImageRectHeight;
    swapchainCreateInfo.faceCount := 1;
    swapchainCreateInfo.arraySize := 1;
    swapchainCreateInfo.mipCount := 1;

    resultXr := xrCreateSwapchain(session, @swapchainCreateInfo, @swapchainsXr[i]);

    if resultXr <> XR_SUCCESS then begin
      writeln('Failed to create swapchain:   ', resultXr);
      exit(swapchains);
    end;
  end;

  swapchains[0].swapchainXr := swapchainsXr[0];
  swapchains[0].format := chosenFormat;
  swapchains[0].width := configViews[0].recommendedImageRectWidth;
  swapchains[0].height := configViews[0].recommendedImageRectHeight;

  swapchains[1].swapchainXr := swapchainsXr[1];
  swapchains[1].format := chosenFormat;
  swapchains[1].width := configViews[1].recommendedImageRectWidth;
  swapchains[1].height := configViews[1].recommendedImageRectHeight;

  result := swapchains;
end;

function createSwapchainsDepth(
  instance: XrInstance;
  system: XrSystemId;
  session: XrSession
  ): ArrSwapchain;
var
  swapchains : ArrSwapchain;
  configViewsCount : uint32_t = EYE_COUNT;
  configViews : array[0..EYE_COUNT-1] of TXrViewConfigurationView;
  resultXr : XrResult;
  formatCount : uint32_t = 0;
  formats : array of int64_t;
  format : int64_t;
  chosenFormat : int64_t;
  swapchainsXr : array[0..EYE_COUNT-1] of XrSwapchain;
  i : uint32_t;
  swapchainCreateInfo : TXrSwapchainCreateInfo;
begin
  configViews[0].type_ := XR_TYPE_VIEW_CONFIGURATION_VIEW;
  configViews[1].type_ := XR_TYPE_VIEW_CONFIGURATION_VIEW;

  resultXr := xrEnumerateViewConfigurationViews(
    instance,
    system,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO,
    configViewsCount,
    @configViewsCount,
    @configViews[0]);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate view configuration views:   ', resultXr);
    exit(swapchains);
  end;

  resultXr := xrEnumerateSwapchainFormats(session, 0, @formatCount, nil);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain formats:   ', resultXr);
    exit(swapchains);
  end;

  SetLength(formats, formatCount);

  resultXr := xrEnumerateSwapchainFormats(session, formatCount, @formatCount, @formats[0]);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain formats:   ', resultXr);
    exit(swapchains);
  end;

  chosenFormat := formats[0];

  for format in formats do begin
    if format = GL_DEPTH_COMPONENT32F then begin
      chosenFormat := format;
      break;
    end;
  end;

  for i := 0 to EYE_COUNT-1 do begin
    swapchainCreateInfo.type_ := XR_TYPE_SWAPCHAIN_CREATE_INFO;
    swapchainCreateInfo.usageFlags := XR_SWAPCHAIN_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;
    swapchainCreateInfo.format := chosenFormat;
    swapchainCreateInfo.sampleCount := configViews[i].recommendedSwapchainSampleCount;
    swapchainCreateInfo.width := configViews[i].recommendedImageRectWidth;
    swapchainCreateInfo.height := configViews[i].recommendedImageRectHeight;
    swapchainCreateInfo.faceCount := 1;
    swapchainCreateInfo.arraySize := 1;
    swapchainCreateInfo.mipCount := 1;

    resultXr := xrCreateSwapchain(session, @swapchainCreateInfo, @swapchainsXr[i]);

    if resultXr <> XR_SUCCESS then begin
      writeln('Failed to create swapchain:   ', resultXr);
      exit(swapchains);
    end;
  end;

  swapchains[0].swapchainXr := swapchainsXr[0];
  swapchains[0].format := chosenFormat;
  swapchains[0].width := configViews[0].recommendedImageRectWidth;
  swapchains[0].height := configViews[0].recommendedImageRectHeight;

  swapchains[1].swapchainXr := swapchainsXr[1];
  swapchains[1].format := chosenFormat;
  swapchains[1].width := configViews[1].recommendedImageRectWidth;
  swapchains[1].height := configViews[1].recommendedImageRectHeight;

  result := swapchains;
end;

function getSwapchainImages(swapchain: XrSwapchain): ArrXrSwapchainImageOpenGLKHR;
var
  images : ArrXrSwapchainImageOpenGLKHR;
  i : uint32_t;
  imageCount : uint32_t;
  resultXr : XrResult;
begin
  resultXr := xrEnumerateSwapchainImages(swapchain, 0, @imageCount, nil);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain images:   ', resultXr);
    SetLength(images, 0);
    exit(images);
  end;

  SetLength(images, imageCount);
  for i := 0 to imageCount-1 do
    images[i].type_ := XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_KHR;

  resultXr := xrEnumerateSwapchainImages(
    swapchain,
    imageCount,
    @imageCount,
    PXrSwapchainImageBaseHeader(@images[0]));

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to enumerate swapchain images:   ', resultXr);
    SetLength(images, 0);
    exit(images);
  end;

  result := images;
end;

function createSpace(session: XrSession): XrSpace;
var
  space : XrSpace;
  spaceCreateInfo : TXrReferenceSpaceCreateInfo;
  resultXr : XrResult;
begin
  spaceCreateInfo.type_ := XR_TYPE_REFERENCE_SPACE_CREATE_INFO;
  spaceCreateInfo.referenceSpaceType := XR_REFERENCE_SPACE_TYPE_STAGE;
  spaceCreateInfo.poseInReferenceSpace.orientation.x := 0;
  spaceCreateInfo.poseInReferenceSpace.orientation.y := 0;
  spaceCreateInfo.poseInReferenceSpace.orientation.z := 0;
  spaceCreateInfo.poseInReferenceSpace.orientation.w := 1;
  spaceCreateInfo.poseInReferenceSpace.position.x := 0;
  spaceCreateInfo.poseInReferenceSpace.position.y := 0;
  spaceCreateInfo.poseInReferenceSpace.position.z := 0;

  resultXr := xrCreateReferenceSpace(session, @spaceCreateInfo, @space);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to create space:   ', resultXr);
    exit(XR_NULL_HANDLE);
  end;

  result := space;
end;

procedure destroySpace(space: XrSpace);
begin
  xrDestroySpace(space);
end;

function renderEye(
  swapchain: TSwapchain;
  view: TXrView;
  images: ArrXrSwapchainImageOpenGLKHR;
  swapchainDepth: TSwapchain;
  depthImages: ArrXrSwapchainImageOpenGLKHR;
  frameBuffers: ArrGLuint
  ): boolean;
var
  acquireImageInfo : TXrSwapchainImageAcquireInfo;
  acquireDepthImageInfo : TXrSwapchainImageAcquireInfo;
  activeIndex : uint32_t;
  activeDepthIndex : uint32_t;
  resultXr : XrResult;
  waitImageInfo : TXrSwapchainImageWaitInfo;
  waitDepthImageInfo : TXrSwapchainImageWaitInfo;
  releaseImageInfo : TXrSwapchainImageReleaseInfo;
  releaseDepthImageInfo : TXrSwapchainImageReleaseInfo;
begin
  // image
  acquireImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_ACQUIRE_INFO;
  acquireImageInfo.next := nil;

  resultXr := xrAcquireSwapchainImage(swapchain.swapchainXr, @acquireImageInfo, @activeIndex);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to acquire swapchain image:   ', resultXr);
    exit(false);
  end;

  waitImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_WAIT_INFO;
  waitImageInfo.next := nil;
  waitImageInfo.timeout := high(int64_t);

  resultXr := xrWaitSwapchainImage(swapchain.swapchainXr, @waitImageInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to wait for swapchain image:   ', resultXr);
    exit(false);
  end;

  // depthImage
  acquireDepthImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_ACQUIRE_INFO;
  acquireDepthImageInfo.next := nil;

  resultXr := xrAcquireSwapchainImage(swapchainDepth.swapchainXr, @acquireDepthImageInfo, @activeDepthIndex);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to acquire swapchain deepthImage:   ', resultXr);
    exit(false);
  end;

  waitDepthImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_WAIT_INFO;
  waitDepthImageInfo.next := nil;
  waitDepthImageInfo.timeout := high(int64_t);

  resultXr := xrWaitSwapchainImage(swapchainDepth.swapchainXr, @waitDepthImageInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to wait for swapchain depthImage:   ', resultXr);
    exit(false);
  end;

  /////////////////// RENDER ///////////////////////
  renderGl(
    view,
    images[activeIndex],
    depthImages[activeDepthIndex],
    frameBuffers[activeIndex],
    swapchain.width,
    swapchain.height);

  // image
  releaseImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_RELEASE_INFO;
  releaseImageInfo.next := nil;

  resultXr := xrReleaseSwapchainImage(swapchain.swapchainXr, @releaseImageInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to release swapchain image:   ', resultXr);
    exit(false);
  end;

  // depthImage
  releaseDepthImageInfo.type_ := XR_TYPE_SWAPCHAIN_IMAGE_RELEASE_INFO;
  releaseDepthImageInfo.next := nil;

  resultXr := xrReleaseSwapchainImage(swapchainDepth.swapchainXr, @releaseDepthImageInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to release swapchain depthImage:   ', resultXr);
    exit(false);
  end;

  result := true;
end;

function render(
  session: XrSession;
  swapchains: ArrSwapchain;
  images: TwoArrXrSwapchainImageOpenGLKHR;
  swapchainsDepth: ArrSwapchain;
  depthImages: TwoArrXrSwapchainImageOpenGLKHR;
  frameBuffers: ArrArrGLuint;
  space: XrSpace;
  predictedDisplayTime: XrTime
  ): boolean;
var
  beginFrameInfo : TXrFrameBeginInfo;
  resultXr : XrResult;
  viewLocateInfo : TXrViewLocateInfo;
  viewState : TXrViewState;
  viewCount : uint32_t = EYE_COUNT;
  views : array[0..EYE_COUNT-1] of TXrView;
  i : NativeUInt;
  projectedViews : array[0..EYE_COUNT-1] of TXrCompositionLayerProjectionView;
  layer : TXrCompositionLayerProjection;
  pLayer : PXrCompositionLayerBaseHeader;
  endFrameInfo : TXrFrameEndInfo;
begin
  beginFrameInfo.type_ := XR_TYPE_FRAME_BEGIN_INFO;

  resultXr := xrBeginFrame(session, @beginFrameInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to begin frame:   ', resultXr);
    exit(false);
  end;

  viewLocateInfo.type_ := XR_TYPE_VIEW_LOCATE_INFO;
  viewLocateInfo.viewConfigurationType := XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO;
  viewLocateInfo.displayTime := predictedDisplayTime;
  viewLocateInfo.space := space;

  viewState.type_ := XR_TYPE_VIEW_STATE;

  views[0].type_ := XR_TYPE_VIEW;
  views[1].type_ := XR_TYPE_VIEW;

  resultXr := xrLocateViews(
    session,
    @viewLocateInfo,
    @viewState,
    viewCount,
    @viewCount,
    @views[0]);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to locate views:   ', resultXr);
    exit(false);
  end;

  for i := 0 to EYE_COUNT-1 do begin
    renderEye(
      swapchains[i],
      views[i],
      images[i],
      swapchainsDepth[i],
      depthImages[i],
      frameBuffers[i]);
  end;

  for i := 0 to EYE_COUNT-1 do begin
    projectedViews[i].type_ := XR_TYPE_COMPOSITION_LAYER_PROJECTION_VIEW;
    projectedViews[i].pose := views[i].pose;
    projectedViews[i].fov := views[i].fov;
    projectedViews[i].subImage.swapchain := swapchains[i].swapchainXr;
    projectedViews[i].subImage.imageRect.offset.x := 0;
    projectedViews[i].subImage.imageRect.offset.y := 0;
    projectedViews[i].subImage.imageRect.extent.width := int32_t(swapchains[i].width);
    projectedViews[i].subImage.imageRect.extent.height := int32_t(swapchains[i].height);
    projectedViews[i].subImage.imageArrayIndex := 0;
  end;

  layer.type_ := XR_TYPE_COMPOSITION_LAYER_PROJECTION;
  layer.space := space;
  layer.viewCount := EYE_COUNT;
  layer.views := projectedViews;

  pLayer := PXrCompositionLayerBaseHeader(@layer);

  endFrameInfo.type_ := XR_TYPE_FRAME_END_INFO;
  endFrameInfo.displayTime := predictedDisplayTime;
  endFrameInfo.environmentBlendMode := XR_ENVIRONMENT_BLEND_MODE_OPAQUE;
  endFrameInfo.layerCount := 1;
  endFrameInfo.layers := @pLayer;

  resultXr := xrEndFrame(session, @endFrameInfo);

  if resultXr <> XR_SUCCESS then begin
    writeln('Failed to end frame:   ', resultXr);
    exit(false);
  end;

  result := true;
end;

function initXr(): TXrDataInit;
var
  instance: XrInstance;
  systemID: XrSystemId;
  debugMessenger : XrDebugUtilsMessengerEXT;
  graphicsRequirements : PXrGraphicsRequirementsOpenGLKHR;
  xrDataInit : TXrDataInit;
begin
  instance := createXrInstance();
  debugMessenger := createDebugMessenger(instance);
  systemID := getSystem(instance);
  graphicsRequirements := getOpenGLInstanceRequirements(
    instance,
    systemID);

  xrDataInit.instance := instance;
  xrDataInit.systemID := systemID;

  result := xrDataInit;
end;

function postInitXr(xrDataInit: TXrDataInit; dc: HDC; hrc: HGLRC): TXrDataPostInit;
var
  i : NativeUInt;
  session : XrSession;
  swapchains : ArrSwapchain;
  swapchainImages : TwoArrXrSwapchainImageOpenGLKHR;
  swapchainsDepth : ArrSwapchain;
  swapchainsDepthImages : TwoArrXrSwapchainImageOpenGLKHR;
  frameBuffers : ArrArrGLuint;
  space : XrSpace;
  xrDataPostInit : TXrDataPostInit;
begin
  session := createSessionXr(xrDataInit.instance, xrDataInit.systemID, dc, hrc);

  swapchains := createSwapchains(xrDataInit.instance, xrDataInit.systemID, session);
  for i := 0 to EYE_COUNT-1 do
    swapchainImages[i] := getSwapchainImages(swapchains[i].swapchainXr);

  swapchainsDepth := createSwapchainsDepth(xrDataInit.instance, xrDataInit.systemID, session);
  for i := 0 to EYE_COUNT-1 do
    swapchainsDepthImages[i] := getSwapchainImages(swapchainsDepth[i].swapchainXr);

  SetLength(frameBuffers, EYE_COUNT);
  for i := 0 to EYE_COUNT-1 do begin
    SetLength(frameBuffers[i], Length(swapchainImages[i]));
    glGenFramebuffers(Length(frameBuffers[i]), @framebuffers[i][0]);
  end;

  space := createSpace(session);

  quitLoop := false;
  runningLoop := true;

  xrDataPostInit.session := session;
  xrDataPostInit.swapchains := swapchains;
  xrDataPostInit.swapchainImages := swapchainImages;
  xrDataPostInit.swapchainsDepth := swapchainsDepth;
  xrDataPostInit.swapchainsDepthImages := swapchainsDepthImages;
  xrDataPostInit.frameBuffers := frameBuffers;
  xrDataPostInit.space := space;

  result := xrDataPostInit;
end;

procedure loopXr(xrDataInit: TXrDataInit; xrDataPostInit: TXrDataPostInit);
var
  eventData : TXrEventDataBuffer;
  resultXr : XrResult;
  event : PXrEventDataSessionStateChanged;
  sessionBeginInfo : TXrSessionBeginInfo;
  frameWaitInfo : TXrFrameWaitInfo;
  frameState : TXrFrameState;
begin
  if not quitLoop then begin
    eventData.type_ := XR_TYPE_EVENT_DATA_BUFFER;

    resultXr := xrPollEvent(xrDataInit.instance, @eventData);

    if resultXr = XR_EVENT_UNAVAILABLE then begin
      if runningLoop then begin
        frameWaitInfo.type_ := XR_TYPE_FRAME_WAIT_INFO;
        frameState.type_ := XR_TYPE_FRAME_STATE;

        resultXr := xrWaitFrame(xrDataPostInit.session, @frameWaitInfo, @frameState);

        if resultXr <> XR_SUCCESS then begin
          writeln('Failed to wait for frame:   ', resultXr);
          exit;
        end;

        if frameState.shouldRender = 0 then
          exit;

        quitLoop := not render(
          xrDataPostInit.session,
          xrDataPostInit.swapchains,
          xrDataPostInit.swapchainImages,
          xrDataPostInit.swapchainsDepth,
          xrDataPostInit.swapchainsDepthImages,
          xrDataPostInit.frameBuffers,
          xrDataPostInit.space,
          frameState.predictedDisplayTime);
      end;
    end
    else if resultXr <> XR_SUCCESS then begin
      writeln('Failed to poll events:   ', resultXr);
      exit;
    end
    else begin
      case eventData.type_ of
        XR_TYPE_EVENT_DATA_EVENTS_LOST:
          writeln('Event queue overflowed and events were lost');
        XR_TYPE_EVENT_DATA_INSTANCE_LOSS_PENDING: begin
          writeln('OpenXR instance is shutting down');
          quitLoop := true;
        end;
        XR_TYPE_EVENT_DATA_INTERACTION_PROFILE_CHANGED:
          writeln('The interaction profile has changed');
        XR_TYPE_EVENT_DATA_REFERENCE_SPACE_CHANGE_PENDING:
          writeln('The reference space is changing');
        XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED: begin
          event := PXrEventDataSessionStateChanged(@eventData);
          case event^.state of
            XR_SESSION_STATE_UNKNOWN,
            XR_SESSION_STATE_MAX_ENUM:
              writeln('Unknown session state entered:   ', event^.state);
            XR_SESSION_STATE_IDLE:
              runningLoop := false;
            XR_SESSION_STATE_READY: begin
              sessionBeginInfo.type_ := XR_TYPE_SESSION_BEGIN_INFO;
              sessionBeginInfo.primaryViewConfigurationType := XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO;

              resultXr := xrBeginSession(xrDataPostInit.session, @sessionBeginInfo);

              if resultXr <> XR_SUCCESS then
                writeln('Failed to begin session:   ', resultXr);

              runningLoop := true;
            end;
            XR_SESSION_STATE_SYNCHRONIZED,
            XR_SESSION_STATE_VISIBLE,
            XR_SESSION_STATE_FOCUSED:
              runningLoop := true;
            XR_SESSION_STATE_STOPPING: begin
              runningLoop := false;

              resultXr := xrEndSession(xrDataPostInit.session);

              if resultXr <> XR_SUCCESS then
                writeln('Failed to end session:   ', resultXr);
            end;
            XR_SESSION_STATE_LOSS_PENDING: begin
              writeln('OpenXR session is shutting down');
              quitLoop := true;
            end;
            XR_SESSION_STATE_EXITING: begin
              writeln('OpenXR runtime requested shutdown');
              quitLoop := true;
            end;
          end; // case event.state
        end; // XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED
      end; // case eventData.type_
    end; // if resultXr
  end; // if not quitLoop
end;

end.

