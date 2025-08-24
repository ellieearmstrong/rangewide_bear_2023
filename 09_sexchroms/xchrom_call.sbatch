config=female_individuals2.txt
input=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
output=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
singularity exec --nv clara-parabricks_4.1.1-1.sif pbrun haplotypecaller --ref ../../GCF_023065955.2_UrsArc2.0_genomic.fna --in-bam $input \
--out-variants $output.xchrom.hc.g.vcf --gvcf -L NC_079873.1

module load gatk/4.1.4.1
gatk GenomicsDBImport --java-options "-Xmx120g -Xms120g" --sample-name-map female_individuals3.txt --genomicsdb-workspace-path brownbeardb_NC_079873.1 \
-L NC_079873.1

gatk GenotypeGVCFs -R ../../GCF_023065955.2_UrsArc2.0_genomic.fna -V gendb://brownbeardb_NC_079873.1 -all-sites -L NC_079873.1 \
-O diploidXcall_female_brownbear.gvcf.gz
