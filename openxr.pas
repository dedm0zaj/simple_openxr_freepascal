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

unit openxr;

{$mode objfpc}{$H+}

interface

const
  XR_TRUE = 1;
  XR_FALSE = 0;
  XR_PTR_SIZE = 8;
  XR_NULL_HANDLE = 0;
  XR_NULL_SYSTEM_ID = 0;
  XR_MAX_APPLICATION_NAME_SIZE = 128;
  XR_MAX_ENGINE_NAME_SIZE = 128;

  // Flag bits for XrSwapchainUsageFlags
  XR_SWAPCHAIN_USAGE_COLOR_ATTACHMENT_BIT = $00000001;
  XR_SWAPCHAIN_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT = $00000002;
  XR_SWAPCHAIN_USAGE_UNORDERED_ACCESS_BIT = $00000004;
  XR_SWAPCHAIN_USAGE_TRANSFER_SRC_BIT = $00000008;
  XR_SWAPCHAIN_USAGE_TRANSFER_DST_BIT = $00000010;
  XR_SWAPCHAIN_USAGE_SAMPLED_BIT = $00000020;
  XR_SWAPCHAIN_USAGE_MUTABLE_FORMAT_BIT = $00000040;
  XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_MND = $00000080;
  XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_KHR = $00000080;  // alias of XR_SWAPCHAIN_USAGE_INPUT_ATTACHMENT_BIT_MND

type
  uint8_t = UInt8;
  uint16_t = UInt16;
  int32_t = Int32;
  uint32_t = UInt32;
  puint32_t = ^uint32_t;
  int64_t = Int64;
  pint64_t = ^int64_t;
  uint64_t = UInt64;

  XrVersion = uint64_t;
  XrFlags64 = uint64_t;
  XrBool32 = uint32_t;
  XrTime = int64_t;
  XrDuration = int64_t;
  XrInstanceCreateFlags = XrFlags64;
  XrSystemId = uint64_t;
  PXrSystemId = ^XrSystemId;
  XrInstance = uint64_t;
  PXrInstance = ^XrInstance;
  XrSession = uint64_t;
  PXrSession = ^XrSession;
  XrSpace = uint64_t;
  PXrSpace = ^XrSpace;
  XrSwapchain = uint64_t;
  PXrSwapchain = ^XrSwapchain;
  XrDebugUtilsMessengerEXT = uint64_t;
  PXrDebugUtilsMessengerEXT = ^XrDebugUtilsMessengerEXT;
  XrSessionCreateFlags = XrFlags64;
  XrSwapchainCreateFlags = XrFlags64;
  XrSwapchainUsageFlags = XrFlags64;
  XrViewStateFlags = XrFlags64;
  XrCompositionLayerFlags = XrFlags64;

  //PFN_xrVoidFunction = procedure();
  PFN_xrVoidFunction = Pointer;

  XrResult = (
    XR_SUCCESS = 0,
    XR_TIMEOUT_EXPIRED = 1,
    XR_SESSION_LOSS_PENDING = 3,
    XR_EVENT_UNAVAILABLE = 4,
    XR_SPACE_BOUNDS_UNAVAILABLE = 7,
    XR_SESSION_NOT_FOCUSED = 8,
    XR_FRAME_DISCARDED = 9,
    XR_ERROR_VALIDATION_FAILURE = -1,
    XR_ERROR_RUNTIME_FAILURE = -2,
    XR_ERROR_OUT_OF_MEMORY = -3,
    XR_ERROR_API_VERSION_UNSUPPORTED = -4,
    XR_ERROR_INITIALIZATION_FAILED = -6,
    XR_ERROR_FUNCTION_UNSUPPORTED = -7,
    XR_ERROR_FEATURE_UNSUPPORTED = -8,
    XR_ERROR_EXTENSION_NOT_PRESENT = -9,
    XR_ERROR_LIMIT_REACHED = -10,
    XR_ERROR_SIZE_INSUFFICIENT = -11,
    XR_ERROR_HANDLE_INVALID = -12,
    XR_ERROR_INSTANCE_LOST = -13,
    XR_ERROR_SESSION_RUNNING = -14,
    XR_ERROR_SESSION_NOT_RUNNING = -16,
    XR_ERROR_SESSION_LOST = -17,
    XR_ERROR_SYSTEM_INVALID = -18,
    XR_ERROR_PATH_INVALID = -19,
    XR_ERROR_PATH_COUNT_EXCEEDED = -20,
    XR_ERROR_PATH_FORMAT_INVALID = -21,
    XR_ERROR_PATH_UNSUPPORTED = -22,
    XR_ERROR_LAYER_INVALID = -23,
    XR_ERROR_LAYER_LIMIT_EXCEEDED = -24,
    XR_ERROR_SWAPCHAIN_RECT_INVALID = -25,
    XR_ERROR_SWAPCHAIN_FORMAT_UNSUPPORTED = -26,
    XR_ERROR_ACTION_TYPE_MISMATCH = -27,
    XR_ERROR_SESSION_NOT_READY = -28,
    XR_ERROR_SESSION_NOT_STOPPING = -29,
    XR_ERROR_TIME_INVALID = -30,
    XR_ERROR_REFERENCE_SPACE_UNSUPPORTED = -31,
    XR_ERROR_FILE_ACCESS_ERROR = -32,
    XR_ERROR_FILE_CONTENTS_INVALID = -33,
    XR_ERROR_FORM_FACTOR_UNSUPPORTED = -34,
    XR_ERROR_FORM_FACTOR_UNAVAILABLE = -35,
    XR_ERROR_API_LAYER_NOT_PRESENT = -36,
    XR_ERROR_CALL_ORDER_INVALID = -37,
    XR_ERROR_GRAPHICS_DEVICE_INVALID = -38,
    XR_ERROR_POSE_INVALID = -39,
    XR_ERROR_INDEX_OUT_OF_RANGE = -40,
    XR_ERROR_VIEW_CONFIGURATION_TYPE_UNSUPPORTED = -41,
    XR_ERROR_ENVIRONMENT_BLEND_MODE_UNSUPPORTED = -42,
    XR_ERROR_NAME_DUPLICATED = -44,
    XR_ERROR_NAME_INVALID = -45,
    XR_ERROR_ACTIONSET_NOT_ATTACHED = -46,
    XR_ERROR_ACTIONSETS_ALREADY_ATTACHED = -47,
    XR_ERROR_LOCALIZED_NAME_DUPLICATED = -48,
    XR_ERROR_LOCALIZED_NAME_INVALID = -49,
    XR_ERROR_GRAPHICS_REQUIREMENTS_CALL_MISSING = -50,
    XR_ERROR_RUNTIME_UNAVAILABLE = -51,
    XR_ERROR_ANDROID_THREAD_SETTINGS_ID_INVALID_KHR = -1000003000,
    XR_ERROR_ANDROID_THREAD_SETTINGS_FAILURE_KHR = -1000003001,
    XR_ERROR_CREATE_SPATIAL_ANCHOR_FAILED_MSFT = -1000039001,
    XR_ERROR_SECONDARY_VIEW_CONFIGURATION_TYPE_NOT_ENABLED_MSFT = -1000053000,
    XR_ERROR_CONTROLLER_MODEL_KEY_INVALID_MSFT = -1000055000,
    XR_ERROR_REPROJECTION_MODE_UNSUPPORTED_MSFT = -1000066000,
    XR_ERROR_COMPUTE_NEW_SCENE_NOT_COMPLETED_MSFT = -1000097000,
    XR_ERROR_SCENE_COMPONENT_ID_INVALID_MSFT = -1000097001,
    XR_ERROR_SCENE_COMPONENT_TYPE_MISMATCH_MSFT = -1000097002,
    XR_ERROR_SCENE_MESH_BUFFER_ID_INVALID_MSFT = -1000097003,
    XR_ERROR_SCENE_COMPUTE_FEATURE_INCOMPATIBLE_MSFT = -1000097004,
    XR_ERROR_SCENE_COMPUTE_CONSISTENCY_MISMATCH_MSFT = -1000097005,
    XR_ERROR_DISPLAY_REFRESH_RATE_UNSUPPORTED_FB = -1000101000,
    XR_ERROR_COLOR_SPACE_UNSUPPORTED_FB = -1000108000,
    XR_ERROR_SPACE_COMPONENT_NOT_SUPPORTED_FB = -1000113000,
    XR_ERROR_SPACE_COMPONENT_NOT_ENABLED_FB = -1000113001,
    XR_ERROR_SPACE_COMPONENT_STATUS_PENDING_FB = -1000113002,
    XR_ERROR_SPACE_COMPONENT_STATUS_ALREADY_SET_FB = -1000113003,
    XR_ERROR_UNEXPECTED_STATE_PASSTHROUGH_FB = -1000118000,
    XR_ERROR_FEATURE_ALREADY_CREATED_PASSTHROUGH_FB = -1000118001,
    XR_ERROR_FEATURE_REQUIRED_PASSTHROUGH_FB = -1000118002,
    XR_ERROR_NOT_PERMITTED_PASSTHROUGH_FB = -1000118003,
    XR_ERROR_INSUFFICIENT_RESOURCES_PASSTHROUGH_FB = -1000118004,
    XR_ERROR_UNKNOWN_PASSTHROUGH_FB = -1000118050,
    XR_ERROR_RENDER_MODEL_KEY_INVALID_FB = -1000119000,
    XR_RENDER_MODEL_UNAVAILABLE_FB = 1000119020,
    XR_ERROR_MARKER_NOT_TRACKED_VARJO = -1000124000,
    XR_ERROR_MARKER_ID_INVALID_VARJO = -1000124001,
    XR_ERROR_SPATIAL_ANCHOR_NAME_NOT_FOUND_MSFT = -1000142001,
    XR_ERROR_SPATIAL_ANCHOR_NAME_INVALID_MSFT = -1000142002,
    XR_RESULT_MAX_ENUM = $7FFFFFFF
  );

  XrStructureType = (
    XR_TYPE_UNKNOWN = 0,
    XR_TYPE_API_LAYER_PROPERTIES = 1,
    XR_TYPE_EXTENSION_PROPERTIES = 2,
    XR_TYPE_INSTANCE_CREATE_INFO = 3,
    XR_TYPE_SYSTEM_GET_INFO = 4,
    XR_TYPE_SYSTEM_PROPERTIES = 5,
    XR_TYPE_VIEW_LOCATE_INFO = 6,
    XR_TYPE_VIEW = 7,
    XR_TYPE_SESSION_CREATE_INFO = 8,
    XR_TYPE_SWAPCHAIN_CREATE_INFO = 9,
    XR_TYPE_SESSION_BEGIN_INFO = 10,
    XR_TYPE_VIEW_STATE = 11,
    XR_TYPE_FRAME_END_INFO = 12,
    XR_TYPE_HAPTIC_VIBRATION = 13,
    XR_TYPE_EVENT_DATA_BUFFER = 16,
    XR_TYPE_EVENT_DATA_INSTANCE_LOSS_PENDING = 17,
    XR_TYPE_EVENT_DATA_SESSION_STATE_CHANGED = 18,
    XR_TYPE_ACTION_STATE_BOOLEAN = 23,
    XR_TYPE_ACTION_STATE_FLOAT = 24,
    XR_TYPE_ACTION_STATE_VECTOR2F = 25,
    XR_TYPE_ACTION_STATE_POSE = 27,
    XR_TYPE_ACTION_SET_CREATE_INFO = 28,
    XR_TYPE_ACTION_CREATE_INFO = 29,
    XR_TYPE_INSTANCE_PROPERTIES = 32,
    XR_TYPE_FRAME_WAIT_INFO = 33,
    XR_TYPE_COMPOSITION_LAYER_PROJECTION = 35,
    XR_TYPE_COMPOSITION_LAYER_QUAD = 36,
    XR_TYPE_REFERENCE_SPACE_CREATE_INFO = 37,
    XR_TYPE_ACTION_SPACE_CREATE_INFO = 38,
    XR_TYPE_EVENT_DATA_REFERENCE_SPACE_CHANGE_PENDING = 40,
    XR_TYPE_VIEW_CONFIGURATION_VIEW = 41,
    XR_TYPE_SPACE_LOCATION = 42,
    XR_TYPE_SPACE_VELOCITY = 43,
    XR_TYPE_FRAME_STATE = 44,
    XR_TYPE_VIEW_CONFIGURATION_PROPERTIES = 45,
    XR_TYPE_FRAME_BEGIN_INFO = 46,
    XR_TYPE_COMPOSITION_LAYER_PROJECTION_VIEW = 48,
    XR_TYPE_EVENT_DATA_EVENTS_LOST = 49,
    XR_TYPE_INTERACTION_PROFILE_SUGGESTED_BINDING = 51,
    XR_TYPE_EVENT_DATA_INTERACTION_PROFILE_CHANGED = 52,
    XR_TYPE_INTERACTION_PROFILE_STATE = 53,
    XR_TYPE_SWAPCHAIN_IMAGE_ACQUIRE_INFO = 55,
    XR_TYPE_SWAPCHAIN_IMAGE_WAIT_INFO = 56,
    XR_TYPE_SWAPCHAIN_IMAGE_RELEASE_INFO = 57,
    XR_TYPE_ACTION_STATE_GET_INFO = 58,
    XR_TYPE_HAPTIC_ACTION_INFO = 59,
    XR_TYPE_SESSION_ACTION_SETS_ATTACH_INFO = 60,
    XR_TYPE_ACTIONS_SYNC_INFO = 61,
    XR_TYPE_BOUND_SOURCES_FOR_ACTION_ENUMERATE_INFO = 62,
    XR_TYPE_INPUT_SOURCE_LOCALIZED_NAME_GET_INFO = 63,
    XR_TYPE_COMPOSITION_LAYER_CUBE_KHR = 1000006000,
    XR_TYPE_INSTANCE_CREATE_INFO_ANDROID_KHR = 1000008000,
    XR_TYPE_COMPOSITION_LAYER_DEPTH_INFO_KHR = 1000010000,
    XR_TYPE_VULKAN_SWAPCHAIN_FORMAT_LIST_CREATE_INFO_KHR = 1000014000,
    XR_TYPE_EVENT_DATA_PERF_SETTINGS_EXT = 1000015000,
    XR_TYPE_COMPOSITION_LAYER_CYLINDER_KHR = 1000017000,
    XR_TYPE_COMPOSITION_LAYER_EQUIRECT_KHR = 1000018000,
    XR_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT = 1000019000,
    XR_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT = 1000019001,
    XR_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT = 1000019002,
    XR_TYPE_DEBUG_UTILS_LABEL_EXT = 1000019003,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_WIN32_KHR = 1000023000,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_XLIB_KHR = 1000023001,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_XCB_KHR = 1000023002,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_WAYLAND_KHR = 1000023003,
    XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_KHR = 1000023004,
    XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_KHR = 1000023005,
    XR_TYPE_GRAPHICS_BINDING_OPENGL_ES_ANDROID_KHR = 1000024001,
    XR_TYPE_SWAPCHAIN_IMAGE_OPENGL_ES_KHR = 1000024002,
    XR_TYPE_GRAPHICS_REQUIREMENTS_OPENGL_ES_KHR = 1000024003,
    XR_TYPE_GRAPHICS_BINDING_VULKAN_KHR = 1000025000,
    XR_TYPE_SWAPCHAIN_IMAGE_VULKAN_KHR = 1000025001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_VULKAN_KHR = 1000025002,
    XR_TYPE_GRAPHICS_BINDING_D3D11_KHR = 1000027000,
    XR_TYPE_SWAPCHAIN_IMAGE_D3D11_KHR = 1000027001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_D3D11_KHR = 1000027002,
    XR_TYPE_GRAPHICS_BINDING_D3D12_KHR = 1000028000,
    XR_TYPE_SWAPCHAIN_IMAGE_D3D12_KHR = 1000028001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_D3D12_KHR = 1000028002,
    XR_TYPE_SYSTEM_EYE_GAZE_INTERACTION_PROPERTIES_EXT = 1000030000,
    XR_TYPE_EYE_GAZE_SAMPLE_TIME_EXT = 1000030001,
    XR_TYPE_VISIBILITY_MASK_KHR = 1000031000,
    XR_TYPE_EVENT_DATA_VISIBILITY_MASK_CHANGED_KHR = 1000031001,
    XR_TYPE_SESSION_CREATE_INFO_OVERLAY_EXTX = 1000033000,
    XR_TYPE_EVENT_DATA_MAIN_SESSION_VISIBILITY_CHANGED_EXTX = 1000033003,
    XR_TYPE_COMPOSITION_LAYER_COLOR_SCALE_BIAS_KHR = 1000034000,
    XR_TYPE_SPATIAL_ANCHOR_CREATE_INFO_MSFT = 1000039000,
    XR_TYPE_SPATIAL_ANCHOR_SPACE_CREATE_INFO_MSFT = 1000039001,
    XR_TYPE_COMPOSITION_LAYER_IMAGE_LAYOUT_FB = 1000040000,
    XR_TYPE_COMPOSITION_LAYER_ALPHA_BLEND_FB = 1000041001,
    XR_TYPE_VIEW_CONFIGURATION_DEPTH_RANGE_EXT = 1000046000,
    XR_TYPE_GRAPHICS_BINDING_EGL_MNDX = 1000048004,
    XR_TYPE_SPATIAL_GRAPH_NODE_SPACE_CREATE_INFO_MSFT = 1000049000,
    XR_TYPE_SPATIAL_GRAPH_STATIC_NODE_BINDING_CREATE_INFO_MSFT = 1000049001,
    XR_TYPE_SPATIAL_GRAPH_NODE_BINDING_PROPERTIES_GET_INFO_MSFT = 1000049002,
    XR_TYPE_SPATIAL_GRAPH_NODE_BINDING_PROPERTIES_MSFT = 1000049003,
    XR_TYPE_SYSTEM_HAND_TRACKING_PROPERTIES_EXT = 1000051000,
    XR_TYPE_HAND_TRACKER_CREATE_INFO_EXT = 1000051001,
    XR_TYPE_HAND_JOINTS_LOCATE_INFO_EXT = 1000051002,
    XR_TYPE_HAND_JOINT_LOCATIONS_EXT = 1000051003,
    XR_TYPE_HAND_JOINT_VELOCITIES_EXT = 1000051004,
    XR_TYPE_SYSTEM_HAND_TRACKING_MESH_PROPERTIES_MSFT = 1000052000,
    XR_TYPE_HAND_MESH_SPACE_CREATE_INFO_MSFT = 1000052001,
    XR_TYPE_HAND_MESH_UPDATE_INFO_MSFT = 1000052002,
    XR_TYPE_HAND_MESH_MSFT = 1000052003,
    XR_TYPE_HAND_POSE_TYPE_INFO_MSFT = 1000052004,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_SESSION_BEGIN_INFO_MSFT = 1000053000,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_STATE_MSFT = 1000053001,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_FRAME_STATE_MSFT = 1000053002,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_FRAME_END_INFO_MSFT = 1000053003,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_LAYER_INFO_MSFT = 1000053004,
    XR_TYPE_SECONDARY_VIEW_CONFIGURATION_SWAPCHAIN_CREATE_INFO_MSFT = 1000053005,
    XR_TYPE_CONTROLLER_MODEL_KEY_STATE_MSFT = 1000055000,
    XR_TYPE_CONTROLLER_MODEL_NODE_PROPERTIES_MSFT = 1000055001,
    XR_TYPE_CONTROLLER_MODEL_PROPERTIES_MSFT = 1000055002,
    XR_TYPE_CONTROLLER_MODEL_NODE_STATE_MSFT = 1000055003,
    XR_TYPE_CONTROLLER_MODEL_STATE_MSFT = 1000055004,
    XR_TYPE_VIEW_CONFIGURATION_VIEW_FOV_EPIC = 1000059000,
    XR_TYPE_HOLOGRAPHIC_WINDOW_ATTACHMENT_MSFT = 1000063000,
    XR_TYPE_COMPOSITION_LAYER_REPROJECTION_INFO_MSFT = 1000066000,
    XR_TYPE_COMPOSITION_LAYER_REPROJECTION_PLANE_OVERRIDE_MSFT = 1000066001,
    XR_TYPE_ANDROID_SURFACE_SWAPCHAIN_CREATE_INFO_FB = 1000070000,
    XR_TYPE_COMPOSITION_LAYER_SECURE_CONTENT_FB = 1000072000,
    XR_TYPE_INTERACTION_PROFILE_DPAD_BINDING_EXT = 1000078000,
    XR_TYPE_INTERACTION_PROFILE_ANALOG_THRESHOLD_VALVE = 1000079000,
    XR_TYPE_HAND_JOINTS_MOTION_RANGE_INFO_EXT = 1000080000,
    XR_TYPE_LOADER_INIT_INFO_ANDROID_KHR = 1000089000,
    XR_TYPE_VULKAN_INSTANCE_CREATE_INFO_KHR = 1000090000,
    XR_TYPE_VULKAN_DEVICE_CREATE_INFO_KHR = 1000090001,
    XR_TYPE_VULKAN_GRAPHICS_DEVICE_GET_INFO_KHR = 1000090003,
    XR_TYPE_COMPOSITION_LAYER_EQUIRECT2_KHR = 1000091000,
    XR_TYPE_SCENE_OBSERVER_CREATE_INFO_MSFT = 1000097000,
    XR_TYPE_SCENE_CREATE_INFO_MSFT = 1000097001,
    XR_TYPE_NEW_SCENE_COMPUTE_INFO_MSFT = 1000097002,
    XR_TYPE_VISUAL_MESH_COMPUTE_LOD_INFO_MSFT = 1000097003,
    XR_TYPE_SCENE_COMPONENTS_MSFT = 1000097004,
    XR_TYPE_SCENE_COMPONENTS_GET_INFO_MSFT = 1000097005,
    XR_TYPE_SCENE_COMPONENT_LOCATIONS_MSFT = 1000097006,
    XR_TYPE_SCENE_COMPONENTS_LOCATE_INFO_MSFT = 1000097007,
    XR_TYPE_SCENE_OBJECTS_MSFT = 1000097008,
    XR_TYPE_SCENE_COMPONENT_PARENT_FILTER_INFO_MSFT = 1000097009,
    XR_TYPE_SCENE_OBJECT_TYPES_FILTER_INFO_MSFT = 1000097010,
    XR_TYPE_SCENE_PLANES_MSFT = 1000097011,
    XR_TYPE_SCENE_PLANE_ALIGNMENT_FILTER_INFO_MSFT = 1000097012,
    XR_TYPE_SCENE_MESHES_MSFT = 1000097013,
    XR_TYPE_SCENE_MESH_BUFFERS_GET_INFO_MSFT = 1000097014,
    XR_TYPE_SCENE_MESH_BUFFERS_MSFT = 1000097015,
    XR_TYPE_SCENE_MESH_VERTEX_BUFFER_MSFT = 1000097016,
    XR_TYPE_SCENE_MESH_INDICES_UINT32_MSFT = 1000097017,
    XR_TYPE_SCENE_MESH_INDICES_UINT16_MSFT = 1000097018,
    XR_TYPE_SERIALIZED_SCENE_FRAGMENT_DATA_GET_INFO_MSFT = 1000098000,
    XR_TYPE_SCENE_DESERIALIZE_INFO_MSFT = 1000098001,
    XR_TYPE_EVENT_DATA_DISPLAY_REFRESH_RATE_CHANGED_FB = 1000101000,
    XR_TYPE_VIVE_TRACKER_PATHS_HTCX = 1000103000,
    XR_TYPE_EVENT_DATA_VIVE_TRACKER_CONNECTED_HTCX = 1000103001,
    XR_TYPE_SYSTEM_FACIAL_TRACKING_PROPERTIES_HTC = 1000104000,
    XR_TYPE_FACIAL_TRACKER_CREATE_INFO_HTC = 1000104001,
    XR_TYPE_FACIAL_EXPRESSIONS_HTC = 1000104002,
    XR_TYPE_SYSTEM_COLOR_SPACE_PROPERTIES_FB = 1000108000,
    XR_TYPE_HAND_TRACKING_MESH_FB = 1000110001,
    XR_TYPE_HAND_TRACKING_SCALE_FB = 1000110003,
    XR_TYPE_HAND_TRACKING_AIM_STATE_FB = 1000111001,
    XR_TYPE_HAND_TRACKING_CAPSULES_STATE_FB = 1000112000,
    XR_TYPE_SYSTEM_SPATIAL_ENTITY_PROPERTIES_FB = 1000113004,
    XR_TYPE_SPATIAL_ANCHOR_CREATE_INFO_FB = 1000113003,
    XR_TYPE_SPACE_COMPONENT_STATUS_SET_INFO_FB = 1000113007,
    XR_TYPE_SPACE_COMPONENT_STATUS_FB = 1000113001,
    XR_TYPE_EVENT_DATA_SPATIAL_ANCHOR_CREATE_COMPLETE_FB = 1000113005,
    XR_TYPE_EVENT_DATA_SPACE_SET_STATUS_COMPLETE_FB = 1000113006,
    XR_TYPE_FOVEATION_PROFILE_CREATE_INFO_FB = 1000114000,
    XR_TYPE_SWAPCHAIN_CREATE_INFO_FOVEATION_FB = 1000114001,
    XR_TYPE_SWAPCHAIN_STATE_FOVEATION_FB = 1000114002,
    XR_TYPE_FOVEATION_LEVEL_PROFILE_CREATE_INFO_FB = 1000115000,
    XR_TYPE_KEYBOARD_SPACE_CREATE_INFO_FB = 1000116009,
    XR_TYPE_KEYBOARD_TRACKING_QUERY_FB = 1000116004,
    XR_TYPE_SYSTEM_KEYBOARD_TRACKING_PROPERTIES_FB = 1000116002,
    XR_TYPE_TRIANGLE_MESH_CREATE_INFO_FB = 1000117001,
    XR_TYPE_SYSTEM_PASSTHROUGH_PROPERTIES_FB = 1000118000,
    XR_TYPE_PASSTHROUGH_CREATE_INFO_FB = 1000118001,
    XR_TYPE_PASSTHROUGH_LAYER_CREATE_INFO_FB = 1000118002,
    XR_TYPE_COMPOSITION_LAYER_PASSTHROUGH_FB = 1000118003,
    XR_TYPE_GEOMETRY_INSTANCE_CREATE_INFO_FB = 1000118004,
    XR_TYPE_GEOMETRY_INSTANCE_TRANSFORM_FB = 1000118005,
    XR_TYPE_SYSTEM_PASSTHROUGH_PROPERTIES2_FB = 1000118006,
    XR_TYPE_PASSTHROUGH_STYLE_FB = 1000118020,
    XR_TYPE_PASSTHROUGH_COLOR_MAP_MONO_TO_RGBA_FB = 1000118021,
    XR_TYPE_PASSTHROUGH_COLOR_MAP_MONO_TO_MONO_FB = 1000118022,
    XR_TYPE_PASSTHROUGH_BRIGHTNESS_CONTRAST_SATURATION_FB = 1000118023,
    XR_TYPE_EVENT_DATA_PASSTHROUGH_STATE_CHANGED_FB = 1000118030,
    XR_TYPE_RENDER_MODEL_PATH_INFO_FB = 1000119000,
    XR_TYPE_RENDER_MODEL_PROPERTIES_FB = 1000119001,
    XR_TYPE_RENDER_MODEL_BUFFER_FB = 1000119002,
    XR_TYPE_RENDER_MODEL_LOAD_INFO_FB = 1000119003,
    XR_TYPE_SYSTEM_RENDER_MODEL_PROPERTIES_FB = 1000119004,
    XR_TYPE_RENDER_MODEL_CAPABILITIES_REQUEST_FB = 1000119005,
    XR_TYPE_BINDING_MODIFICATIONS_KHR = 1000120000,
    XR_TYPE_VIEW_LOCATE_FOVEATED_RENDERING_VARJO = 1000121000,
    XR_TYPE_FOVEATED_VIEW_CONFIGURATION_VIEW_VARJO = 1000121001,
    XR_TYPE_SYSTEM_FOVEATED_RENDERING_PROPERTIES_VARJO = 1000121002,
    XR_TYPE_COMPOSITION_LAYER_DEPTH_TEST_VARJO = 1000122000,
    XR_TYPE_SYSTEM_MARKER_TRACKING_PROPERTIES_VARJO = 1000124000,
    XR_TYPE_EVENT_DATA_MARKER_TRACKING_UPDATE_VARJO = 1000124001,
    XR_TYPE_MARKER_SPACE_CREATE_INFO_VARJO = 1000124002,
    XR_TYPE_SPATIAL_ANCHOR_PERSISTENCE_INFO_MSFT = 1000142000,
    XR_TYPE_SPATIAL_ANCHOR_FROM_PERSISTED_ANCHOR_CREATE_INFO_MSFT = 1000142001,
    XR_TYPE_SPACE_QUERY_INFO_FB = 1000156001,
    XR_TYPE_SPACE_QUERY_RESULTS_FB = 1000156002,
    XR_TYPE_SPACE_STORAGE_LOCATION_FILTER_INFO_FB = 1000156003,
    XR_TYPE_SPACE_UUID_FILTER_INFO_FB = 1000156054,
    XR_TYPE_SPACE_COMPONENT_FILTER_INFO_FB = 1000156052,
    XR_TYPE_EVENT_DATA_SPACE_QUERY_RESULTS_AVAILABLE_FB = 1000156103,
    XR_TYPE_EVENT_DATA_SPACE_QUERY_COMPLETE_FB = 1000156104,
    XR_TYPE_SPACE_SAVE_INFO_FB = 1000158000,
    XR_TYPE_SPACE_ERASE_INFO_FB = 1000158001,
    XR_TYPE_EVENT_DATA_SPACE_SAVE_COMPLETE_FB = 1000158106,
    XR_TYPE_EVENT_DATA_SPACE_ERASE_COMPLETE_FB = 1000158107,
    XR_TYPE_SWAPCHAIN_IMAGE_FOVEATION_VULKAN_FB = 1000160000,
    XR_TYPE_SWAPCHAIN_STATE_ANDROID_SURFACE_DIMENSIONS_FB = 1000161000,
    XR_TYPE_SWAPCHAIN_STATE_SAMPLER_OPENGL_ES_FB = 1000162000,
    XR_TYPE_SWAPCHAIN_STATE_SAMPLER_VULKAN_FB = 1000163000,
    XR_TYPE_COMPOSITION_LAYER_SPACE_WARP_INFO_FB = 1000171000,
    XR_TYPE_SYSTEM_SPACE_WARP_PROPERTIES_FB = 1000171001,
    XR_TYPE_SEMANTIC_LABELS_FB = 1000175000,
    XR_TYPE_ROOM_LAYOUT_FB = 1000175001,
    XR_TYPE_BOUNDARY_2D_FB = 1000175002,
    XR_TYPE_DIGITAL_LENS_CONTROL_ALMALENCE = 1000196000,
    XR_TYPE_SPACE_CONTAINER_FB = 1000199000,
    XR_TYPE_PASSTHROUGH_KEYBOARD_HANDS_INTENSITY_FB = 1000203002,
    XR_TYPE_COMPOSITION_LAYER_SETTINGS_FB = 1000204000,
    XR_TYPE_VULKAN_SWAPCHAIN_CREATE_INFO_META = 1000227000,
    XR_TYPE_PERFORMANCE_METRICS_STATE_META = 1000232001,
    XR_TYPE_PERFORMANCE_METRICS_COUNTER_META = 1000232002,
    XR_TYPE_SYSTEM_HEADSET_ID_PROPERTIES_META = 1000245000,
    XR_TYPE_PASSTHROUGH_CREATE_INFO_HTC = 1000317001,
    XR_TYPE_PASSTHROUGH_COLOR_HTC = 1000317002,
    XR_TYPE_PASSTHROUGH_MESH_TRANSFORM_INFO_HTC = 1000317003,
    XR_TYPE_COMPOSITION_LAYER_PASSTHROUGH_HTC = 1000317004,
    XR_TYPE_FOVEATION_APPLY_INFO_HTC = 1000318000,
    XR_TYPE_FOVEATION_DYNAMIC_MODE_INFO_HTC = 1000318001,
    XR_TYPE_FOVEATION_CUSTOM_MODE_INFO_HTC = 1000318002,
    XR_TYPE_ACTIVE_ACTION_SET_PRIORITIES_EXT = 1000373000,
    XR_TYPE_GRAPHICS_BINDING_VULKAN2_KHR = 1000025000,
    XR_TYPE_SWAPCHAIN_IMAGE_VULKAN2_KHR = 1000025001,
    XR_TYPE_GRAPHICS_REQUIREMENTS_VULKAN2_KHR = 1000025002,
    XR_STRUCTURE_TYPE_MAX_ENUM = $7FFFFFFF
  );

  XrObjectType = (
    XR_OBJECT_TYPE_UNKNOWN = 0,
    XR_OBJECT_TYPE_INSTANCE = 1,
    XR_OBJECT_TYPE_SESSION = 2,
    XR_OBJECT_TYPE_SWAPCHAIN = 3,
    XR_OBJECT_TYPE_SPACE = 4,
    XR_OBJECT_TYPE_ACTION_SET = 5,
    XR_OBJECT_TYPE_ACTION = 6,
    XR_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT = 1000019000,
    XR_OBJECT_TYPE_SPATIAL_ANCHOR_MSFT = 1000039000,
    XR_OBJECT_TYPE_SPATIAL_GRAPH_NODE_BINDING_MSFT = 1000049000,
    XR_OBJECT_TYPE_HAND_TRACKER_EXT = 1000051000,
    XR_OBJECT_TYPE_SCENE_OBSERVER_MSFT = 1000097000,
    XR_OBJECT_TYPE_SCENE_MSFT = 1000097001,
    XR_OBJECT_TYPE_FACIAL_TRACKER_HTC = 1000104000,
    XR_OBJECT_TYPE_FOVEATION_PROFILE_FB = 1000114000,
    XR_OBJECT_TYPE_TRIANGLE_MESH_FB = 1000117000,
    XR_OBJECT_TYPE_PASSTHROUGH_FB = 1000118000,
    XR_OBJECT_TYPE_PASSTHROUGH_LAYER_FB = 1000118002,
    XR_OBJECT_TYPE_GEOMETRY_INSTANCE_FB = 1000118004,
    XR_OBJECT_TYPE_SPATIAL_ANCHOR_STORE_CONNECTION_MSFT = 1000142000,
    XR_OBJECT_TYPE_PASSTHROUGH_HTC = 1000317000,
    XR_OBJECT_TYPE_MAX_ENUM = $7FFFFFFF
  );

  XrFormFactor = (
    XR_FORM_FACTOR_HEAD_MOUNTED_DISPLAY = 1,
    XR_FORM_FACTOR_HANDHELD_DISPLAY = 2,
    XR_FORM_FACTOR_MAX_ENUM = $7FFFFFFF
  );

  XrViewConfigurationType = (
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_MONO = 1,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_STEREO = 2,
    XR_VIEW_CONFIGURATION_TYPE_PRIMARY_QUAD_VARJO = 1000037000,
    XR_VIEW_CONFIGURATION_TYPE_SECONDARY_MONO_FIRST_PERSON_OBSERVER_MSFT = 1000054000,
    XR_VIEW_CONFIGURATION_TYPE_MAX_ENUM = $7FFFFFFF
  );

  XrSessionState = (
    XR_SESSION_STATE_UNKNOWN = 0,
    XR_SESSION_STATE_IDLE = 1,
    XR_SESSION_STATE_READY = 2,
    XR_SESSION_STATE_SYNCHRONIZED = 3,
    XR_SESSION_STATE_VISIBLE = 4,
    XR_SESSION_STATE_FOCUSED = 5,
    XR_SESSION_STATE_STOPPING = 6,
    XR_SESSION_STATE_LOSS_PENDING = 7,
    XR_SESSION_STATE_EXITING = 8,
    XR_SESSION_STATE_MAX_ENUM = $7FFFFFFF
  );

  XrReferenceSpaceType = (
    XR_REFERENCE_SPACE_TYPE_VIEW = 1,
    XR_REFERENCE_SPACE_TYPE_LOCAL = 2,
    XR_REFERENCE_SPACE_TYPE_STAGE = 3,
    XR_REFERENCE_SPACE_TYPE_UNBOUNDED_MSFT = 1000038000,
    XR_REFERENCE_SPACE_TYPE_COMBINED_EYE_VARJO = 1000121000,
    XR_REFERENCE_SPACE_TYPE_MAX_ENUM = $7FFFFFFF
  );

  XrEnvironmentBlendMode = (
    XR_ENVIRONMENT_BLEND_MODE_OPAQUE = 1,
    XR_ENVIRONMENT_BLEND_MODE_ADDITIVE = 2,
    XR_ENVIRONMENT_BLEND_MODE_ALPHA_BLEND = 3,
    XR_ENVIRONMENT_BLEND_MODE_MAX_ENUM = $7FFFFFFF
  );

type
  XrDebugUtilsMessageSeverityFlagsEXT = XrFlags64;
  XrDebugUtilsMessageTypeFlagsEXT = XrFlags64;
const
  // XrDebugUtilsMessageSeverityFlagsEXT
  XR_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT = $00000001;
  XR_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT = $00000010;
  XR_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT = $00000100;
  XR_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT = $00001000;

  // XrDebugUtilsMessageTypeFlagsEXT
  XR_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT = $00000001;
  XR_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT = $00000002;
  XR_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT = $00000004;
  XR_DEBUG_UTILS_MESSAGE_TYPE_CONFORMANCE_BIT_EXT = $00000008;

type
  TXrApplicationInfo = record
    applicationName : array[0..XR_MAX_APPLICATION_NAME_SIZE-1] of AnsiChar;
    applicationVersion : uint32_t;
    engineName : array[0..XR_MAX_ENGINE_NAME_SIZE-1] of AnsiChar;
    engineVersion : uint32_t;
    apiVersion : XrVersion;
  end;

  PXrInstanceCreateInfo = ^TXrInstanceCreateInfo;
  TXrInstanceCreateInfo = record
    type_ : XrStructureType;
    next : Pointer;
    createFlags : XrInstanceCreateFlags;
    applicationInfo : TXrApplicationInfo;
    enabledApiLayerCount : uint32_t;
    enabledApiLayerNames : array of PAnsiChar;
    enabledExtensionCount : uint32_t;
    enabledExtensionNames : array of PAnsiChar;
  end;

  TXrDebugUtilsObjectNameInfoEXT = record
    type_ : XrStructureType;
    next : Pointer;
    objectType : XrObjectType;
    objectHandle : uint64_t;
    objectName : PAnsiChar;
  end;

  TXrDebugUtilsLabelEXT = record
    type_ : XrStructureType;
    next : Pointer;
    labelName : PAnsiChar;
  end;

  PXrDebugUtilsMessengerCallbackDataEXT = ^TXrDebugUtilsMessengerCallbackDataEXT;
  TXrDebugUtilsMessengerCallbackDataEXT = record
    type_ : XrStructureType;
    next : Pointer;
    messageId : PAnsiChar;
    functionName : PAnsiChar;
    message : PAnsiChar;
    objectCount : uint32_t;
    objects : array of TXrDebugUtilsObjectNameInfoEXT;
    sessionLabelCount : uint32_t;
    sessionLabels : array of TXrDebugUtilsLabelEXT;
  end;

  PFN_xrDebugUtilsMessengerCallbackEXT = function(
    messageSeverity: XrDebugUtilsMessageSeverityFlagsEXT;
    messageTypes: XrDebugUtilsMessageTypeFlagsEXT;
    callbackData: PXrDebugUtilsMessengerCallbackDataEXT;
    userData: Pointer
    ): XrBool32;

  PXrDebugUtilsMessengerCreateInfoEXT = ^TXrDebugUtilsMessengerCreateInfoEXT;
  TXrDebugUtilsMessengerCreateInfoEXT = record
    type_ : XrStructureType;
    next : Pointer;
    messageSeverities : XrDebugUtilsMessageSeverityFlagsEXT;
    messageTypes : XrDebugUtilsMessageTypeFlagsEXT;
    userCallback : PFN_xrDebugUtilsMessengerCallbackEXT;
    userData : Pointer;
  end;

  PXrSystemGetInfo = ^TXrSystemGetInfo;
  TXrSystemGetInfo = record
    type_ : XrStructureType;
    next : Pointer;
    formFactor : XrFormFactor;
  end;

  PXrSessionCreateInfo = ^TXrSessionCreateInfo;
  TXrSessionCreateInfo = record
    type_ : XrStructureType;
    next : Pointer;
    createFlags : XrSessionCreateFlags;
    systemId : XrSystemId;
  end;

  PXrViewConfigurationView = ^TXrViewConfigurationView;
  TXrViewConfigurationView = record
    type_ : XrStructureType;
    next : Pointer;
    recommendedImageRectWidth : uint32_t;
    maxImageRectWidth : uint32_t;
    recommendedImageRectHeight : uint32_t;
    maxImageRectHeight : uint32_t;
    recommendedSwapchainSampleCount : uint32_t;
    maxSwapchainSampleCount : uint32_t;
  end;

  PXrSwapchainCreateInfo = ^TXrSwapchainCreateInfo;
  TXrSwapchainCreateInfo = record
    type_ : XrStructureType;
    next : Pointer;
    createFlags : XrSwapchainCreateFlags;
    usageFlags : XrSwapchainUsageFlags;
    format : int64_t;
    sampleCount : uint32_t;
    width : uint32_t;
    height : uint32_t;
    faceCount : uint32_t;
    arraySize : uint32_t;
    mipCount : uint32_t;
  end;

  PXrSwapchainImageBaseHeader = ^TXrSwapchainImageBaseHeader;
  TXrSwapchainImageBaseHeader = record
    type_ : XrStructureType;
    next : Pointer;
  end;

  PXrEventDataBuffer = ^TXrEventDataBuffer;
  TXrEventDataBuffer = record
    type_ : XrStructureType;
    next : Pointer;
    varying : array[0..3999] of uint8_t;
  end;

  PXrEventDataSessionStateChanged = ^TXrEventDataSessionStateChanged;
  TXrEventDataSessionStateChanged = record
    type_ : XrStructureType;
    next : Pointer;
    session : XrSession;
    state : XrSessionState;
    time : XrTime;
  end;

  PXrSessionBeginInfo = ^TXrSessionBeginInfo;
  TXrSessionBeginInfo = record
    type_ : XrStructureType;
    next : Pointer;
    primaryViewConfigurationType : XrViewConfigurationType;
    displayTime : XrTime;
    space : XrSpace;
  end;

  TXrVector3f = record
    x : single;
    y : single;
    z : single;
  end;

  TXrQuaternionf = record
    x : single;
    y : single;
    z : single;
    w : single;
  end;

  TXrPosef = record
    orientation : TXrQuaternionf;
    position : TXrVector3f;
  end;

  PXrReferenceSpaceCreateInfo = ^TXrReferenceSpaceCreateInfo;
  TXrReferenceSpaceCreateInfo = record
    type_ : XrStructureType;
    next : Pointer;
    referenceSpaceType : XrReferenceSpaceType;
    poseInReferenceSpace : TXrPosef;
  end;

  PXrFrameWaitInfo = ^TXrFrameWaitInfo;
  TXrFrameWaitInfo = record
    type_ : XrStructureType;
    next : Pointer;
  end;

  PXrFrameState = ^TXrFrameState;
  TXrFrameState = record
    type_ : XrStructureType;
    next : Pointer;
    predictedDisplayTime : XrTime;
    predictedDisplayPeriod : XrDuration;
    shouldRender : XrBool32;
  end;

  PXrFrameBeginInfo = ^TXrFrameBeginInfo;
  TXrFrameBeginInfo = record
    type_ : XrStructureType;
    next : Pointer;
  end;

  PXrViewLocateInfo = ^TXrViewLocateInfo;
  TXrViewLocateInfo = record
    type_ : XrStructureType;
    next : Pointer;
    viewConfigurationType : XrViewConfigurationType;
    displayTime : XrTime;
    space : XrSpace;
  end;

  PXrViewState = ^TXrViewState;
  TXrViewState = record
    type_ : XrStructureType;
    next : Pointer;
    viewStateFlags : XrViewStateFlags;
  end;

  TXrFovf = record
    angleLeft : single;
    angleRight : single;
    angleUp : single;
    angleDown : single;
  end;

  PXrView = ^TXrView;
  TXrView = record
    type_ : XrStructureType;
    next : Pointer;
    pose : TXrPosef;
    fov : TXrFovf;
  end;

  TXrOffset2Di = record
    x : int32_t;
    y : int32_t;
  end;

  TXrExtent2Di = record
    width : int32_t;
    height : int32_t;
  end;

  TXrRect2Di = record
    offset : TXrOffset2Di;
    extent : TXrExtent2Di;
  end;

  TXrSwapchainSubImage = record
    swapchain : XrSwapchain;
    imageRect : TXrRect2Di;
    imageArrayIndex : uint32_t;
  end;

  PXrCompositionLayerProjectionView = ^TXrCompositionLayerProjectionView;
  TXrCompositionLayerProjectionView = record
    type_ : XrStructureType;
    next : Pointer;
    pose : TXrPosef;
    fov : TXrFovf;
    subImage : TXrSwapchainSubImage;
  end;

  TXrCompositionLayerProjection = record
    type_ : XrStructureType;
    next : Pointer;
    layerFlags : XrCompositionLayerFlags;
    space : XrSpace;
    viewCount : uint32_t;
    views : PXrCompositionLayerProjectionView;
  end;

  PXrCompositionLayerBaseHeader = ^TXrCompositionLayerBaseHeader;
  PPXrCompositionLayerBaseHeader = ^PXrCompositionLayerBaseHeader;
  TXrCompositionLayerBaseHeader = record
    type_ : XrStructureType;
    next : Pointer;
    layerFlags : XrCompositionLayerFlags;
    space : XrSpace;
  end;

  PXrFrameEndInfo = ^TXrFrameEndInfo;
  TXrFrameEndInfo = record
    type_ : XrStructureType;
    next : Pointer;
    displayTime : XrTime;
    environmentBlendMode : XrEnvironmentBlendMode;
    layerCount : uint32_t;
    layers : PPXrCompositionLayerBaseHeader;
  end;

  PXrSwapchainImageAcquireInfo = ^TXrSwapchainImageAcquireInfo;
  TXrSwapchainImageAcquireInfo = record
    type_ : XrStructureType;
    next : Pointer;
  end;

  PXrSwapchainImageWaitInfo = ^TXrSwapchainImageWaitInfo;
  TXrSwapchainImageWaitInfo = record
    type_ : XrStructureType;
    next : Pointer;
    timeout : XrDuration;
  end;

  PXrSwapchainImageReleaseInfo = ^TXrSwapchainImageReleaseInfo;
  TXrSwapchainImageReleaseInfo = record
    type_ : XrStructureType;
    next : Pointer;
  end;

  PFN_xrCreateDebugUtilsMessengerEXT = function(
    instance: XrInstance;
    createInfo: PXrDebugUtilsMessengerCreateInfoEXT;
    messenger: PXrDebugUtilsMessengerEXT
    ): XrResult;

  PFN_xrDestroyDebugUtilsMessengerEXT = function(
    messenger: XrDebugUtilsMessengerEXT
    ): XrResult;

// function stdcall
type
  TxrGetInstanceProcAddr = function(
    p1: XrInstance;
    p2: PAnsiChar;
    p3: PFN_xrVoidFunction
    ): XrResult; stdcall;
  
  TxrCreateInstance = function(
    p1: PXrInstanceCreateInfo;
    p2: PXrInstance
    ): XrResult; stdcall;
  
  TxrDestroyInstance = function(
    p1: XrInstance
    ): XrResult; stdcall;
  
  TxrGetSystem = function(
    instance: XrInstance;
    getInfo: PXrSystemGetInfo;
    systemId: PXrSystemId
    ): XrResult; stdcall;
  
  TxrCreateSession = function(
    instance: XrInstance;
    createInfo: PXrSessionCreateInfo;
    session: PXrSession
    ): XrResult; stdcall;
  
  TxrDestroySession = function(
    session: XrSession
    ): XrResult; stdcall;
  
  TxrDestroySwapchain = function(
    swapchain: XrSwapchain
    ): XrResult; stdcall;

  TxrEnumerateViewConfigurationViews = function(
    instance: XrInstance;
    systemId: XrSystemId;
    viewConfigurationType: XrViewConfigurationType;
    viewCapacityInput: uint32_t;
    viewCountOutput: puint32_t;
    views: PXrViewConfigurationView
    ): XrResult; stdcall;
  
  TxrEnumerateSwapchainFormats = function(
    session: XrSession;
    formatCapacityInput: uint32_t;
    formatCountOutput: puint32_t;
    formats: pint64_t
    ): XrResult; stdcall;

  TxrCreateSwapchain = function(
    session: XrSession;
    createInfo: PXrSwapchainCreateInfo;
    swapchain: PXrSwapchain
    ): XrResult; stdcall;

  TxrEnumerateSwapchainImages = function(
    swapchain: XrSwapchain;
    imageCapacityInput: uint32_t;
    imageCountOutput: puint32_t;
    images: PXrSwapchainImageBaseHeader
    ): XrResult; stdcall;

  TxrPollEvent = function(
    instance: XrInstance;
    eventData: PXrEventDataBuffer
    ): XrResult; stdcall;

  TxrBeginSession = function(
    session: XrSession;
    beginInfo: PXrSessionBeginInfo
    ): XrResult; stdcall;

  TxrEndSession = function(
    session: XrSession
    ): XrResult; stdcall;

  TxrCreateReferenceSpace = function(
    session: XrSession;
    createInfo: PXrReferenceSpaceCreateInfo;
    space: PXrSpace
    ): XrResult; stdcall;

  TxrDestroySpace = function(
    space: XrSpace
    ): XrResult; stdcall;

  TxrWaitFrame = function(
    session: XrSession;
    frameWaitInfo: PXrFrameWaitInfo;
    frameState: PXrFrameState
    ): XrResult; stdcall;

  TxrBeginFrame = function(
    session: XrSession;
    frameBeginInfo: PXrFrameBeginInfo
    ): XrResult; stdcall;

  TxrLocateViews = function(
    session: XrSession;
    viewLocateInfo: PXrViewLocateInfo;
    viewState: PXrViewState;
    viewCapacityInput: uint32_t;
    viewCountOutput: puint32_t;
    views: PXrView
    ): XrResult; stdcall;

  TxrEndFrame = function(
    session: XrSession;
    frameEndInfo: PXrFrameEndInfo
    ): XrResult; stdcall;

  TxrAcquireSwapchainImage = function(
    swapchain: XrSwapchain;
    acquireInfo: PXrSwapchainImageAcquireInfo;
    index: puint32_t
    ): XrResult; stdcall;

  TxrWaitSwapchainImage = function(
    swapchain: XrSwapchain;
    waitInfo: PXrSwapchainImageWaitInfo
    ): XrResult; stdcall;

  TxrReleaseSwapchainImage = function(
    swapchain: XrSwapchain;
    releaseInfo: PXrSwapchainImageReleaseInfo
    ): XrResult; stdcall;


var
  xrGetInstanceProcAddr : TxrGetInstanceProcAddr;
  xrCreateInstance : TxrCreateInstance;
  xrDestroyInstance : TxrDestroyInstance;
  xrGetSystem : TxrGetSystem;
  xrCreateSession : TxrCreateSession;
  xrDestroySession : TxrDestroySession;
  xrDestroySwapchain : TxrDestroySwapchain;
  xrEnumerateViewConfigurationViews : TxrEnumerateViewConfigurationViews;
  xrEnumerateSwapchainFormats : TxrEnumerateSwapchainFormats;
  xrCreateSwapchain : TxrCreateSwapchain;
  xrEnumerateSwapchainImages : TxrEnumerateSwapchainImages;
  xrPollEvent : TxrPollEvent;
  xrBeginSession : TxrBeginSession;
  xrEndSession : TxrEndSession;
  xrCreateReferenceSpace : TxrCreateReferenceSpace;
  xrDestroySpace : TxrDestroySpace;
  xrWaitFrame : TxrWaitFrame;
  xrBeginFrame : TxrBeginFrame;
  xrLocateViews : TxrLocateViews;
  xrEndFrame : TxrEndFrame;
  xrAcquireSwapchainImage : TxrAcquireSwapchainImage;
  xrWaitSwapchainImage : TxrWaitSwapchainImage;
  xrReleaseSwapchainImage : TxrReleaseSwapchainImage;


function initOpenXr(): boolean;
function xrMakeVersion(major: uint64_t; minor: uint64_t; patch: uint64_t) : uint64_t;

implementation

function initOpenXr(): boolean;
var
  XrLibHandle : TLibHandle;
begin
  XrLibHandle := LoadLibrary(PAnsiChar('openxr_loader.dll'));

  Pointer(xrGetInstanceProcAddr) := GetProcAddress(XrLibHandle, 'xrGetInstanceProcAddr');
  Pointer(xrCreateInstance) := GetProcAddress(XrLibHandle, 'xrCreateInstance');
  Pointer(xrDestroyInstance) := GetProcAddress(XrLibHandle, 'xrDestroyInstance');
  Pointer(xrGetSystem) := GetProcAddress(XrLibHandle, 'xrGetSystem');
  Pointer(xrCreateSession) := GetProcAddress(XrLibHandle, 'xrCreateSession');
  Pointer(xrDestroySession) := GetProcAddress(XrLibHandle, 'xrDestroySession');
  Pointer(xrDestroySwapchain) := GetProcAddress(XrLibHandle, 'xrDestroySwapchain');
  Pointer(xrEnumerateViewConfigurationViews) :=
    GetProcAddress(XrLibHandle, 'xrEnumerateViewConfigurationViews');
  Pointer(xrEnumerateSwapchainFormats) :=
    GetProcAddress(XrLibHandle, 'xrEnumerateSwapchainFormats');
  Pointer(xrCreateSwapchain) := GetProcAddress(XrLibHandle, 'xrCreateSwapchain');
  Pointer(xrEnumerateSwapchainImages) :=
    GetProcAddress(XrLibHandle, 'xrEnumerateSwapchainImages');
  Pointer(xrPollEvent) := GetProcAddress(XrLibHandle, 'xrPollEvent');
  Pointer(xrBeginSession) := GetProcAddress(XrLibHandle, 'xrBeginSession');
  Pointer(xrEndSession) := GetProcAddress(XrLibHandle, 'xrEndSession');
  Pointer(xrCreateReferenceSpace) := GetProcAddress(XrLibHandle, 'xrCreateReferenceSpace');
  Pointer(xrDestroySpace) := GetProcAddress(XrLibHandle, 'xrDestroySpace');
  Pointer(xrWaitFrame) := GetProcAddress(XrLibHandle, 'xrWaitFrame');
  Pointer(xrBeginFrame) := GetProcAddress(XrLibHandle, 'xrBeginFrame');
  Pointer(xrLocateViews) := GetProcAddress(XrLibHandle, 'xrLocateViews');
  Pointer(xrEndFrame) := GetProcAddress(XrLibHandle, 'xrEndFrame');
  Pointer(xrAcquireSwapchainImage) := GetProcAddress(XrLibHandle, 'xrAcquireSwapchainImage');
  Pointer(xrWaitSwapchainImage) := GetProcAddress(XrLibHandle, 'xrWaitSwapchainImage');
  Pointer(xrReleaseSwapchainImage) := GetProcAddress(XrLibHandle, 'xrReleaseSwapchainImage');

  result := true;
end;

function xrMakeVersion(major: uint64_t; minor: uint64_t; patch: uint64_t) : uint64_t;
begin
  result := ( ( (( (major) and $ffff )) shl 48) or
              ( (( (minor) and $ffff )) shl 32) or
              ( ( (patch) and $ffffffff )) );
end;

end.
