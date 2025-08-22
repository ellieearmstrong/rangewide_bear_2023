#!/bin/bash

module load vcftools

# Array of population names
POPULATIONS=(
    "ABC1"
    "ABC"
    "AK-15"
    "AK-26"
    "Alberta"
    "BC_Central"
    "GYE"
    "HudsonBay"
    "Kenai"
    "Kodiak"
    "NCDE"
    "Selk_Yaak"
)

# Make sure output directory exists
mkdir -p tajD

# Process each population
for POP in "${POPULATIONS[@]}"; do
    echo "Processing population: ${POP}"
    
    # Construct input file path 
    INPUT_FILE="top6_sfs/${POP}_top6.vcf.gz"
    
    # Check if input file exists
    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Warning: Input file not found: $INPUT_FILE. Skipping ${POP}."
        continue
    fi
    
    # Run vcftools for Tajima's D calculation
    vcftools --gzvcf ${INPUT_FILE} \
             --TajimaD 200000 \
             --out tajD/${POP}_tajD_200kb
    
    echo "Completed Tajima's D analysis for population: ${POP}"
done

echo "All Tajima's D analyses completed."