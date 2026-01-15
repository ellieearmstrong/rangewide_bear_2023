#remove indels and very bad sites
bcftools view --max-alleles 2 --exclude-types indels diploidXcall_female_brownbear.gvcf.gz | bcftools view -T ^bear_genmap1_repeats.bed -O z -o diploidXcall_female_brownbear_M2_indel_repmap1.gvcf.gz

#remove lowqual sites
zcat diploidXcall_female_brownbear_M2_indel_repmap1.gvcf.gz | grep -v '#' | grep -v 'LowQual' > diploidXcall_female_brownbear_M2_indel_repmap1_lq.gvcf
zcat diploidXcall_female_brownbear_M2_indel_repmap1.gvcf.gz | grep '#' > diploidXcall_female_brownbear_M2_indel_repmap1_header.txt
cat diploidXcall_female_brownbear_M2_indel_repmap1_header.txt diploidXcall_female_brownbear_M2_indel_repmap1_lq.gvcf > diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf
bgzip diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf
tabix -p vcf diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf.gz

#stats
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AN\t%DP\n' diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf.gz > diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf.stats

#depth filter
bcftools view -i 'INFO/DP > 400 && INFO/DP < 3000' diploidXcall_female_brownbear_M2_indel_repmap1_lq_header.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_repmap1_lq_header_DP.gvcf.gz

#restrict to only brown bears
bcftools view -S xchrom_brownbear.txt diploidXcall_female_brownbear_M2_indel_repmap1_lq_header_DP_rename.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_repmap1_lq_header_DP_rename_nocapnosp.gvcf.gz

#allelic filter 
bcftools view -i 'AN > 113' diploidXcall_female_brownbear_M2_indel_repmap1_lq_header_DP_rename_nocapnosp.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_repmap1_lq_header_DP_rename_nocapnosp_AN.gvcf.gz
