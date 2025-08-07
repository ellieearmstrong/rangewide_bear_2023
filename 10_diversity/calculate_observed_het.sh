ml bcftools/1.19

vcf="allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.nonref.full.rename.singletoncorr.norel.nocap.gvcf.gz"
sample=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sample_list.txt )

bcftools query -s "$sample" -f '[%SAMPLE\t%GT\n]' "$vcf" |
awk -v s="$sample" '
  $2 != "./." && $2 != "." { called++ }
  $2 ~ /^0[\/|]1$/ || $2 ~ /^1[\/|]0$/ { het++ }
  END {
    if (called > 0)
      printf "%s\t%d\t%d\t%.6f\n", s, het, called, het/called
  }
' > "per_sample_stats/${sample}.tsv"
