#!/bin/bash

# Load Conda environment
eval "$(conda shell.bash hook)"
conda activate my-pyrho-env

# Define populations and sample sizes
POPS=("AK-26" "AK-15" "Kenai" "Kodiak" "ABC1" "ABC" "HudsonBay" "Alberta" "BC_Central" "Selk_Yaak" "NCDE" "GYE")
SAMPLES=(12 6 12 13 13 11 11 14 9 16 14 11)

# Ensure output directory exists
mkdir -p pyrho_filt_out

# Process each population
for i in "${!POPS[@]}"; do
    POP=${POPS[$i]}
    SAMPLE_SIZE=${SAMPLES[$i]}
    
    echo "Processing population: $POP (sample size: $SAMPLE_SIZE)"
    
    # Calculate n (double the sample size)
    n_VAL=$((SAMPLE_SIZE * 2))
    
    # Calculate N (25% larger than n, automatically rounded up)
    N_VAL=$(echo "$n_VAL * 1.25" | bc)  
    N_VAL=${N_VAL%.*}  # Convert to integer by truncating decimal
    
    # Define input and output file paths
    INPUT_CSV="smc_out_filt/${POP}.csv"
    OUT_HDF="pyrho_filt_out/${POP}_n${n_VAL}_N${N_VAL}.hdf"
    OUT_HYPERPARAM="pyrho_filt_out/${POP}_hyperparam_results.txt"
    
    # Check if input CSV exists
    if [ ! -f "$INPUT_CSV" ]; then
        echo "Warning: Input file $INPUT_CSV not found for population $POP. Skipping."
        continue
    fi
    
    echo "Running pyrho make_table for $POP (n=$n_VAL, N=$N_VAL)"
    
    # Run pyrho make_table with `--approx` flag
    pyrho make_table --smcpp_file "$INPUT_CSV" -n "$n_VAL" -N "$N_VAL" --mu 0.92e-8 --numthreads 4 --approx --outfile "$OUT_HDF"
    
    # Ensure the .hdf file was created before proceeding
    if [ ! -f "$OUT_HDF" ]; then
        echo "Error: $OUT_HDF was not created. Skipping hyperparam step for $POP."
        continue
    fi
    
    echo "Running pyrho hyperparam for $POP"
    
    # Run pyrho hyperparam
    pyrho hyperparam -n "$n_VAL" --ploidy 2 --mu 0.92e-8 --blockpenalty 50,100 --windowsize 25,50 \
        --tablefile "$OUT_HDF" --num_sims 3 --smcpp_file "$INPUT_CSV" --outfile "$OUT_HYPERPARAM"
    
    echo "pyrho processing for $POP completed."
done

echo "All pyrho processing completed."