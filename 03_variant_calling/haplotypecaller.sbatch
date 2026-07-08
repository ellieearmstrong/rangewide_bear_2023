
config=brownbear_call_config.txt
input=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
output=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
singularity exec --nv parabricks-4.1.1-1.simg pbrun haplotypecaller --ref ../reference_files/GCF_023065955.2_UrsArc2.0_genomic.fna --in-bam $input --out-variants $output --gvcf
