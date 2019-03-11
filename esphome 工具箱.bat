@echo off
title esphome ������

set PYTHONPATH=%cd%\Prerequisites\Python27
set PYTHON_SCRIPTS_PATH=%cd%\Prerequisites\Python27\Scripts
set GITPATH=%cd%\Prerequisites\git\cmd

>"%tmp%\t.t" echo;WSH.Echo(/[\u4E00-\u9FFF]/.test(WSH.Arguments(0)))
for /f %%a in ('cscript -nologo -e:jscript "%tmp%\t.t" "%PYTHONPATH%"') do if %%a neq 0 (
Color cf&echo;��ǰ���л��� %PYTHONPATH%&echo;!!!�벻Ҫ������Ŀ¼��ʹ��!!!&echo;&pause&EXIT /B) else (Goto Start)

:Start
set PATH=%PYTHONPATH%;%PYTHON_SCRIPTS_PATH%;%GITPATH%;%PATH%
Color f5
::MODE con: Cols=100 Lines=30
Set var=0
echo ���ڳ�ʼ�������Ժ�...
for /f "delims=" %%i in ('python %PYTHONPATH%\Scripts\check.py') do set detail=%%i

:Menu
rem                        Commands
rem    config              Validate the configuration and spit it out.
rem    compile             Read the configuration and compile a program.
rem    upload              Validate the configuration and upload the latest
rem                        binary.
rem    logs                Validate the configuration and show all MQTT logs.
rem    run                 Validate the configuration, create a binary, upload
rem                        it, and start MQTT logs.
rem    clean-mqtt          Helper to clear an MQTT topic from retain messages.
rem    wizard              A helpful setup wizard that will guide you through
rem                        setting up esphome.
rem    mqtt-fingerprint    Get the SSL fingerprint from a MQTT broker.
rem    version             Print the esphome version and exit.
rem    clean               Delete all temporary build files.
rem    dashboard           Create a simple web server for a dashboard.
rem    hass-config         Dump the configuration entries that should be added to
rem                        Home Assistant when not using MQTT discovery.
cls
::for /f "delims=" %%i in ('python -m esphomeyaml %cd% version') do echo �� esphome ������ ��%%i
echo �� esphome ������ ��
echo.
echo �˵�:
echo       (1)  ��ʼ���������ļ�       (2)  ������棨���±���ǰʹ�ã�
echo.
echo       (3)  ����̼�               (4)  �鿴��־
echo.
echo       (5)  ��ˢ�ѱ���̼�         (6)  ����hass�����ļ�
echo.
echo       (7)  ���벢��ˢ�̼�         (8)  OTA�̼�����
echo.
echo       (u)  ����esphome�汾 [ %detail% ]
echo.
echo       (q)  �˳�
echo.
echo.
if %var% neq 0 echo ��������Ч�����������
Set choice=
Set /p choice=���������  
Set "choice=%choice:"=%"
if "%choice:~-1%"=="=" Goto Menu
if "%choice%"=="" Goto Menu
if /i "%choice%" == "1" Set go=Wizard&cls&Goto Check
if /i "%choice%" == "2" Set go=Clean&cls&Goto Check
if /i "%choice%" == "3" Set go=Compile&cls&Goto Check
if /i "%choice%" == "4" Set go=Logs&cls&Goto Check
if /i "%choice%" == "5" Set go=Upload&cls&Goto Check
if /i "%choice%" == "6" Set go=Hass-config&cls&Goto Check
if /i "%choice%" == "7" Set go=Run&cls&Goto Check
if /i "%choice%" == "8" Set go=OTA&cls&Goto Check
if /i "%choice%" == "9" cls&Goto DASH
if /i "%choice%" == "u" cls&Goto Upgrade
if /i "%choice%" == "q" Popd&Exit
Set var=1
Goto Menu
 
:Check
set var2=0

:Check1
cls
if %var2% neq 0 echo ��������Ч�����������
set /p input_source=�������������ļ����֣����磺livingroom������Ҫ����.yaml��׺�� 
echo.����ǰѡ��������ļ�Ϊ��%input_source%.yaml��
Set choice1=
Set /p choice1=��ȷ�ϣ�y  ȡ����n �����ϼ��˵���b  �� 
Set "choice1=%choice1:"=%"
if "%choice1:~-1%"=="=" Goto Check1
if "%choice1%"=="" Goto Check1
if /i "%choice1%" == "y" cls&Goto %go%
if /i "%choice1%" == "n" cls&Goto Check
if /i "%choice1%" == "b" cls&Goto Start
Set var2=1
Goto Check1

:Wizard
python -m esphome %input_source%.yaml wizard
echo.&Pause
Goto End
 
:Clean
python -m esphome %input_source%.yaml clean
echo.&Pause
Goto End

:Compile
python -m esphome %input_source%.yaml compile
echo.&Pause
Goto End
 
:Logs
python -m esphome %input_source%.yaml logs
echo.&Pause
Goto End

:Upload
python -m esphome %input_source%.yaml upload
echo.&Pause
Goto End
 
:Hass-config
python -m esphome %input_source%.yaml hass-config
echo.&Pause
Goto End

:Run
python -m esphome %input_source%.yaml run
echo.&Pause
Goto End

:OTA
set /p input_ip=���������豸IP��ַ����192.168.0.123���� 
python -m esphome %input_source%.yaml run --upload-port %input_ip%
echo.&Pause
Goto End

:DASH
python -m esphome %cd% dashboard --open-ui
echo.&Pause
Goto End

:Upgrade
python -m pip install --upgrade esphome
echo.&Pause
Goto End
 
:End
if "%choice%" neq "" (
    cls
    if "%choice%" neq "3" (
        echo �������� !!!
        if exist %WINDIR%\System32\timeout.exe (timeout /t 2) else (if exist %WINDIR%\System32\choice.exe (choice /t 2 /d y /n >nul) else (ping 127.1 -n 2 >nul))
    )
    Goto Start
)