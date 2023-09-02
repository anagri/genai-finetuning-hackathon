# Conda install

```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
source ~/.bashrc
```

# Llama-X README.md

## Env setup
```
conda create -y -n llamax python=3.10
conda activate llamax
# git clone https://github.com/AetherCortex/Llama-X.git (source copied in Llama-x)
cd Llama-X/src
conda install -y pytorch==1.12.0 torchvision==0.13.0 torchaudio==0.12.0 cudatoolkit=11.3 -c pytorch
pip install transformers==4.29.2
cd ../..
pip install -r requirements.txt
```

## Convert Model to HF
May not be needed for wizardcoder model downloaded from HF
```
cd Llama-X/src
python transformers/src/transformers/models/llama/convert_llama_weights_to_hf.py \
    --input_dir /path/to/llama-7B/ \
    --model_size 7B \
    --output_dir /path/to/llama-7B/hf
```

## Training Command
```
deepspeed train.py \
    --model_name_or_path /path/to/llama-7B/hf \
    --data_path /path/to/example_data.json \
    --output_dir /path/to/llama-7B/hf/ft \
    --num_train_epochs 3 \
    --model_max_length 512 \
    --per_device_train_batch_size 64 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 100 \
    --save_total_limit 2 \
    --learning_rate 2e-5 \
    --warmup_steps 2 \
    --logging_steps 2 \
    --lr_scheduler_type "cosine" \
    --report_to "tensorboard" \
    --gradient_checkpointing True \
    --deepspeed configs/deepspeed_config.json \
    --fp16 True
```

# WizardLM README.md

```
huggingface-cli login
```

```
sudo mkfs.ext4 /dev/vdb
sudo mkdir /mnt/mydisk
sudo mount /dev/vdb /mnt/mydisk
sudo echo "/dev/vdb   /mnt/mydisk   ext4    defaults    0   0" >> /etc/fstab
sudo mount -a
df -h
```

```
mkdir -p /mnt/mydisk/ckpt
# mkdir -p /content/gdrive/MyDrive/ckpt
mkdir -p /content/gdrive/MyDrive/hf
!export HF_DATASETS_CACHE=/content/gdrive/MyDrive/hf
deepspeed Llama-X/src/train_wizardcoder.py \
    --model_name_or_path "WizardLM/WizardCoder-Python-13B-V1.0" \
    --data_path "final-data/training-data.json" \
    --output_dir "/content/gdrive/MyDrive/ckpt" \
    --num_train_epochs 1 \
    --model_max_length 2048 \
    --per_device_train_batch_size 16 \
    --per_device_eval_batch_size 1 \
    --gradient_accumulation_steps 4 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 20 \
    --save_total_limit 2 \
    --learning_rate 2e-5 \
    --warmup_steps 20 \
    --logging_steps 2 \
    --lr_scheduler_type "cosine" \
    --report_to "tensorboard" \
    --gradient_checkpointing True \
    --deepspeed Llama-X/src/configs/deepspeed_config.json \
    --fp16 True
```
