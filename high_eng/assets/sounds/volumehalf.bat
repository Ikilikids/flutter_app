@echo off
set dir=C:\flutter_application_4\assets\sounds

ffmpeg -i "%dir%\pipi.mp3" -filter:a "volume=0.5" "%dir%\pipi.temp.mp3"
del "%dir%\pipi.mp3"
ren "%dir%\pipi.temp.mp3" "pipi.mp3"

pause