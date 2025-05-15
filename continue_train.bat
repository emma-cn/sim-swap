@echo off
setlocal enabledelayedexpansion

:: Set environment variables
set "PROJECT_DIR=D:\llm\projects\sim-swap"
set "CONDA_ENV=simswap"
set "LOG_DIR=%PROJECT_DIR%\logs"

:: Format timestamp for log filename
set "timestamp=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestamp=!timestamp: =0!"
set "LOG_FILE=%LOG_DIR%\training_%timestamp%.log"

:: Create log directory if it doesn't exist
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: Function to log messages
call :log "Starting continue training script..."

:: Switch to project directory
cd /d "%PROJECT_DIR%" || (
    call :log "Error: Failed to switch to project directory"
    exit /b 1
)

:: Activate conda environment and run training
call :log "Activating conda environment..."
call conda activate %CONDA_ENV% || (
    call :log "Error: Failed to activate conda environment"
    exit /b 1
)

:: Run training
call :log "Starting continue training process..."
call :log "Log file location: %LOG_FILE%"

:: Create a temporary file for error output
set "ERROR_FILE=%TEMP%\training_error.txt"

:: Run training and capture output
python train.py --continue_train True --load_pretrain ./checkpoints/simswap512 --which_epoch latest >> "%LOG_FILE%" 2> "%ERROR_FILE%"
set "TRAIN_ERROR=%errorlevel%"

:: If there was an error, display the error message
if %TRAIN_ERROR% neq 0 (
    call :log "Error: Training failed with exit code %TRAIN_ERROR%"
    call :log "Error details:"
    type "%ERROR_FILE%" | findstr /v "^$" >> "%LOG_FILE%"
    type "%ERROR_FILE%" | findstr /v "^$"
    del "%ERROR_FILE%"
    exit /b 1
)

:: Display the log file contents
type "%LOG_FILE%"

call :log "Training completed successfully"
exit /b 0

:: Logging function
:log
echo [%date% %time%] %~1
echo [%date% %time%] %~1 >> "%LOG_FILE%"
goto :eof 