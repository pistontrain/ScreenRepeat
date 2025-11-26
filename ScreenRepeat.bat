@setlocal enableextensions enabledelayedexpansion
@echo off

rem ScreenRepeat.bat
rem Version: 1.0    Date: 16/06/2018
rem Author: Tristan Payne
rem Assumes 32-bit VLC is installed.

rem MIT License
rem
rem Copyright (c) 2018 Tristan Payne
rem
rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:
rem
rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.
rem
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.

rem *********************************************************************
rem NETWORK SETTINGS
rem *********************************************************************
rem The IP (not needed) and port of the web server

  set ipaddr=0.0.0.0
  set port=8090

rem The IP of the web server gateway i.e. WiFi access point, needed to
rem check it's connected before starting the web server

  set ipgateway=192.168.10.1

rem *********************************************************************
rem DISPLAY SETTINGS
rem *********************************************************************
rem The width of the primary screen (i.e. start of the secondary screen
rem to be displaying on the tablets)

  set primary_screen_width=1920

rem The width of the image to display on the tablets.  The higher the number
rem the more bandwidth is needed.  Around 800 may work well.  Useing a
rem lower figure may improve latency at the cost of image quality.

  set out_screen_width=640

rem The number of times per second the screen is captured by VLC.  At 5,
rem VLC seems to crash after a few seconds when the screen is all black, so
rem 7 seems a safe setting.  Higher setting will increase bandwidth but give
rem better video fluidity.

  set out_fps=7.000000

rem *********************************************************************
rem START THE WEBSERVER
rem *********************************************************************
rem Webserver serves simple index.html file including element with jpeg
rem image in that is streamed by VLC

call start_webserver !ipaddr! !port! !ipgateway!

rem *********************************************************************
rem START VLC
rem *********************************************************************
rem VLC streams screen in mjpg format to port 8080/image.jpg.

:StartVLC
echo.
echo Starting VLC - this message will continue to be displayed while VLC is running
echo Once it is running OK, this window can be safely closed.
start /WAIT "VLC Server" "c:\Program Files (x86)\VideoLAN\VLC\vlc.exe" screen:// :screen-fps=!out_fps! :screen-left=!primary_screen_width! :live-caching=0 --sout="#transcode{acodec=none,vcodec=mjpg,width=!out_screen_width!}:std{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=0.0.0.0:8080/image.jpg}" --intf dummy --no-repeat --no-loop --play-and-exit

echo.
echo ...VLC didn't start - is an external monitor connected?
echo Close this window to stop trying
echo Retrying in 15 seconds...
timeout /T 15
cls

goto StartVLC
