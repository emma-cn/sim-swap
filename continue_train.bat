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

:: Check if project directory exists
if not exist "%PROJECT_DIR%" (
    call :log "Error: Project directory not found: %PROJECT_DIR%"
    exit /b 1
)

:: Switch to project directory
call :log "Switching to project directory: %PROJECT_DIR%"
cd /d "%PROJECT_DIR%"
if errorlevel 1 (
    call :log "Error: Failed to switch to project directory"
    exit /b 1
)

:: Check if conda environment exists
call :log "Checking conda environment..."
conda env list | findstr /C:"%CONDA_ENV%" >nul
if errorlevel 1 (
    call :log "Error: Conda environment '%CONDA_ENV%' not found"
    exit /b 1
)

:: Activate conda environment and run training
call :log "Activating conda environment and starting training..."
call conda activate %CONDA_ENV%
if errorlevel 1 (
    call :log "Error: Failed to activate conda environment"
    exit /b 1
)

:: Run training with continue parameters
call :log "Starting continue training process..."
call :log "Log file location: %LOG_FILE%"

:: Run training with continue parameters
python train.py --continue_train True --load_pretrain ./checkpoints/simswap512 --which_epoch latest >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    call :log "Error: Training failed with exit code %errorlevel%"
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