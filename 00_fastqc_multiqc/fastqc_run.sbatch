#!/bin/bash
#SBATCH --job-name=fastqc_bears
#SBATCH --partition=popgenom,kamiak
#SBATCH --output=fastqc_01.out
#SBATCH --error=fastqc_01.err
#SBATCH --time=144:00:00
#SBATCH --mem=60000
#SBATCH -n 16
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load fastqc/0.11.9

for file in *_R1_001.fastq.gz;do
	fastqc $file
done

module load multiqc/1.11

multiqc .
