import pysam
import gzip
import sys
import csv

# === Setup ===
if len(sys.argv) != 4:
    sys.stderr.write("Usage: python correct_vcf_per_chrom.py <chromosome> <vcf.gz> <ancestral.tsv.gz>\n")
    sys.exit(1)

chrom_target = sys.argv[1]
vcf_path = sys.argv[2]
ancestral_path = sys.argv[3]
output_path = f"ref_equals_ancestral.{chrom_target}.vcf.gz"
summary_path = f"ref_equals_ancestral.{chrom_target}.summary.tsv"

# === Read ancestral data for the chromosome ===
ancestral_dict = {}
n_missing_anc1 = 0
with gzip.open(ancestral_path, "rt") as f:
    header = f.readline().strip().split("\t")
    col_idx = {col: i for i, col in enumerate(header)}

    for line in f:
        parts = line.strip().split("\t")
        chrom = parts[col_idx["refSequence"]]
        if chrom != chrom_target:
            continue
        anc1 = parts[col_idx["Anc1"]].strip().upper() if len(parts) > col_idx["Anc1"] else ""
        if anc1 == "":
            n_missing_anc1 += 1
            continue
        pos = int(parts[col_idx["refPosition"]]) + 1
        urar = parts[col_idx["Urar"]].strip().upper()
        ancestral_dict[(chrom, pos)] = (urar, anc1)

# === Prepare VCF input/output ===
vcf_in = pysam.VariantFile(vcf_path, "r")
vcf_header = vcf_in.header.copy()
vcf_header.info.add("AA", 1, "String", "Ancestral allele")
if "GT" not in vcf_header.formats:
    vcf_header.formats.add("GT", 1, "String", "Genotype")
vcf_out = pysam.VariantFile(output_path, "wz", header=vcf_header)

valid_info_keys = set(vcf_header.info.keys())

# === Counters ===
n_total = n_ref_match = n_flipped = n_nomatch = n_written = n_unmapped = 0
n_nonvariant = n_symbolic_alt = 0
ancestral_alleles = 0
derived_alleles = 0
invar_total = invar_anc_match = invar_anc_mismatch = invar_anc_missing = invar_no_anc = 0

# === Main processing ===
for rec in vcf_in.fetch(chrom_target):
    n_total += 1
    key = (rec.chrom, rec.pos)

    # Non-variant site
    if rec.alts is None:
        n_nonvariant += 1
        invar_total += 1
        if key not in ancestral_dict:
            invar_no_anc += 1
            continue
        urar, anc1 = ancestral_dict[key]
        if anc1 == "":
            invar_anc_missing += 1
            continue
        if rec.ref.upper() == anc1:
            invar_anc_match += 1
            continue
        else:
            invar_anc_mismatch += 1
            # Write as homozygous derived (1/1) with ancestral in AA
            fake_alt = anc1
            rec_copy = vcf_out.new_record()
            rec_copy.contig = rec.contig
            rec_copy.start = rec.start
            rec_copy.id = rec.id
            rec_copy.ref = rec.ref
            rec_copy.alts = [fake_alt]
            rec_copy.qual = rec.qual
            rec_copy.filter.clear()
            for f in rec.filter.keys():
                rec_copy.filter.add(f)
            rec_copy.info["AA"] = anc1
            for sample in rec.samples:
                rec_copy.samples[sample]["GT"] = (1, 1)
                derived_alleles += 2
            vcf_out.write(rec_copy)
            n_written += 1
            continue

    # Symbolic ALT (skip)
    if any(str(alt).startswith("<") for alt in rec.alts):
        n_symbolic_alt += 1
        continue

    # Process variant site
    if key not in ancestral_dict:
        n_unmapped += 1
        continue
    urar, anc1 = ancestral_dict[key]
    if rec.ref.upper() != urar:
        continue
    n_ref_match += 1
    alt_alleles = [a.upper() for a in rec.alts]

    # --- Case 1: Anc == REF ---
    if anc1 == rec.ref.upper():
        rec_copy = vcf_out.new_record()
        rec_copy.contig = rec.contig
        rec_copy.start = rec.start
        rec_copy.id = rec.id
        rec_copy.ref = rec.ref
        rec_copy.alts = rec.alts
        rec_copy.qual = rec.qual
        rec_copy.filter.clear()
        for f in rec.filter.keys():
            rec_copy.filter.add(f)
        for k, v in rec.info.items():
            if k in valid_info_keys:
                rec_copy.info[k] = v
        rec_copy.info["AA"] = anc1
        for sample in rec.samples:
            if "GT" in rec.samples[sample]:
                gt = rec.samples[sample]["GT"]
                rec_copy.samples[sample]["GT"] = gt
                if gt:
                    for allele in gt:
                        if allele == 0:
                            ancestral_alleles += 1
                        elif allele == 1:
                            derived_alleles += 1
        vcf_out.write(rec_copy)
        n_written += 1
        continue

    # --- Case 2: Anc == ALT ---
    if anc1 in alt_alleles:
        flip_idx = alt_alleles.index(anc1)
        new_ref = rec.alts[flip_idx]
        new_alts = [rec.ref] + [a for i, a in enumerate(rec.alts) if i != flip_idx]
        rec_copy = vcf_out.new_record()
        rec_copy.contig = rec.contig
        rec_copy.start = rec.start
        rec_copy.id = rec.id
        rec_copy.ref = new_ref
        rec_copy.alts = tuple(new_alts)
        rec_copy.qual = rec.qual
        rec_copy.filter.clear()
        for f in rec.filter.keys():
            rec_copy.filter.add(f)
        for k, v in rec.info.items():
            if k in valid_info_keys and k not in ["AC", "AF", "AN"]:
                rec_copy.info[k] = v
        rec_copy.info["AA"] = anc1
        for sample in rec.samples:
            if "GT" in rec.samples[sample]:
                gt = rec.samples[sample]["GT"]
                if gt:
                    new_gt = tuple(1 if a == 0 else 0 if a == 1 else a for a in gt)
                    rec_copy.samples[sample]["GT"] = new_gt
                    for allele in new_gt:
                        if allele == 0:
                            ancestral_alleles += 1
                        elif allele == 1:
                            derived_alleles += 1
        vcf_out.write(rec_copy)
        n_flipped += 1
        n_written += 1
        continue

    # --- Case 3: Anc does not match REF or ALT ---
    n_nomatch += 1

vcf_in.close()
vcf_out.close()

# === Write summary ===
with open(summary_path, "w", newline="") as outtsv:
    writer = csv.writer(outtsv, delimiter="\t")
    writer.writerow([
        "chrom", "total_variants", "nonvariant_skipped", "symbolic_skipped",
        "ancestral_calls", "missing_anc1", "ref_match", "unchanged_sites",
        "flipped_sites", "nomatch_sites", "sites_written",
        "ancestral_alleles", "derived_alleles",
        "invariant_total", "invariant_anc_match", "invariant_anc_mismatch",
        "invariant_anc_missing", "invariant_no_anc_entry"
    ])
    writer.writerow([
        chrom_target, n_total, n_nonvariant, n_symbolic_alt,
        len(ancestral_dict), n_missing_anc1, n_ref_match, n_written - n_flipped,
        n_flipped, n_nomatch, n_written, ancestral_alleles, derived_alleles,
        invar_total, invar_anc_match, invar_anc_mismatch,
        invar_anc_missing, invar_no_anc
    ])
print(f"Finished {chrom_target}")                                    
