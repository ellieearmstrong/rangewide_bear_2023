#!/bin/bash
##SBATCH --job-name=busco-americancheetah
##SBATCH --time=4:00:00
##SBATCH --mem=120000
##SBATCH --partition=normal,hns,dpetrov
##SBATCH -n 12
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=ellieearmstrong@gmail.com

module load biology bedtools

#create two different versions of the genome for mapping

#version1-male mapping
#includes all chromosomes with the male par region hard masked out
#Male PAR: Scaffold 35, 24,227,605-30,884,109
bedtools maskfasta -fi Ursus_arctos_trio.hap1_JBAT_hap2X.FINAL.fa -bed YPAR.bed -fo Ursus_arctos_trio.hap1_JBAT_hap2X.FINAL.MASKPAR.fa


#version2-female mapping
#includes all chromosomes with Y hard-masked out
#Y chrom Scaffold 35
bedtools maskfasta -fi Ursus_arctos_trio.hap1_JBAT_hap2X.FINAL.fa -bed Ychrom.bed -fo Ursus_arctos_trio.hap1_JBAT_hap2X.FINAL.MASKY.fa

