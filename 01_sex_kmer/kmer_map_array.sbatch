#!/bin/bash
#SBATCH --job-name=kmermap-array
#SBATCH --partition=hns,normal,dpetrov
#SBATCH --time=48:00:00
#SBATCH --array=1-39
#SBATCH --mem=120000
#SBATCH -n 12
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load biology samtools/1.16.1
module load biology bwa/0.7.17

REFERENCE=../reference_files/GCF_023065955.2_UrsArc2.0_genomic.fna

config=kmermap_public.redo.config
input1=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
input2=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
output=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $4}' $config)


bwa mem -M -t 12 $REFERENCE $input1 $input2 | samtools view -bS - | samtools sort - > $output.sorted.bam
samtools index $output.sorted.bam
samtools coverage $output.sorted.bam -o $output.cov_out -m -w 100
samtools coverage -r NC_079874.1:1-24227604 $output.sorted.bam -o $output.sdr.cov
