#!/usr/bin/env python3
import sys
import gzip
import csv
import pysam

"""
Usage:
  python correct_vcf_per_chrom.py <chromosome> <vcf.gz> <ancestral.tsv.gz>

Outputs:
  - ref_equals_ancestral.<chrom>.vcf.gz
  - ref_equals_ancestral.<chrom>.summary.tsv

This version:
  • Tracks the requested statistics:
      num_sites, num_var, num_invar, num_anc, num_sites_with_anc,
      num_var_with_anc, num_invar_with_anc,
      var_anc_match, invar_anc_match,
      var_anc_flip,  invar_anc_flip,
      var_anc_nomatch, invar_anc_nomatch
  • Invariant-site update when ancestral != REF:
      - REF becomes ancestral (AA)
      - ALT becomes the original REF
      - All 0/0 become 1/1; missing ./ . stays missing
"""

# ---------- Args ----------
if len(sys.argv) != 4:
    sys.stderr.write("Usage: python correct_vcf_per_chrom.py <chromosome> <vcf.gz> <ancestral.tsv.gz>\n")
    sys.exit(1)

chrom_target = sys.argv[1]
vcf_path = sys.argv[2]
ancestral_path = sys.argv[3]

output_path  = f"ref_equals_ancestral.{chrom_target}.vcf.gz"
summary_path = f"ref_equals_ancestral.{chrom_target}.summary.tsv"

# ---------- Read ALL ancestral calls for this chromosome ----------
# We keep only rows with a non-empty Anc1; positions are converted 0->1 based.
ancestral = {}  # key: (chrom, pos1) -> (Urar, Anc1)
num_anc = 0

with gzip.open(ancestal_path if (ancestal_path := ancestral_path) else ancestral_path, "rt") as f:
    header = f.readline().rstrip("\n").split("\t")
    idx = {c: i for i, c in enumerate(header)}
    # Required columns: refSequence, refPosition (0-based), Urar, Anc1
    for line in f:
        parts = line.rstrip("\n").split("\t")
        chrom = parts[idx["refSequence"]]
        if chrom != chrom_target:
            continue
        anc1 = parts[idx["Anc1"]].strip().upper() if len(parts) > idx["Anc1"] else ""
        if anc1 == "":
            continue
        pos1 = int(parts[idx["refPosition"]]) + 1  # 0-based -> 1-based (VCF)
        urar = parts[idx["Urar"]].strip().upper()
        ancestral[(chrom, pos1)] = (urar, anc1)
        num_anc += 1

# ---------- Open VCF I/O ----------
vcf_in = pysam.VariantFile(vcf_path, "r")
hdr = vcf_in.header.copy()

# Ensure AA INFO + GT FORMAT exist
if "AA" not in hdr.info:
    hdr.info.add("AA", 1, "String", "Ancestral allele")
if "GT" not in hdr.formats:
    hdr.formats.add("GT", 1, "String", "Genotype")

vcf_out = pysam.VariantFile(output_path, "wz", header=hdr)
valid_info_keys = set(hdr.info.keys())

# ---------- Counters ----------
num_sites  = 0         # all records in this chromosome (variant + invariant)
num_var    = 0         # variant records (alts != None and not symbolic)
num_invar  = 0         # invariant records (alts is None)

# Overlap counts with ancestral dictionary
num_sites_with_anc   = 0
num_var_with_anc     = 0
num_invar_with_anc   = 0

# Classification (only among sites that HAVE an ancestral call)
var_anc_match     = 0
var_anc_flip      = 0
var_anc_nomatch   = 0
invar_anc_match   = 0
invar_anc_flip    = 0
invar_anc_nomatch = 0

# ---------- Helpers ----------
def is_symbolic_variant(rec):
    return rec.alts is not None and any(str(a).startswith("<") for a in rec.alts)

def copy_common_fields(src, dst):
    dst.contig = src.contig
    dst.start  = src.start
    dst.id     = src.id
    dst.qual   = src.qual
    dst.filter.clear()
    for f in src.filter.keys():
        dst.filter.add(f)

def remap_genotype(gt, allele_map):
    """
    Map each allele index according to allele_map (dict old->new).
    Keep None (missing) untouched; leave other integers untouched if unseen.
    """
    if gt is None:
        return None
    new = []
    for a in gt:
        if a is None:
            new.append(None)
        else:
            new.append(allele_map.get(a, a))
    return tuple(new)

# ---------- Main loop ----------
for rec in vcf_in.fetch(chrom_target):
    num_sites += 1
    key = (rec.chrom, rec.pos)

    # Invariant site
    if rec.alts is None:
        num_invar += 1
        has_anc = key in ancestral
        if has_anc:
            num_sites_with_anc += 1
            num_invar_with_anc += 1
            urar, anc1 = ancestral[key]

            # Sanity: ensure the table's Urar matches the VCF REF (same reference build)
            if rec.ref.upper() != urar:
                # If these don't match, we can't safely reinterpret this locus; count as "nomatch".
                invar_anc_nomatch += 1
                continue

            if rec.ref.upper() == anc1:
                # REF already equals ancestral
                invar_anc_match += 1
                # Nothing to write (still invariant), but we could emit a copy with AA if desired.
                continue
            else:
                # REF != ancestral -> flip invariant site as requested:
                # new REF = ancestral; new ALT = original REF; all 0/0 -> 1/1; ./ . untouched
                invar_anc_flip += 1
                invar_anc_nomatch += 1  # also counts as "ref does not match ancestral"

                rec_copy = vcf_out.new_record()
                copy_common_fields(rec, rec_copy)
                rec_copy.ref  = anc1
                rec_copy.alts = (rec.ref,)  # original REF becomes ALT
                rec_copy.info["AA"] = anc1

                for sample in rec.samples:
                    gt = rec.samples[sample].get("GT")
                    # Flip only definite 0/0 to 1/1; leave missing as missing
                    if gt is None or any(a is None for a in gt):
                        rec_copy.samples[sample]["GT"] = gt
                    else:
                        # If caller somehow encoded non 0/0 at an invariant record, preserve structure but push to ALT
                        # Typical invariant will be (0,0); we map 0->1.
                        allele_map = {0: 1}
                        rec_copy.samples[sample]["GT"] = remap_genotype(gt, allele_map)

                vcf_out.write(rec_copy)
        else:
            # no ancestral call for this site
            pass
        continue  # done with invariant

    # Symbolic ALT variants are ignored for all statistics except num_sites (we do NOT count them in num_var)
    if is_symbolic_variant(rec):
        continue

    # Non-symbolic variant
    num_var += 1
    has_anc = key in ancestral
    if has_anc:
        num_sites_with_anc += 1
        num_var_with_anc   += 1
        urar, anc1 = ancestral[key]

        # Sanity check against Urar
        if rec.ref.upper() != urar:
            # Can't reconcile—treat as nomatch and skip
            var_anc_nomatch += 1
            continue

        refU = rec.ref.upper()
        altsU = [a.upper() for a in rec.alts]

        if anc1 == refU:
            # Ancestral equals REF -> write unchanged (but add AA)
            var_anc_match += 1

            rec_copy = vcf_out.new_record()
            copy_common_fields(rec, rec_copy)
            rec_copy.ref  = rec.ref
            rec_copy.alts = rec.alts
            # Preserve existing INFO except unknown keys (header check)
            for k, v in rec.info.items():
                if k in valid_info_keys:
                    rec_copy.info[k] = v
            rec_copy.info["AA"] = anc1

            # Copy GTs as-is
            for sample in rec.samples:
                gt = rec.samples[sample].get("GT")
                if gt is not None:
                    rec_copy.samples[sample]["GT"] = gt

            vcf_out.write(rec_copy)

        elif anc1 in altsU:
            # Ancestral equals one of the ALTs -> flip so REF becomes ancestral
            var_anc_flip += 1
            flip_idx = altsU.index(anc1)

            new_ref  = rec.alts[flip_idx]           # ancestral
            new_alts = [rec.ref] + [a for i, a in enumerate(rec.alts) if i != flip_idx]

            rec_copy = vcf_out.new_record()
            copy_common_fields(rec, rec_copy)
            rec_copy.ref  = new_ref
            rec_copy.alts = tuple(new_alts)

            # Copy INFO but drop AC/AF/AN (no longer correct after flipping)
            for k, v in rec.info.items():
                if k in valid_info_keys and k not in ("AC", "AF", "AN"):
                    rec_copy.info[k] = v
            rec_copy.info["AA"] = anc1

            # Build a complete allele index remap: old->new
            # old indices: 0 = old REF, 1..n = old ALTs
            # new: 0 = old ALT[flip_idx], 1 = old REF, 2.. = remaining old ALTs (order preserved)
            old_ref = rec.ref
            old_alts = list(rec.alts)
            # Map by strings (robust for multi-allelic)
            new_index_by_allele = {("REF", new_ref): 0}
            # new 1 is old REF
            new_index_by_allele[("REF", old_ref)] = 1
            # Fill remaining new indices (2..) with the other old ALTs
            rem_alts = [a for i, a in enumerate(old_alts) if i != flip_idx]
            for j, a in enumerate(rem_alts, start=2):
                new_index_by_allele[("ALT", a)] = j

            # Construct old->new numeric mapping
            allele_map = {0: 1}  # old REF -> new index 1
            # flipped ALT -> 0
            allele_map[flip_idx + 1] = 0
            # other ALTs
            for i, a in enumerate(old_alts):
                if i == flip_idx:
                    continue
                old_num = i + 1
                allele_map[old_num] = new_index_by_allele[("ALT", a)]

            # Remap GTs
            for sample in rec.samples:
                gt = rec.samples[sample].get("GT")
                rec_copy.samples[sample]["GT"] = remap_genotype(gt, allele_map)

            vcf_out.write(rec_copy)

        else:
            # Ancestral doesn't match REF or any ALT -> count and skip
            var_anc_nomatch += 1

    else:
        # No ancestral call for this variant; we simply do not modify or count match/flip buckets.
        pass

# ---------- Close ----------
vcf_in.close()
vcf_out.close()

# Derive num_invar from totals counted
num_invar = num_sites - num_var

# ---------- Write summary TSV ----------
with open(summary_path, "w", newline="") as outtsv:
    w = csv.writer(outtsv, delimiter="\t")
    w.writerow([
        "chrom",
        "num_sites", "num_var", "num_invar",
        "num_anc",
        "num_sites_with_anc", "num_var_with_anc", "num_invar_with_anc",
        "var_anc_match", "invar_anc_match",
        "var_anc_flip",  "invar_anc_flip",
        "var_anc_nomatch","invar_anc_nomatch"
    ])
    w.writerow([
        chrom_target,
        num_sites, num_var, num_invar,
        num_anc,
        num_sites_with_anc, num_var_with_anc, num_invar_with_anc,
        var_anc_match, invar_anc_match,
        var_anc_flip,  invar_anc_flip,
        var_anc_nomatch, invar_anc_nomatch
    ])

print(f"[{chrom_target}] Done. Wrote: {output_path} and {summary_path}")

                               
