#!/bin/bash
#SBATCH --job-name=male-map
#SBATCH --time=144:00:00
#SBATCH --mem=220000
#SBATCH --partition=dpetrov
#SBATCH -n 12
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load biology bwa/0.7.17
module load biology samtools/1.16.1

REFERENCE=../reference/Ursus_arctos_trio.hap1_JBAT_hap2X.nomtFINAL.MASKPAR.fa
THREADS_BWA=32


for file in male/*_L002_R1_001.fastq.gz;do
       bn=`basename $file _L002_R1_001.fastq.gz`
       bwa mem -t $THREADS_BWA $REFERENCE male/${bn}_L002_R1_001.fastq.gz male/${bn}_L002_R2_001.fastq.gz | samtools view -bS - | samtools sort - > ${bn}.sorted.bam
       samtools index ${bn}.sorted.bam
       java -jar /oak/stanford/groups/dpetrov/armstrong/applications/picard.jar AddOrReplaceReadGroups I=${bn}.sorted.bam O=${bn}.sorted.rg.bam SORT_ORDER=coordinate RGID=${bn} RGLB=${bn} RGPL=illumina RGSM=${bn} RGPU=${bn} CREATE_INDEX=True
       java -jar /oak/stanford/groups/dpetrov/armstrong/applications/picard.jar MarkDuplicates I=${bn}.sorted.rg.bam O=${bn}.male.sorted.rg.md.bam M=${bn}.metrics.md.txt
       samtools index ${bn}.male.sorted.rg.md.bam
done
