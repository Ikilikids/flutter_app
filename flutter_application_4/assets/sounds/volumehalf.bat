@echo off
set dir=C:\flutter_application_1\flutter_application_4\assets\sounds

for /L %%i in (0,1,15) do (
    ffmpeg -i "%dir%\%%i.mp3" -filter:a "volume=0.5" "%dir%\%%i.temp.mp3"
    del "%dir%\%%i.mp3"
    ren "%dir%\%%i.temp.mp3" "%%i.mp3"
)
pause