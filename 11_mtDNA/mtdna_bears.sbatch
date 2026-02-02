
ml biology angsd/0.931

#create consensus sequences for all bam files
for file in *.bam;do
  bn=`basename $file .bam`
  angsd -i ${bn}.bam -r NC_003427.1 -ref ../reference_files/GCF_023065955.2_UrsArc2.0_genomic.fna \
  -doCounts 1 -doFasta 2 -minQ 20 -minmapq 30 -C 50 -P 50 -setMinDepthInd 5 -out ${bn}.mtdna
done

#unzip and then concatenate all mtdna sequences together
for file in *.mtdna.fa.gz;do gunzip $file ;done
cat *.mtdna.fa > WGS_polar_EuroBB_May2625.fa

#alignment
conda activate mafft
INPUT="WGS_polar_EuroBB_May2625_renamed.fa"
ALIGNMENT="WGS_polar_EuroBB_May2625_renamed_aligned.fa"
TRIMMED="WGS_polar_EuroBB_May2625_renamed_aligned_trimmed.fasta"
FILTERED="WGS_polar_EuroBB_May2625_renamed_aligned_trimmed_filtered5.fasta"
TREE_PREFIX="WGS_polar_EuroBB_May2625_renamed_aligned_trimmed_filtered5"

#align
mafft --auto "$INPUT" > "$ALIGNMENT"

#trim
/oak/stanford/groups/dpetrov/armstrong/applications/trimal/source/trimal -automated1 -in "$ALIGNMENT" -out "$TRIMMED"

ml biology samtools
module load biology py-biopython/1.84_py312

python3 - <<EOF
from Bio import SeqIO
from collections import defaultdict, Counter

input_file = "$TRIMMED"
output_file = "$FILTERED"
max_missing = 0.05  # 5%

# Load and filter sequences
sequences = list(SeqIO.parse(input_file, "fasta"))
alignment_length = len(sequences[0].seq)

filtered_seqs = {}  # Store ID: sequence string
with open(output_file, "w") as out_f:
    for record in sequences:
        seq_str = str(record.seq).upper()
        missing = seq_str.count("N") + seq_str.count("-")
        if missing / alignment_length <= max_missing:
            filtered_seqs[record.id] = seq_str
            SeqIO.write(record, out_f, "fasta")

# Count singletons per individual (to make sure there is no foolery happening)
singleton_counts = defaultdict(int)
seq_ids = list(filtered_seqs.keys())
seq_matrix = [list(filtered_seqs[seq_id]) for seq_id in seq_ids]

for i in range(alignment_length):
    column = [seq[i] for seq in seq_matrix]
    col_counts = Counter([b for b in column if b not in ("N", "-")])

    if len(col_counts) == 0:
        continue  # All missing
    for base, count in col_counts.items():
        if count == 1:
            for idx, b in enumerate(column):
                if b == base:
                    singleton_counts[seq_ids[idx]] += 1
                    break

 Print results
print("\nSingletons per individual (after filtering):")
for seq_id in seq_ids:
    print(f"{seq_id}\t{singleton_counts[seq_id]}")
EOF


conda activate iqtree-v2.3.4
#build tree
iqtree -s "$TRIMMED" -m MFP -bb 1000 -alrt 1000 -nt AUTO -pre "$TREE_PREFIX" --redo

                                            
