; Copyright (C) 2015 Ruzsinszki Gábor

; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

#define MyAppName "AMD APU Screen Brightness Fixer"
#define MyAppVersion "1.0"
#define MyAppPublisher "webmaster442"
#define MyAppURL "http://www.example.com/"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{0BA8D570-2568-4CC8-BF25-C026F6A3FE05}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
CreateAppDir=no
OutputBaseFilename=AMD-APU-BrightnessFix
Compression=lzma
SolidCompression=yes
AlwaysRestart=True
Uninstallable=no
MinVersion=0,6.2
WizardImageFile=image.bmp
WizardSmallImageFile=image-small.bmp
SetupIconFile=image-icon.ico
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany=webmaster442
VersionInfoDescription={#MyAppName}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoCopyright=webmaster442
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoProductTextVersion={#MyAppVersion}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "gpl-en.txt"; InfoBeforeFile: "info-en.txt"
Name: "hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"; LicenseFile: "gpl-hu.txt"; InfoBeforeFile: "info-hu.txt"

[Registry]
Root: "HKLM"; Subkey: "SYSTEM\ControlSet001\Control\Class\{{4d36e968-e325-11ce-bfc1-08002be10318}\0000"; ValueType: dword; ValueName: "KMD_EnableBrightnessInterface2"; ValueData: "$00000000"; Flags: uninsdeletekey

[CustomMessages]
english.notneded=Display Fix is not required or already installed. Setup will now exit.
hungarian.notneded=A javítás telepítése nem szükséges vagy már telepítve van. A telepítõ ki fog képni.

[Code]
//Exit Process Windows API call
procedure ExitProcess(exitCode:integer); external 'ExitProcess@kernel32.dll stdcall';

//Get Registry root for platform
function GetHKLM: Integer;
begin
  if IsWin64 then
    Result := HKLM64
  else
    Result := HKLM32;
end;

//checks if the specified key exists & has a value other than 0
//if so then the fix is required. Oterwise not
function CheckRegValue: boolean;
  var res: boolean;
      value: Cardinal;
begin
  res := RegQueryDWordValue(GetHKLM(), 'SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000', 'KMD_EnableBrightnessInterface2', value);
  if (res) then begin
    //key exists
    if (value <> 0) then
        result := true
    else
        result := false;
  end
  else
        result := false;
end;

//Setup initialized event handler
//check if fix needed, if yes, then contiues the setup, otherwise exits.
procedure InitializeWizard();
begin
  //exit code 2 means
  //The user clicked Cancel in the wizard before the actual installation started, or chose "No" on the opening "This will install..." message box.
  if (CheckRegValue() = false) then begin
    //ExpandConstant('{cm:
    MsgBox(ExpandConstant('{cm:notneded}'), mbInformation, MB_OK);
    //ExitProcess(2);
  end;
end;
