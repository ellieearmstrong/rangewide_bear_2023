for file in *.bam;do
  bn=`basename $file .bam`
  angsd -i ${bn}.bam -r NC_003427.1 -ref GCF_023065955.2_UrsArc2.0_genomic.fna -doCounts 1 -doFasta 2 -minQ 20 -minmapq 30 -C 50 -P 50 -setMinDepthInd 5 -out ${bn}.mtdna.fa
done
