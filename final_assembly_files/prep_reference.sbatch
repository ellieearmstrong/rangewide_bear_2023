#!/bin/bash
##SBATCH --job-name=mask_ref
##SBATCH --time=4:00:00
##SBATCH --mem=120000
##SBATCH --partition=normal,hns,dpetrov
##SBATCH -n 12
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=ellieearmstrong@gmail.com

module load biology bedtools/2.30.0
module load biology samtools/1.16.1
module load biology bwa/0.7.17
#create two different versions of the genome for mapping

#version1-male mapping
#includes all chromosomes with the male par region hard masked out
#Male PAR: Scaffold 35, 24,227,605-30,884,109
bedtools maskfasta -fi GCF_023065955.2_UrsArc2.0_genomic.fna -bed YPAR.bed -fo GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa
samtools faidx GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa
bwa index -a bwtsw GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa
java -jar /oak/stanford/groups/dpetrov/armstrong/applications/picard.jar CreateSequenceDictionary R=GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa O=GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.dict

#version2-female mapping
#includes all chromosomes with Y hard-masked out
#Y chrom Scaffold 35
bedtools maskfasta -fi GCF_023065955.2_UrsArc2.0_genomic.fna -bed Ychrom.bed -fo GCF_023065955.2_UrsArc2.0_genomic.MASKY.fa
samtools faidx GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa
bwa index -a bwtsw GCF_023065955.2_UrsArc2.0_genomic.MASKPAR.fa
java -jar /oak/stanford/groups/dpetrov/armstrong/applications/picard.jar CreateSequenceDictionary R=GCF_023065955.2_UrsArc2.0_genomic.MASKY.fa O=GCF_023065955.2_UrsArc2.0_genomic.MASKY.dict
