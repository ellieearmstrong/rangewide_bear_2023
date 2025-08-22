#!/bin/bash

module load bcftools
module load vcftools

###############################################################################
# 0. Set Paths
###############################################################################
# Output directory for SFS analysis
mkdir -p top6_sfs

# Population list
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

# Number of chromosomes for 6 diploid individuals
N_CHR=12

###############################################################################
# 1. SFS Function
###############################################################################
run_sfs_top6() {
    local pop=$1
    local input_vcf="filtered_vcf_sfs/${pop}.vcf.gz"
    local input_idepth="filtered_vcf_sfs/${pop}.idepth"
    
    # Check if input files exist
    if [[ ! -f "$input_vcf" ]]; then
        echo "Error: VCF file not found: $input_vcf"
        return 1
    fi
    
    if [[ ! -f "$input_idepth" ]]; then
        echo "Error: Depth file not found: $input_idepth"
        return 1
    fi
    
    echo "Processing population: $pop"
    echo "Input VCF: $input_vcf"
    echo "Input depth: $input_idepth"
    
    # Output files
    local top6_samples="top6_sfs/${pop}_top6_samples.txt"
    local filtered_vcf="top6_sfs/${pop}_top6.vcf.gz"
    local bcftools_log="top6_sfs/${pop}_top6_bcftools.log"
    local vcftools_log="top6_sfs/${pop}_top6.log"
    local frq_count_file="top6_sfs/${pop}_top6.frq.count"
    local count_file="top6_sfs/${pop}_top6.count"
    local summary_file="top6_sfs/${pop}_top6_snp_summary.txt"
    local sfs_file="top6_sfs/${pop}_top6_sfs.txt"

    # 1.1 Get top 6 individuals by depth
    echo "Selecting top 6 individuals by depth for $pop..."
    tail -n +2 "$input_idepth" | \
    sort -k3,3nr | \
    head -6 | \
    cut -f1 > "$top6_samples"
    
    n_samples=$(wc -l < "$top6_samples")
    echo "Selected $n_samples individuals:"
    cat "$top6_samples"
    
    if [[ $n_samples -lt 6 ]]; then
        echo "Warning: Only $n_samples individuals available for $pop (less than 6)"
    fi

    # 1.2 Filter VCF to top 6 individuals
    echo "Filtering VCF for top 6 individuals..."
    bcftools view \
        -S "$top6_samples" \
        -O z \
        -o "$filtered_vcf" \
        "$input_vcf" 2>> "$bcftools_log"

    # 1.3 Run vcftools --counts
    echo "Running vcftools counts for $pop top 6..."
    vcftools --gzvcf "$filtered_vcf" --counts --out "top6_sfs/${pop}_top6" &> "$vcftools_log"

    # vcftools writes ${pop}_top6.frq.count into top6_sfs
    mv "top6_sfs/${pop}_top6.frq.count" "$frq_count_file"

    # 1.4 Convert the .frq.count to tab-delimited .count file
    sed -e 's/:/\t/g' "$frq_count_file" > "$count_file"

    # 1.5 Create SNP summary (fixed, singleton, others)
    awk 'NR>1 {
        count1 = $6 + 0;
        count2 = $8 + 0;
        if (count1 == 1 || count2 == 1)
            singleton++;
        else if (count1 == 0 || count2 == 0)
            fixed++;
        else
            others++;
    }
    END {
        print fixed, singleton, others
    }' "$count_file" > "$summary_file"

    # 1.6 Calculate the Site Frequency Spectrum (SFS)
    echo "Calculating SFS for $pop top 6..."
    awk -v n_chr="$N_CHR" '
    BEGIN { FS="\t"; OFS="\t" }
    NR > 1 && $4 == n_chr {
        # Bin by min & max allele counts
        min_count = ($6 < $8) ? $6 : $8
        max_count = ($6 >= $8) ? $6 : $8
        sfs[min_count "," max_count]++
    }
    END {
        for (bin in sfs) {
            print bin, sfs[bin]
        }
    }' "$count_file" > "$sfs_file"

    # 1.7 Get final stats
    n_sites=$(bcftools view -H "$filtered_vcf" | wc -l)
    
    echo "Done with SFS for $pop top 6!"
    echo "Top 6 samples: $top6_samples"
    echo "Filtered VCF:  $filtered_vcf"
    echo "Sites retained: $n_sites"
    echo "Log files:     $bcftools_log, $vcftools_log"
    echo "Counts:        $count_file"
    echo "Summary:       $summary_file"
    echo "SFS:           $sfs_file"
    echo ""
}

###############################################################################
# 2. Run SFS for Each Population
###############################################################################
for pop in "${POPULATIONS[@]}"; do
    run_sfs_top6 "$pop"
done

echo "All analyses completed! Outputs in: top6_sfs"

# Create summary of all populations
echo "Creating summary of all populations..."
echo -e "POPULATION\tTOP6_INDIVIDUALS\tSITES_RETAINED" > "top6_sfs/all_populations_top6_summary.txt"

for pop in "${POPULATIONS[@]}"; do
    if [[ -f "top6_sfs/${pop}_top6.vcf.gz" ]]; then
        n_individuals=$(wc -l < "top6_sfs/${pop}_top6_samples.txt" 2>/dev/null || echo "0")
        n_sites=$(bcftools view -H "top6_sfs/${pop}_top6.vcf.gz" 2>/dev/null | wc -l || echo "0")
        echo -e "${pop}\t${n_individuals}\t${n_sites}"
    fi
done >> "top6_sfs/all_populations_top6_summary.txt"

echo "Summary file created: top6_sfs/all_populations_top6_summary.txt"