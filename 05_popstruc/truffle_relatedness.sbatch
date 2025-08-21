module load biology vcftools/0.1.15
#estimate relatedness using truffle and vcftools
vcftools --gzvcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.vcf.gz --relatedness \
--out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename

/oak/stanford/groups/dpetrov/armstrong/applications/truffle/truffle --vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.vcf.gz \
--cpu 10 --segments --out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.truffle


#remove related individuals
module load biology bcftools/1.16
bcftools view -S ^related_list_remove.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.vcf.gz -O z \
-o allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.norelnocap.vcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.norelnocap.vcf.gz

bcftools view -S ^related_list_remove.txt ../vcfs/allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.nonref.full.rename.gvcf.gz -O z \
-o allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.nonref.full.rename.norelnocap.gvcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.nonref.full.rename.norelnocap.gvcf.gz
