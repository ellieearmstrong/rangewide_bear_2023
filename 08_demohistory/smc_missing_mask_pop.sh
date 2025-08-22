#!/bin/bash

# Load required modules (comment out if not using a module system)
module load vcftools
module load htslib

# Create output directories
mkdir -p pop_missingness_results
mkdir -p masks

# Define population data as associative arrays
declare -A POP_SAMPLES
POP_SAMPLES["AK-26"]="BB_AK_26B_2,BB_AK_26B_5,BB_AK_26B_9,BB_AK_26B_12,BB_AK_26B_1,BB_AK_26B_3,BB_AK_26B_4,BB_AK_26B_6,BB_AK_26B_7,BB_AK_pub_26_1,BB_AK_pub_26_2,BB_AK_pub_26_4"
POP_SAMPLES["AK-15"]="BB_AK_15_2,BB_AK_15_5,BB_AK_15_1,BB_AK_15_3,BB_AK_15_4,BB_AK_15_pub"
POP_SAMPLES["Kenai"]="BB_AK_9_1,BB_AK_9_4,BB_AK_9_16,BB_AK_9_2,BB_AK_9_3,BB_AK_9_5,BB_AK_9_6,BB_AK_9_8,BB_AK_9_9,BB_AK_9_11,BB_AK_9_13,B_AK_9_pub"
POP_SAMPLES["Kodiak"]="BB_AK_8_1,BB_AK_8_3,BB_AK_8_4,BB_AK_8_5,BB_AK_8_6,BB_AK_8_7,BB_AK_8_8,BB_AK_8_10,BB_AK_8_11,BB_AK_8_12,BB_AK_8_13,BB_AK_8_14,BB_AK_8_pub"
POP_SAMPLES["ABC1"]="BB_AK_4Z_1,BB_AK_4Z_4,BB_AK_4Z_7,BB_AK_4Z_10,BB_AK_4Z_12,BB_AK_4Z_13,BB_AK_4Z_16,BB_AK_4_pub1,BB_AK_4_pub2,BB_AK_4_pub3,BB_AK_4_pub4,BB_AK_4_pub5,BB_AK_4_pub9"
POP_SAMPLES["ABC"]="BB_AK_4Z_2,BB_AK_4Z_3,BB_AK_4Z_5,BB_AK_4Z_9,BB_AK_4Z_14,BB_AK_4Z_15,BB_AK_4_pub6,BB_AK_4_pub10,BB_AK_4_pub11,BB_AK_4_pub12,BB_AK_4_pub16"
POP_SAMPLES["HudsonBay"]="BB_CAN_pub_HB_1,BB_CAN_pub_HB_2,BB_CAN_pub_HB_3,BB_CAN_pub_HB_4,BB_CAN_pub_HB_5,BB_CAN_pub_HB_6,BB_CAN_pub_HB_7,BB_CAN_pub_HB_8,BB_CAN_pub_HB_9,BB_CAN_pub_HB_10,BB_CAN_pub_HB_11"
POP_SAMPLES["Alberta"]="BB_CAN_Alb_11,BB_CAN_Alb_7,BB_CAN_Alb_16,BB_CAN_Alb_6,BB_CAN_Alb_12,BB_CAN_Alb_4,BB_CAN_Alb_8,BB_CAN_Alb_18,BB_CAN_Alb_15,BB_CAN_Alb_5,BB_CAN_Alb_14,BB_CAN_Alb_17,BB_CAN_Alb_19,BB_CAN_Alb_20"
POP_SAMPLES["BC_Central"]="BB_CAN_BC_25,BB_CAN_BC_27,BB_CAN_BC_30,BB_CAN_BC_1,BB_CAN_BC_16,BB_CAN_BC_26,BB_CAN_BC_29,BB_CAN_BC_32,BB_CAN_BC_33"
POP_SAMPLES["Selk_Yaak"]="BB_L48_Sel_1,BB_L48_Yaak_2,BB_L48_Yaak_3,BB_L48_Sel_2,BB_L48_Yaak_4,BB_L48_Sel_3,BB_L48_Sel_4,BB_L48_Sel_5,BB_L48_Sel_6,BB_L48_Sel_7,BB_L48_Sel_8,BB_L48_Yaak_5,BB_L48_Sel_9,BB_L48_Yaak_6,BB_L48_Sel_10,BB_L48_pub_Sel"
POP_SAMPLES["NCDE"]="BB_L48_NCD_pub,BB_L48_NCD_1,BB_L48_NCD_2,BB_L48_NCD_3,BB_L48_NCD_4,BB_L48_NCD_5,BB_L48_NCD_6,BB_L48_NCD_7,BB_L48_NCD_8,BB_L48_NCD_9,BB_L48_NCD_10,BB_L48_NCD_11,BB_L48_NCD_12,BB_L48_NCD_13"
POP_SAMPLES["GYE"]="BB_L48_GYE_1,BB_L48_GYE_2,BB_L48_GYE_3,BB_L48_GYE_4,BB_L48_GYE_5,BB_L48_GYE_6,BB_L48_GYE_7,BB_L48_GYE_8,BB_L48_GYE_9,BB_L48_GYE_10,BB_L48_GYE_pub"

# Create array of population names in order
POPS=("AK-26" "AK-15" "Kenai" "Kodiak" "ABC1" "ABC" "HudsonBay" "Alberta" "BC_Central" "Selk_Yaak" "NCDE" "GYE")

# Process each population
for POP in "${POPS[@]}"; do
    echo "Processing population: $POP"

    # Step 1: Create a file with sample IDs for this population
    echo "${POP_SAMPLES[$POP]}" | tr ',' '\n' > pop_missingness_results/${POP}.samples.txt

    # Step 2: Use vcftools to calculate missingness per site for this population
    vcftools --gzvcf allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.singletoncorr.norel.nocap.vcf.gz \
        --keep pop_missingness_results/${POP}.samples.txt \
        --missing-site \
        --out pop_missingness_results/${POP}

    # Step 3: Filter for sites with more than 10% missing data and convert to BED format
    awk -v threshold=0.1 '$5 >= threshold {print $1"\t"($2-1)"\t"$2}' pop_missingness_results/${POP}.lmiss > pop_missingness_results/${POP}.sites_gt_10pct_missing.bed

    # Step 4: Combine with uncallable sites to create population-specific mask
    cat uncallable_sites.bears.bed pop_missingness_results/${POP}.sites_gt_10pct_missing.bed | sort -k1,1 -k2,2n | bgzip > masks/${POP}.missing.uncallable.bed.gz

    # Step 5: Create tabix index
    tabix -p bed masks/${POP}.missing.uncallable.bed.gz

    # Clean up intermediate files
    rm pop_missingness_results/${POP}.lmiss

    echo "Completed processing for population $POP"
done

echo "All populations processed successfully!"