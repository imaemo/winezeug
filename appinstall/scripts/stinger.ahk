;
; AutoHotKey Test Script for McAfee Avert Stinger
;
; Copyright (C) 2009 Austin English
;
; This library is free software; you can redistribute it and/or
; modify it under the terms of the GNU Lesser General Public
; License as published by the Free Software Foundation; either
; version 2.1 of the License, or (at your option) any later version.
;
; This library is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
; Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public
; License along with this library; if not, write to the Free Software
; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
;

#Include helper_functions

testname=stinger

; Global variables
APPINSTALL=%SYSTEMDRIVE%\appinstall
APPINSTALL_TEMP=%TEMP%\appinstall
IfNotExist, %APPINSTALL%
{
    FileCreateDir, %APPINSTALL%
}
IfNotExist, %APPINSTALL_TEMP%
{
    FileCreateDir, %APPINSTALL_TEMP%
}
SetWorkingDir, %APPINSTALL%

OUTPUT=%APPINSTALL%\%testname%-result.txt
; Start with a fresh log
IfExist, %OUTPUT%
{
    FileDelete, %OUTPUT%
}

; Download Stinger, run it, verify the window exists, and exit.

DOWNLOAD("http://winezeug.googlecode.com/svn/trunk/appinstall/tools/sha1sum/sha1sum.exe", "sha1sum.exe", "4a578ecd09a2d0c8431bdd8cf3d5c5f3ddcddfc9")
DOWNLOAD("http://download.nai.com/products/mcafee-avert/stinger1001546.exe", "stinger.exe", "998a745f3258a432a5bc2047825995aa9e6cb7d6")

Run, stinger.exe

Window_wait("Stinger", "Directories to scan:", 5)

ERROR_TEST("Stinger window never appeared.", "Stinger launched fine.")

; Similar to Winclose(), but more forceful. I like forceful.
PostMessage, 0x112, 0xF060,,, Stinger

ERROR_TEST("Exiting Stinger gave an error.", "Stinger claimed to exit fine.")

; Prevent race condition
Sleep 500

IfWinExist, Stinger
{
    FileAppend, Stinger didn't exit for some reason. Test failed.`n, %OUTPUT%
}
IfWinNotExist, Stinger
{
FileAppend, Stinger exited successfully. Test passed.`n, %OUTPUT%
}

FileDelete, Stinger*opt

CLEANUP()
exit 0
