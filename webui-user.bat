@echo off

@REM Group: Majicmix, RevAnimated, Meinamix, RealisticVision, CosplayMix, ...
set ID=server_id
set GROUP=Majicmix
set TYPE=''
set URL=''

set PYTHON=
set GIT=
set VENV_DIR=
set COMMANDLINE_ARGS=--api --google-id %ID% --group %GROUP% --type %TYPE% --share-url %URL%

call webui.bat
