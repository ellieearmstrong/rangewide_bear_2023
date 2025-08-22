#!/bin/bash

module purge
module load singularity

mkdir -p smc_out_filt
export OMP_NUM_THREADS=2

# Explicitly listed population directories
POPULATIONS=("abc" "abc1" "ak15" "ak26" "alberta" "bc_central" "gye" "hudson_bay" "kenai" "kodiak" "ncde" "selk_yaak")

# Iterate over the explicitly listed population directories
for POP in "${POPULATIONS[@]}"; do
    POP_DIR="smc_vcf_masks/${POP}"
    
    if [ -d "$POP_DIR" ]; then  # Check if the directory exists
        echo "Running SMC++ estimate for $POP"

        # Run estimate on all .smc.gz files within the population directory
        singularity run -C --bind $PWD --pwd $PWD smcpp_latest.sif estimate --mu 0.92e-8 \
            "$POP_DIR"/*.smc.gz \
            --o smc_out_filt --base bear_${POP}_default -v --cores 10
    else
        echo "Warning: Directory $POP_DIR does not exist. Skipping."
    fi
done

# Run a single plot including all JSON files in the output directory
if ls smc_out_filt/*.final.json 1> /dev/null 2>&1; then
    echo "Generating combined plot for all JSON files in smc_out_filt..."
    singularity run -C --bind $PWD --pwd $PWD smcpp_latest.sif plot -c \
        smc_out_filt/bear_all_default_plot.pdf \
        smc_out_filt/*.final.json -g 10
else
    echo "No JSON files found in smc_out_filt, skipping plot generation."
fi

echo "SMC++ estimation and combined plotting complete for all specified populations."