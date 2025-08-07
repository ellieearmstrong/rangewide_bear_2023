#!/bin/bash
#SBATCH --job-name=dbarray-bbrown
#SBATCH --time=72:00:00
#SBATCH --array=1-36
#SBATCH --partition=N/A
#SBATCH -n 24
#SBATCH --mem=240000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load gatk/4.1.4.1
config=brownbear_dbimport_config.txt
interval=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
scaffold=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
gatk GenomicsDBImport --java-options "-Xmx120g -Xms120g" --sample-name-map /oak/stanford/groups/dpetrov/armstrong/WSU-bear-genomics/rangewide_bear_2023/03_variantcalling/brownbear_samplemap.txt --genomicsdb-workspace-path brownbeardb_$scaffold -L $interval --batch-size 50 --tmp-dir /scratch/users/elliea/


config=brownbear_dbimport_config.txt
interval=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
scaffold=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
gatk --java-options '-Xmx250g' GenotypeGVCFs -R ../GCF_023065955.2_UrsArc2.0_genomic.fna -V gendb://brownbearbeardb_$scaffold -all-sites --output allbears.${scaffold}.g.vcf -L $interval
