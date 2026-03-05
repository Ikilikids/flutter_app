@echo off
set dir=C:\flutter_application_1\flutter_application_4\assets\sounds

rem 名前付きファイルを変換
for %%f in (countdown1.mp3 countdown2.mp3 ry.mp3) do (
    ffmpeg -y -i "%dir%\%%f" -filter:a "volume=0.5" "%dir%\%%~nf.temp.mp3"
    del "%dir%\%%f"
    ren "%dir%\%%~nf.temp.mp3" "%%f"
)

pause