@setlocal enableextensions enabledelayedexpansion
@echo off

rem ScreenRepeat.bat
rem Version: 1.3    Date: 11/08/2024
rem Author: Tristan Payne
rem v1.0 16/06/18 Initial version
rem v1.1 13/08/23 out_screen_width was 640 - but caused issues with speed of refresh when screen changed.  Set to 300.
rem v1.2 07/04/24 Speed works well but picture resolution pretty low, comments received.  increased out_screen_width to 320.
rem v1.3 11/08/24 Changed VLC to own copy at c:\screenrepeat\vlc-3.0.0 since an update to system installed VLC has stopped it from working with no error message.  Better to have frozen version of VLC to use for ScreenRepeat as future VLC updates could well break things anyway.

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

  set primary_screen_width=1366

rem The width of the image to display on the tablets.  The higher the number
rem the more bandwidth is needed.  Around 800 may work well.  Useing a
rem lower figure may improve latency at the cost of image quality.

  set out_screen_width=320

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
echo Once it is running OK, this window can be closed.
start /WAIT "VLC Server" "C:\ScreenRepeat\vlc-3.0.0\vlc.exe" screen:// :screen-fps=!out_fps! :screen-left=!primary_screen_width! :live-caching=0 --sout="#transcode{acodec=none,vcodec=mjpg,width=!out_screen_width!}:std{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=0.0.0.0:8080/image.jpg}" --intf dummy --no-repeat --no-loop --play-and-exit

echo.
echo ...VLC didn't start - is an external monitor connected?
echo Close this window to stop trying
echo Retrying in 15 seconds...
timeout /T 15
cls

goto StartVLC
