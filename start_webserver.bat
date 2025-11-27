@setlocal enableextensions enabledelayedexpansion
@echo off

rem start_websrver.bat
rem Parameters:
rem   1: IP address of web server
rem   2: Port of web server
rem   3: IP address of Gateway on NIC that web server should serve to
rem      (e.g. gateway IP of Wireless Access Point, 192.168.10.1)
rem
rem Version: 1.0    Date: 28/04/2018
rem Author: Tristan Payne
rem Assumes mongoose is present in c:\ScreenRepeat\webpages

rem *********************************************************************
rem SETTINGS
rem *********************************************************************

rem the name of Mongoose exe

  set mongooseEXE=mongoose-free-6.9.exe

	rem IP address and port to server web pages on
  IF "%1"=="" (

    rem Default values
    set ipaddr=192.168.10.100
    set port=8090
    set ipgateway=192.168.10.1

  ) ELSE (

    rem Passed parameters
    set ipaddr=%1
    set port=%2
    set ipgateway=%3

  )

  echo.Server IP = !ipaddr! : !port!
  echo.Gateway IP = !ipgateway!

rem *********************************************************************
rem CHECK IF ALREADY RUNNING
rem *********************************************************************

  tasklist /FI "IMAGENAME eq !mongooseEXE!" 2>NUL | find /I /N "!mongooseEXE!">NUL
  if "%ERRORLEVEL%"=="0" goto Running
  echo Starting web server...
  goto checkIP
:Running
  echo Web server already running
  goto alldone

rem *********************************************************************
rem CHECK IF GATEWAY ACCESSIBLE
rem *********************************************************************
rem Is the gateway accessible, i.e. network cable plugged in?
rem from https://stackoverflow.com/questions/3050898/how-to-check-if-ping-responded-or-not-in-a-batch-file

:checkIP
  set state=up
  ping -n 1 !ipgateway! >nul: 2>nul:
  if not !errorlevel!==0 set state=down
  if !state!==up (
    echo.Link to gateway is !state!
    goto :startserver
  )
  echo.Link to gateway is !state!
  echo.Error - is the WiFi box connected?  Retrying in 10 seconds
  ping -n 10 127.0.0.1 >nul: 2>nul:
  goto :checkIP
  endlocal

rem *********************************************************************
rem START WEB SERVER
rem *********************************************************************

:startserver
  start c:\screenrepeat\webpages\!mongooseEXE! -listening_port !port! -document_root C:\ScreenRepeat\webpages -enable_dir_listing no -start_browser no -error_log_file C:\ScreenRepeat\webpages\error.log



:alldone
