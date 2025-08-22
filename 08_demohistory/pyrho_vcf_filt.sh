#!/bin/bash
#SBATCH --job-name=vcf_split_filter
#SBATCH --output=/bigdata/armstronglab/makopyan/logs/vcf_split_filter_%A_%a.out
#SBATCH --error=/bigdata/armstronglab/makopyan/logs/vcf_split_filter_%A_%a.err
#SBATCH --time=15:00:00
#SBATCH --mem=20G
#SBATCH --cpus-per-task=4
#SBATCH --array=1-12

# Load necessary modules
module load bcftools

# Define input files
VCF_FILE="/bigdata/armstronglab/makopyan/allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.snps.nonref.rename.singletoncorr.norel.nocap.vcf.gz"
SPLIT_DIR="/bigdata/armstronglab/makopyan/vcf_split"
FILTERED_DIR="/bigdata/armstronglab/makopyan/filtered_vcf"

# Create output directories
mkdir -p "${SPLIT_DIR}"
mkdir -p "${FILTERED_DIR}"

# Define chromosomes list
CHROMS=(
    NW_026622763.1 NW_026622764.1 NW_026622775.1 NW_026622786.1 NW_026622797.1 NW_026622808.1
    NW_026622819.1 NW_026622830.1 NW_026622841.1 NW_026622852.1 NW_026622863.1 NW_026622874.1
    NW_026622875.1 NW_026622886.1 NW_026622897.1 NW_026622908.1 NW_026622919.1 NW_026622930.1
    NW_026622941.1 NW_026622952.1 NW_026622963.1 NW_026622974.1 NW_026622985.1 NW_026622986.1
    NW_026622997.1 NW_026623008.1 NW_026623019.1 NW_026623030.1 NW_026623050.1 NW_026623053.1
    NW_026623056.1 NW_026623067.1 NW_026623078.1 NW_026623089.1 NW_026623100.1 NW_026623111.1
)

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

# Get the population name for the current SLURM array task
POP=${POPS[$((SLURM_ARRAY_TASK_ID - 1))]}

# Get the list of individuals for this population
INDIVS=${POP_SAMPLES[$POP]}

# Create subdirectories for this population in both output directories
mkdir -p "${SPLIT_DIR}/${POP}"
mkdir -p "${FILTERED_DIR}/${POP}"

# Process each chromosome for this population
for CHR in "${CHROMS[@]}"; do
    # Step 1: Filter and split the VCF (include only specified chroms and individuals for this population)
    split_vcf="${SPLIT_DIR}/${POP}/${POP}.${CHR}.vcf.gz"
    bcftools view -S <(echo "$INDIVS" | tr ',' '\n') -r "$CHR" -O z -o "$split_vcf" "$VCF_FILE"
    
    # Step 2: Filter the split VCF for missingness (calculated within this population only)
    filtered_vcf="${FILTERED_DIR}/${POP}/${POP}.${CHR}.filtered.vcf.gz"
    bcftools view -i 'F_MISSING<0.1' --output-type z --output "$filtered_vcf" "$split_vcf"
done

echo "VCF splitting and filtering completed for population $POP"