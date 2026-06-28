@echo off
REM ============================================================
REM  X Chat - lean single-purpose launcher (Chrome Dev)
REM ============================================================
REM  FIRST-RUN SETUP (do once - chrome://flags are per profile,
REM  and this launches a fresh isolated profile):
REM    1. Run this file once; a blank Chrome window opens.
REM    2. chrome://flags - ENABLE these (Chrome Dev names):
REM         #prompt-api                              -> Enabled  (already on if you set it)
REM         #prompt-api-multimodal-input             -> Enabled  (image + audio)
REM         #writer-api                              -> Enabled
REM         #rewriter-api                            -> Enabled
REM         #proofreader-api                         -> Enabled
REM         #summarizer-api                          -> Enabled
REM         #summarizer-api-performance-preference   -> Enabled
REM       Quality + speed (recommended):
REM         #gemma4-for-built-in-ai                  -> Enabled  (better model than Nano)
REM         #on-device-model-litert-lm-backend       -> Enabled
REM         #on-device-model-speculative-decoding    -> Enabled  (faster)
REM       (Translator + Language Detector need NO flag - on by default.)
REM    3. Restart Chrome, then open chrome://on-device-internals
REM       and tick the "Requested" boxes for prompt_api(_gemma4),
REM       writing_assistance_api, summarizer_api, proofreader_api
REM       so the model components download. Or just use the app -
REM       the first message triggers the download (progress shown).
REM
REM  For Ollama models, start Ollama allowing this origin:
REM    set OLLAMA_ORIGINS=*  &&  ollama serve
REM ============================================================
setlocal
title X Chat

REM --- serve the app folder over localhost (works for all providers) ---
cd /d "%~dp0"
start "X Chat server" /min cmd /c "python -m http.server 8765"

REM --- locate Chrome Dev (fall back to stable) ---
set "CHROME=%ProgramFiles%\Google\Chrome Dev\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%LocalAppData%\Google\Chrome Dev\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%ProgramFiles(x86)%\Google\Chrome Dev\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" set "CHROME=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if not exist "%CHROME%" ( echo Could not find chrome.exe - edit CHROME in this file. & pause & exit /b 1 )

REM --- launch a clean, isolated, app-mode window ---
REM  (Hardware acceleration + component/model updates stay ON so
REM   the on-device models keep downloading and updating.)
timeout /t 1 >nul
start "" "%CHROME%" --user-data-dir="%LocalAppData%\XChatProfile" --app="http://localhost:8765/xchat.html" --disable-extensions --no-first-run --no-default-browser-check --disable-sync --no-pings --disable-features=Translate

endlocal
