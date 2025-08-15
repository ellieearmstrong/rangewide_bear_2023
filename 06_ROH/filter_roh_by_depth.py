import sys
import os
import pandas as pd
from datetime import datetime

# Usage: python filter_roh_by_depth.py <ROH_FILENAME>

if len(sys.argv) != 2:
    print("Usage: python filter_roh_by_depth.py <ROH_FILENAME>")
    sys.exit(1)

roh_filename = sys.argv[1]
roh_dir = "06_ROH/processing/"
depth_file = "allbears.M2.repmap1.indels.DPfilt.QUAL30.drop20miss4dp.AN522.nonref.full.rename.mean"
output_dir = "individual_outputs"

# Make sure output directory exists
os.makedirs(output_dir, exist_ok=True)

print(f"[{datetime.now()}] Processing file: {roh_filename}", flush=True)

# Load depth data
depth_df = pd.read_csv(depth_file, sep="\t")
depth_df["CHROM"] = depth_df["CHROM"].astype(str)
depth_by_chrom = {chrom: df for chrom, df in depth_df.groupby("CHROM")}

filepath = os.path.join(roh_dir, roh_filename)
individual = roh_filename.replace("_GARLICroh.txt", "")
out_file = os.path.join(output_dir, f"{individual}_filtered.tsv")

# Load and filter ROH
df = pd.read_csv(filepath, sep="\t", header=None, usecols=[0, 1, 2, 3, 4])
df.columns = ["Chrom", "Start", "End", "Size_Class", "ROH_Length"]
df = df[df["ROH_Length"] >= 100000]
df["Chrom"] = df["Chrom"].str.replace("^chr", "", regex=True)
df["Individual"] = individual

# Depth lookup
def calculate_depth_metrics(row):
    chrom = row["Chrom"]
    start = row["Start"]
    end = row["End"]
    region_depth = depth_by_chrom.get(chrom, pd.DataFrame())
    region = region_depth[(region_depth["POS"] >= start) & (region_depth["POS"] <= end)]
    num_sites = len(region)
    mean_depth = region["MEAN_DEPTH"].mean() if num_sites > 0 else 0
    return pd.Series([num_sites, mean_depth])

df[["Depth_Sites", "Mean_Depth"]] = df.apply(calculate_depth_metrics, axis=1)

# Write result
df.to_csv(out_file, sep="\t", index=False)
print(f"[{datetime.now()}] Finished processing {roh_filename}, wrote to {out_file}", flush=True)
