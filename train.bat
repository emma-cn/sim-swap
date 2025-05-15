@echo off

echo switch to project directory
cd /d D:\llm\projects\sim-swap

call conda activate simswap
python train.py 