@echo off
set dir=C:\flutter_application_1\flutter_application_4\assets\sounds

for /L %%i in (10,1,15) do (
    ffmpeg -i "%dir%\%%i.wav" "%dir%\%%i.mp3"
    del "%dir%\%%i.wav"
)
pause