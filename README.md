This is a simple OpenXR FreePascal project.

## Compilation
1. To compile you will need an additional dglOpenGL.pas file, which can be found at the link:
https://bitbucket.org/saschawillems/dglopengl
Copy this file to the root of the project.
2. Open a project in Lazarus.
3. Click "Build project". After a successful build, the simple_openxr_pascal.exe file will appear.

## Launch
To run you need openxr_loader.dll. It can be borrowed from SteamVR provided the OpenXR runtime is set to SteamVR:
C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win64\openxr_loader.dll

After a successful launch, you will see an image in the VR helmet:

![Screenshot](https://raw.githubusercontent.com/dedm0zaj/simple_openxr_freepascal/main/simple_openxr_freepascal.jpg)

## Notes
1. In this implementation, there is no capture of controllers. Will be added later.
2. The render is output only in the VR helmet. The output of the render on the monitor screen is planned later.
3. Only Windows supported. 
