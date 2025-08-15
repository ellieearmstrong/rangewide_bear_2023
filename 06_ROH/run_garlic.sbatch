#run ROH via GARLIC
#first convert to plink format
#as a reminder since this generates individual files we are running it before the removal of relatives/captive/high singletons and these are removed during plotting later
plink --vcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.vcf.gz --recode transpose --allow-extra-chr --const-fid 0 /
--out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename

#then run garlic with false centromere file (that they dont exist because we dont know where they are)
#check chromosomes with bcftools
bcftools query -f '%CHROM\n' allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.vcf.gz | uniq > centromere_bears.txt

#run garlic
garlic --tped allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.tped /
--tfam allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.tfam --centromere centromere_bears.txt --error 0.001 --winsize 100 /
--auto-winsize --auto-overlap-frac --out allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.garlic-selected --size-bounds 1000000 3000000 5000000

#split GARLIC results into individual files
csplit -z allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.garlic-selected.roh.bed /'track'/ '{*}'

#rename first line so that it is just name of individual
for file in xx*;do sed -i 's/ Pop.*//g' $file ;done
for file in xx*;do sed -i 's/track name="Ind: //g' $file ;done

#rename file to name of individual
for f in xx*;do
        f1=$(head -n1 "$f")
        mv -n "$f" "$f1"_GARLICroh.txt
done

#remove first line
for file in *_GARLICroh.txt;do
        sed -i '1d' $file
done
