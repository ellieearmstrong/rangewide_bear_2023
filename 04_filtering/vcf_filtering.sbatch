#!/bin/bash
#SBATCH --job-name=concat-bb
#SBATCH --time=48:00:00
#SBATCH --partition=normal
#SBATCH -n 24
#SBATCH --mem=240000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com

module load biology bcftools
module load biology vcftools
#first do some filtering to make these a little smaller, remove repeats and low mappability regions
for file in *.vcf;do
       bn=`basename $file .vcf`
       bcftools view ${bn}.vcf -M 2 | bcftools view -T ^bear_genmap1_repeats.bed -O z -o ${bn}.g.M2.repmap1.vcf.gz
done

#get rid of indels, low quality sites, and depth depth is just # of individuals *5 for min (348*5 = 1740, rounded down) and max is #individuals * 20 (348 * 25 = 8700 rounded up)
for file in *.g.M2.repmap1.vcf.gz;do tabix -p vcf $file ;done
###
for file in *.g.M2.repmap1.vcf.gz;do
       bn=`basename $file .g.M2.repmap1.vcf.gz`
       bcftools view --max-alleles 2 --exclude-types indels ${bn}.g.M2.repmap1.vcf.gz | bcftools view -i 'INFO/DP > 1500 && INFO/DP < 9000 && QUAL>=30' -O z -o ${bn}.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz 
       tabix -p vcf ${bn}.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz
done

bcftools concat *.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz -O z -o allbears.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz

#Now check individual sample depth, drop bad individuals, and then filter for site missingness
vcftools --gzvcf allbears.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz --depth --out allbears.M2.repmap1.indels.DPfilt.QUAL30
vcftools --gzvcf allbears.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz --missing-indv --out allbears.M2.repmap1.indels.DPfilt.QUAL30 

#drop samples that are less than 4 depth and have more than 20% of data missing
bcftools view -S ^individuals_drop20.txt allbears.M2.repmap1.indels.DPfilt.QUAL30.vcf.gz --force-samples | bcftools view -S ^individuals_drop4.txt --force-samples -O z -o allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.vcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.vcf.gz

#calculate DP and AN for all individuals
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AN\t%DP\n' allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.vcf.gz > allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.stats.txt

#okay one last filter for sites where the allelic number is less than 80% of the individuals, ie there are 326 individuals, so there are 652 genotypes if everyone has a variant call. therefore 652*0.8 = 521.5 (so anything over 522)
bcftools view -i 'AN > 522' allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.vcf.gz -O z -o allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.vcf.gz
tabix -p vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.vcf.gz
