@echo off

echo switch to project directory
cd /d D:\llm\projects\sim-swap

echo activate conda environment
conda activate simswap


echo start training script
start "" cmd /c "python train.py --name simswap512_test --batchSize 16 --gpu_ids 0 --dataset D:\llm\data\train_data\FFHQ_align --Gdeep True > train_log.txt 2>&1"