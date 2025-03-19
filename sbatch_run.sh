#!/bin/bash
#SBATCH --job-name=this-is-fine     # nazwa
#SBATCH --nodes=1                   # ilość węzłów
#SBATCH --cpus-per-gpu=4            # ilość cpu na zadanie
#SBATCH --time=80:00:00             # maksymalny czas wykonania zadania
#SBATCH --mem=256gb                 # ilość pamięci RAM
#SBATCH -p H100                     # partycja
#SBATCH --gres=gpu:hopper:4          # (ilość kart graficznych na węźle)
#SBATCH --verbose                   # wyświetlanie informacji o zadaniu
#SBATCH --exclude=r10-7

export NUM_PROCESSES=$(expr $SLURM_JOB_NUM_NODES \* 4)
export VLLM_WORKER_MULTIPROC_METHOD=spawn

# REMOTE ARGS
# MODEL
# REMOTE_MODEL=s3min-tomasznaskret-1712063354/alignment/models/pllum-7b-v1-chat-v5
# # PROMPTS
# REMOTE_DATA=s3min-tomasznaskret-1712063354/alignment/data/pllum-pref-rv7-pl
# # THIS IS SET AUTOMATICALLY BY THE SCRIPT
# REMOTE_OUTPUT=s3min-tomasznaskret-1712063354/alignment/dataset-prepare/test

# RCLONE CONFIG NAME
export RCLONE_REMOTE_CONFIG=s3v2


# HUGGINGFACE
export HF_HOME=$TMPDIR/huggingface
export HF_TOKEN=$HF_TOKEN

# APPTAINER
export APPTAINER_TMPDIR=$TMPDIR/apptainer/
export APPTAINER_CACHEDIR=$TMPDIR/apptainer/
export APPTAINER_TRANSFORMERS_CACHE=$APPTAINER_TMPDIR

GENERATOR="python3 test.py"

# Execute in Apptainer (Singularity) container
APPTAINER_TMPDIR=/dev/shm/$SLURM_JOB_ID APPTAINER_CACHEDIR=/dev/shm/$SLURM_JOB_ID \
    apptainer exec --nv \
    --mount type=bind,src=$TMPDIR,dst=$TMPDIR \
    ~/vllm_image.sif  \
    bash -c "$GENERATOR"