ml bcftools
####Filter
#remove indels and very bad sites
bcftools view --max-alleles 2 --exclude-types indels diploidXcall_female_brownbear.gvcf.gz | \
bcftools view -i 'INFO/DP > 300 && INFO/DP < 3000' -O z -o diploidXcall_female_brownbear_M2_indel_depth.gvcf.gz

#get rid of individuals with more than 20% missing data, less than 4x depth
bcftools view -S diploidXcall_female_brownbear_individuals.keep diploidXcall_female_brownbear_M2_indel_depth.gvcf.gz -O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz

#run stats for AN and DP average
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AN\t%DP\n' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz \
> diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.stats

#remove sites with poor calls
bcftools view -i 'AN > 144' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.gvcf.gz -O z -o \
diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.gvcf.gz

####rename individuals
bcftools reheader -s rename_indvs.txt -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz \
diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.gvcf.gz

bcftools view -S diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.individuals \
-o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.gvcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz

####remove low quality sites (have to do it this way b/c of gvcf)
zcat sample_fuckery/diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.gvcf | \
grep -v 'LowQual' - | bgzip -c > diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.gvcf.gz

tabix -p vcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.gvcf.gz
zcat diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.gvcf.gz | grep -v 'LowQual' - | \
bgzip -c > diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.gvcf.gz

bcftools view -T ^bear_genmap1_repeats.bed diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.gvcf.gz \
-O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.gvcf.gz
bcftools view -T ^bear_genmap1_repeats.bed diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.gvcf.gz | \
bcftools view -i 'QUAL >= 30' -O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.gvcf.gz

bcftools view -i 'QUAL >= 30' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.gvcf.gz \
-O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.gvcf.gz
bcftools view -i 'QUAL >= 30' diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.gvcf.gz \
-O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.gvcf.gz

####snps only
bcftools view -m2 -M2 -v snps diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.gvcf.gz \
-O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.vcf.gz
bcftools view -m2 -M2 -v snps diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.gvcf.gz \
-O z -o diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.vcf.gz

####convert vcf to phy
python3 ../vcf2phylip/vcf2phylip.py -i diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.vcf.gz

python3 ../vcf2phylip/vcf2phylip.py -i diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.vcf.gz

####build x chrom tree
source /opt/linux/rocky/8.x/x86_64/pkgs/miniconda3/py39_4.12.0/bin/activate iqtreev3.0.1
iqtree2 -s diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.min4.phy \
-redo -m MFP -B 1000 -nt 24 -pre diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.min4

iqtree2 -s diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.min4.phy -m MFP -B 1000 -nt 24 \
-pre diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.min4

####PCAs
ml plink
plink --vcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.vcf.gz --double-id \
--make-bed --allow-extra-chr --out diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30

plink --vcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30.vcf.gz --double-id \
--make-bed --allow-extra-chr --out diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30

plink --bfile diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30 --allow-extra-chr \
--pca 10 --out diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30

plink --bfile diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30 --allow-extra-chr \
--pca 10 --out diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename.LQ.repmap1.QUAL30

####run diversity stats
ml pixy
pixy --stats pi dxy fst --vcf diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30.gvcf.gz \
--populations xchrom_popsplit2.txt  --window_size 50000 --n_cores 24 --output_prefix diploidXcall_female_brownbear_M2_indel_depth.mm20dp4.an144.rename_nocaptive_nosp.LQ.repmap1.QUAL30

