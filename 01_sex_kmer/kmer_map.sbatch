#!/bin/bash
#SBATCH --job-name=kmer_bears
#SBATCH --partition=popgenom,kamiak
#SBATCH --output=kmer_01.out
#SBATCH --error=kmer_01.err
#SBATCH --time=144:00:00
#SBATCH --mem=120000
#SBATCH -n 24
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load samtools/1.11
module load bwa/0.7.17

REFERENCE=Ursus_arctos_trio.hap1_JBAT_hap2X.FINAL.fa

bwa index -a bwtsw $REFERENCE

for file in *_R1_m.fastq;do
        bn=`basename $file _R1_m.fastq`
	bwa mem -M -t 1 $REFERENCE ${bn}_R1_m.fastq ${bn}_R2_m.fastq | samtools view -bS - | samtools sort - > ${bn}.sorted.bam
	samtools index ${bn}.sorted.bam
	samtools coverage ${bn}.sorted.bam -o ${bn}.cov_out -m -w 100
	samtools coverage -r scaffold_35:1-24227604 ${bn}.sorted.bam -o ${bn}.sdr.cov
done
