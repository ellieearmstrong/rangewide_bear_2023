ml gatk/4.1.4.1
gatk HaplotypeCaller -I $input -R GCF_023065955.2_UrsArc2.0_genomic.fna -O $output -ERC BP_RESOLUTION -L NC_079874.1 --sample-ploidy 1

gatk GenomicsDBImport --java-options "-Xmx120g -Xms120g" --sample-name-map beary_config.txt --genomicsdb-workspace-path brownbeardb_NC_079874.1 -L NC_079874.1 -ERC BP_RESOLUTION

gatk GenotypeGVCFs -R ../../GCF_023065955.2_UrsArc2.0_genomic.fna -V gendb://brownbeardb_NC_079874.1 --sample-ploidy 1 -all-sites -O June1_haploidYcall_brownbear.gvcf.gz
