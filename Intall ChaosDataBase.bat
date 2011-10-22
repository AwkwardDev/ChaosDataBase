@echo off
setlocal
:quick
set quick=off
if %quick% == off goto standard
set svr=localhost
set user=root
set pass=
set port=3306
set wdb=world
set yesno=y
goto install

:standard

echo ChaosEMU DataBase Installer: 
echo https://github.com/ChaosEMU/ChaosCore
echo https://github.com/ChaosEMU/ChaosDataBase
echo.
echo ChaosEMU TEAM:
echo Dreadii
echo Greymane
echo Locknes
echo.
echo 2010-2011 ChaosEMU 
echo.
set /p svr=What is your MySQL host name?           [localhost]   : 
if %svr%. == . set svr=localhost
set /p user=What is your MySQL user name?           [root]        : 
if %user%. == . set user=root
set /p pass=What is your MySQL password?            [ ]           : 
if %pass%. == . set pass=
set /p port=What is your MySQL port?                [3306]        : 
if %port%. == . set port=3306
set /p wdb=What is your World database name?       [world]      : 
if %wdb%. == . set wdb=world
set /p cdb=What is your Characters database name?  [characters]  : 
if %cdb%. == . set cdb=characters
set /p rdb=What is your Realmd database name?      [auth]      : 
if %rdb%. == . set rdb=auth

:install
set dbpath=Databases
set mysql=mysql

:checkpaths
if not exist %dbpath% then goto patherror
if not exist %mysql%\mysql.exe then goto patherror
goto world

:patherror
echo Cannot find required files, please ensure you have done a fully
echo recursive checkout from the SVN.
pause
goto :eof

:world
echo.
echo This will wipe out your current World database and replace it.
set /p yesno=Do you wish to continue? (y/n) 
if %yesno% neq y if %yesno% neq Y goto sd2

echo.
echo ############################
echo #                          #
echo # Importing World database #
echo #                          #
echo ############################


%mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% %wdb% < Databases\clean_install\worldv2.sql




if %quick% neq off goto :eof

:characters
echo.
echo This will wipe out your current Characters database and replace it.
set /p yesno=Do you wish to continue? (y/n) 
if %yesno% neq y if %yesno% neq Y goto realm

echo.
echo #################################
echo #                               #
echo # Importing Characters database #
echo #                               #
echo #################################

%mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% %cdb% < Databases\clean_install\characters.sql

:realm
echo.
echo This will wipe out your current Realm database and replace it.
set /p yesno=Do you wish to continue? (y/n) 
if %yesno% neq y if %yesno% neq Y goto optimize

echo.
echo ############################
echo #                          #
echo # Importing Auth database  #
echo #                          #
echo ############################

%mysql%\mysql -q -s -h %svr% --user=%user% --password=%pass% --port=%port% %rdb% < Databases\clean_install\auth.sql


if %quick% neq off goto :eof



:done
endlocal
echo.
echo All Done
echo.
pause