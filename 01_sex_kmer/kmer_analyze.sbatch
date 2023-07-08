



module load bbtools/38.91

for file in *_R1_001.fastq.gz
	bn=`basename $file _R1_001.fastq.gz
	bbduk.sh in=${bn}_R1_001.fastq.gz in2=${bn}_R2_001.fastq.gz ref=/data/kelley/projects/ellie_projects/rangewide_bear/rangewide_bear_2023/01_sex_kmer/ursus_only_male_kmers.txt.fasta outm=${bn}_R1_m outm2=.fastq ${bn}_R2_m.fastq k=21
done
