## DESCRIPTION:
	Camsys is a script for Raspberry Pi linux systems using the love2d framework.
	This program displays an Image or Loopable Video to a display until a signal is
	received on the GPIO. This signal triggers a camera via USB to take a picture
 	which is then displayed on screen for 20 seconds before returning to the Image
  	or Loopable Video.

## DEPENDENCIES:
	- gphoto2: install on your linux environment using apt-get
	- lua-periphery: install on your linux environment using luarocks
	- nativefs: local, import from lib.nativefs

## NOTES:
    - This script assumes you are using a linux environment.

## LICENSE:

  Author: Brandon Burnette 2023

	Permission is hereby granted, free of charge, to any person obtaining a copy of
	this software and associated documentation files (the "Software"), to deal in
	the Software without restriction, including without limitation the rights to
	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
	of the Software, and to permit persons to whom the Software is furnished to do
	so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
