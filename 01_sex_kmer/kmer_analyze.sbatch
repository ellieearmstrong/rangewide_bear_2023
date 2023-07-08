#!/bin/bash
#SBATCH --job-name=kmer_analyze
#SBATCH --partition=popgenom,kamiak
#SBATCH --output=kmer_analyze_07.out
#SBATCH --error=kmer_analyze_07.err
#SBATCH --time=144:00:00
#SBATCH --mem=120000
#SBATCH -n 24
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com



module load bbtools/38.91

for file in *_R1_001.fastq.gz;do
	bn=`basename $file _R1_001.fastq.gz`
	bbduk.sh in=${bn}_R1_001.fastq.gz in2=${bn}_R2_001.fastq.gz ref=/data/kelley/projects/ellie_projects/rangewide_bear/rangewide_bear_2023/01_sex_kmer/ursus_only_male_kmers.txt.fasta outm=${bn}_R1_m.fastq outm2=${bn}_R2_m.fastq k=21
done
