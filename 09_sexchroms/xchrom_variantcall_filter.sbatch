###Perform X chrom variant calling on females
module load cuda
module load singularity
config=female_individuals2.txt
input=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
output=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
singularity exec --nv /bigdata/armstronglab/shared/applications/singularity_containers/clara-parabricks_4.1.1-1.sif pbrun haplotypecaller --ref ../../GCF_023065955.2_UrsArc2.0_genomic.fna \
--in-bam $input --out-variants $output.xchrom.hc.g.vcf --gvcf -L NC_079873.1

module load gatk/4.1.4.1
gatk GenomicsDBImport --java-options "-Xmx120g -Xms120g" --sample-name-map female_individuals3.txt --genomicsdb-workspace-path brownbeardb_NC_079873.1 -L NC_079873.1
gatk GenotypeGVCFs -R ../../GCF_023065955.2_UrsArc2.0_genomic.fna -V gendb://brownbeardb_NC_079873.1 -all-sites -L NC_079873.1 -O diploidXcall_female_brownbear.gvcf.gz
gatk SelectVariants -R ../../GCF_023065955.2_UrsArc2.0_genomic.fna --select-type-to-include SNP -V diploidXcall_female_brownbear.vcf.gz -O diploidXcall_female_brownbear_snps.vcf.gz 

##X Chromosome filtering
module load bcftools
bcftools view --max-alleles 2 --exclude-types indels diploidXcall_female_brownbear.gvcf.gz | bcftools view -i 'INFO/DP > 300 && INFO/DP < 3000' -O z -o diploidXcall_female_brownbear_M2_indel_depth.gvcf.gz
bcftools view -S diploidXcall_female_brownbear_individuals.keep diploidXcall_female_brownbear_M2_indel_depth.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AN\t%DP\n' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz > diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.stats
bcftools view -i 'AN > 144' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.gvcf.gz

#split here into a file with just brown bears and a file with brown, polar, and black bears
bcftools reheader -s rename_indvs.txt -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.gvcf.gz
bcftools reheader -s rename_indvs.txt diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.individuals -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.gvcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz
zcat diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.gvcf | grep -v 'LowQual' - | bgzip -c > diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.gvcf.gz
zcat diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz | grep -v 'LowQual' - | bgzip -c > diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.gvcf.gz

#remove repeat regions 
bcftools view -T ^bear_genmap1_repeats.bed diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.gvcf.gz
