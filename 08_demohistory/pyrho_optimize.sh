#!/bin/bash

# Load Conda environment
eval "$(conda shell.bash hook)"
conda activate my-pyrho-env

# Define population names
POPS=("AK-26" "AK-15" "Kenai" "Kodiak" "ABC1" "ABC" "HudsonBay" "Alberta" "BC_Central" "Selk_Yaak" "NCDE" "GYE")

# Define chromosomes list
CONTIGS=(
    NW_026622763.1 NW_026622764.1 NW_026622775.1 NW_026622786.1 NW_026622797.1 NW_026622808.1
    NW_026622819.1 NW_026622830.1 NW_026622841.1 NW_026622852.1 NW_026622863.1 NW_026622874.1
    NW_026622875.1 NW_026622886.1 NW_026622897.1 NW_026622908.1 NW_026622919.1 NW_026622930.1
    NW_026622941.1 NW_026622952.1 NW_026622963.1 NW_026622974.1 NW_026622985.1 NW_026622986.1
    NW_026622997.1 NW_026623008.1 NW_026623019.1 NW_026623030.1 NW_026623050.1 NW_026623053.1
    NW_026623056.1 NW_026623067.1 NW_026623078.1 NW_026623089.1 NW_026623100.1 NW_026623111.1
)

# Ensure output directory exists
mkdir -p pyrho_filt_out

# Process each contig
for CONTIG in "${CONTIGS[@]}"; do
    echo "Processing contig: $CONTIG"
    
    # Process this contig for all populations
    for POP in "${POPS[@]}"; do
        VCF_FILE="filtered_vcf/${POP}/${POP}.${CONTIG}.filtered.vcf.gz"
        
        # Skip if VCF file doesn't exist for this population
        if [[ ! -f "$VCF_FILE" ]]; then
            echo "Skipping $POP - Contig $CONTIG: VCF file not found at $VCF_FILE"
            continue
        fi
        
        # Define output file path
        OUT_RMAP="pyrho_filt_out/${POP}_${CONTIG}.rmap"
        
        # Skip if output already exists
        if [[ -f "$OUT_RMAP" ]]; then
            echo "Skipping $POP - Contig $CONTIG: Output file already exists"
            continue
        fi
        
        # Find the correct lookup table
        TABLEFILE=$(find pyrho_filt_out -maxdepth 1 -type f -name "${POP}_n*_N*.hdf" | head -1)
        
        # Skip if lookup table doesn't exist
        if [[ ! -f "$TABLEFILE" ]]; then
            echo "Skipping $POP - Contig $CONTIG: Lookup table not found"
            continue
        fi
        
        # Get hyperparameters file
        HYPERPARAM_FILE="pyrho_filt_out/${POP}_hyperparam_results.txt"
        
        # Skip if hyperparameters file doesn't exist
        if [[ ! -f "$HYPERPARAM_FILE" ]]; then
            echo "Skipping $POP - Contig $CONTIG: Hyperparam file not found"
            continue
        fi
        
        # Extract best hyperparameters
        BLOCK_PENALTY=$(awk 'NR>1 {if(max==""){max=$4; bp=int($1); ws=int($2)} else if($4>max){max=$4; bp=int($1); ws=int($2)}} END {print bp}' "$HYPERPARAM_FILE")
        WINDOW_SIZE=$(awk 'NR>1 {if(max==""){max=$4; bp=int($1); ws=int($2)} else if($4>max){max=$4; bp=int($1); ws=int($2)}} END {print ws}' "$HYPERPARAM_FILE")
        
        # Skip if hyperparameters couldn't be extracted
        if [[ -z "$BLOCK_PENALTY" || -z "$WINDOW_SIZE" ]]; then
            echo "Skipping $POP - Contig $CONTIG: Failed to extract hyperparameters"
            continue
        fi
        
        echo "Processing $POP - Contig $CONTIG (bp: $BLOCK_PENALTY, ws: $WINDOW_SIZE)"
        
        # Run pyrho optimize with numthreads parameter
        pyrho optimize --tablefile "$TABLEFILE" \
            --vcffile "$VCF_FILE" \
            --outfile "$OUT_RMAP" \
            --blockpenalty "$BLOCK_PENALTY" \
            --windowsize "$WINDOW_SIZE" \
            --numthreads 4 \
            --logfile "pyrho_filt_out/${POP}_${CONTIG}.log"
        
        echo "Completed: $POP - Contig $CONTIG"
    done
done

echo "All pyrho optimize processing completed."