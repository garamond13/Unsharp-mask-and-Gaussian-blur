# Unsharp mask and Gaussian blur
MPV shaders, a 2 pass unsharp mask and a 2 pass gaussian blur. Similar to those in Photoshop, Image Magick, Gimp, etc.

## Usage
If you place this shader in the same folder as your `mpv.conf`, you can use it with `glsl-shaders-append="~~/unsharpMask.glsl"` or `glsl-shaders-append="~~/gaussianBlur.glsl"`. \
Requires `vo=gpu-next`.

## Settings
Note unsharp mask works like this, sharpened = original + (original − blurred) * amount.

### Hook
By default it hooks to `MAIN`. By changing all 3 `//!HOOK MAIN` lines you can hook both shaders to different textures (stages). For all hookable options, see mpv's user manual.

#### Blur spread or amount (SIGMA)
Gaussian blur sigma value, controls the blur intensity and how much it will be spread accros the blur kernel.

#### Blur kernel radius (RADIUS)
Determines how many neighboring pixels will contribute to the blurred value of the center pixel inside the blur kernel.

#### Sharpening amount (AMOUNT) (Unsharp mask only)
Sharpening amount or strenght.

#### Threshold (THRESHOLD)
Sets the minimum contrast for sharpening.
