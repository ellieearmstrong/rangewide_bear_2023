module load biology plink/2.0a2
module load biology bcftools/1.16

#####rename samples
bcftools reheader --samples rename.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.vcf.gz -o allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz

#####All bears
plink2 --vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz --make-bed --allow-extra-chr --out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename
plink2 --bfile allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --allow-extra-chr --pca 10 --out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --threads 24

#####Alaska bears only/Hudson bay
bcftools view -s HBay_Alaska.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz -O z -o HbayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
tabix -p vcf HbayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
plink2 --vcf HBayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz --make-bed --allow-extra-chr --out HBayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename
plink2 --bfile HBayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --allow-extra-chr --pca 10 --out HBayAlaska.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --threads 24

#####Lower 48 bears only
bcftools view -s L48.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz -O z -o L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
tabix -p vcf L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
plink2 --vcf L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz --make-bed --allow-extra-chr --out L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename
plink2 --bfile L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --allow-extra-chr --pca 10 --out L48.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --threads 24

#####Lower 48 and canada
bcftools view -s L48_Canada.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz -O z -o L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
tabix -p vcf L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz
plink2 --vcf L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename.vcf.gz --make-bed --allow-extra-chr --out L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename
plink2 --bfile L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --allow-extra-chr --pca 10 --out L48Can.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.rename --threads 24
