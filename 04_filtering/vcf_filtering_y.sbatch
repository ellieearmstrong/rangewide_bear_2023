###First make sites file for Y chromosome for w/in brown bear analysis
#remove low quality sites
zcat Aug25_haploidYcall_brownbear.gvcf.gz | grep -v '#' | grep -v 'LowQual' > Aug25_haploidYcall_brownbear_lowqual.gvcf
zcat Aug25_haploidYcall_brownbear.gvcf.gz grep '#' > 
cat Aug25_haploidYcall_brownbear.header Aug25_haploidYcall_brownbear_lowqual.gvcf > Aug25_haploidYcall_brownbear_lowqual_header.gvcf
bgzip Aug25_haploidYcall_brownbear_lowqual_header.gvcf
tabix -p Aug25_haploidYcall_brownbear_lowqual_header.gvcf.gz

#rename individuals
bcftools reheader Aug25_haploidYcall_brownbear_lowqual_header.gvcf.gz rename_vcf.txt > Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear.gvcf.gz

#remove samples with less than 5X BAM depth, this file ONLY includes brown bears, so must return to filter for all individuals
bcftools view -S ^lessthan5depth.txt Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear.gvcf.gz --force-samples -O z -o Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x.gvcf.gz

#calc depth stats 
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AN\t%DP\n' Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x.gvcf.gz > Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x.stats

#remove sites with poor callability and depth outliers
#mean depth is 1127, SD is 614, so just do half of autosomes max to be inclusive
#mean AN is 113
bcftools view -i 'AN > 95' Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x.gvcf.gz | bcftools view -i 'INFO/DP > 400 && INFO/DP < 4500'  -O z -o Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x_AN95_DP.gvcf.gz

#remove indels and restrict to 'bi-allelic' sites
bcftools_viewCommand=view -M 2 -O z -o Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x_AN95_DP_M2.gvcf.gz Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x_AN95_DP.gvcf.gz

bcftools_filterCommand=filter -e TYPE="indel" -O z -o Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x_AN95_DP_M2_indel.gvcf.gz Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear_5x_AN95_DP_M2.gvcf.gz

###Next return to previous file with black and polar bears to do species-level filtering for trees
Aug25_haploidYcall_brownbear_lowqual_header_rename_brownbear.gvcf.gz
