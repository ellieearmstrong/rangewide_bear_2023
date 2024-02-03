#!/bin/bash
#SBATCH --job-name=merge_bear_bams
#SBATCH --time=48:00:00
#SBATCH --mem=240000
#SBATCH --partition=normal,hns,dpetrov
#SBATCH -n 24
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=ellieearmstrong@gmail.com


#code for merging bams for rangewide bear project
#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 95258_merged.female.bam 18032FL-158-01-11_S15_L007.female.bam 22116FL-09-01-11_S17_L004.female.bam 22116FL-03-01-16_S16_L002.female.bam 22116FL-07-01-05_S5.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 94292_merged.female.bam 22116FL-03-01-11_S11_L002.female.bam 22116FL-07-01-02_S2.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 93839_merged.male.bam 22116FL-03-01-07_S7_L002.male.bam 18032FL-150-04-03_S3_L005.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 92035_merged.male.bam 22116FL-03-01-06_S6_L002.male.bam 18032FL-150-07-05_S1001_L100.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 91893_merged.male.bam 22116FL-03-01-05_S5_L002.male.bam 18032FL-150-04-01_S1_L005.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 91635_merged.male.bam 22116FL-07-01-01_S1.male.bam 22116FL-03-01-10_S10_L002.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90901_merged.female.bam 22116FL-03-01-18_S18_L002.female.bam 22116FL-07-01-04_S4.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 94289_merged.female.bam 18032FL-150-04-05_S5_L005.female.bam 22116FL-03-01-09_S9_L002.female.bam 22116FL-09-01-10_S16_L004.female.bam 18032FL-158-01-10_S14_L007.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 93269_merged.female.bam 18032FL-150-07-04_S1001_L100.female.bam 22116FL-03-01-35_S35_L002.female.bam 22116FL-09-01-09_S15_L004.female.bam 18032FL-158-01-09_S13_L007.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 92377_merged.female.bam 18032FL-150-04-04_S4_L005.female.bam 22116FL-09-01-08_S14_L004.female.bam 18032FL-158-01-08_S12_L007.female.bam 22116FL-03-01-01_S1_L002.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 92371_merged.female.bam 22116FL-09-01-07_S13_L004.female.bam 18032FL-158-01-07_S11_L007.female.bam 18032FL-129-03-12_S22_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 91946_merged.male.bam 18032FL-158-01-06_S10_L007.male.bam 22116FL-03-01-02_S2_L002.male.bam 22116FL-09-01-06_S12_L004.male.bam 18032FL-150-04-02_S2_L005.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 91849_merged.male.bam 18032FL-158-01-05_S9_L007.male.bam 22116FL-09-01-05_S11_L004.male.bam 18032FL-129-02-03_S5_L001.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 91813_merged.female.bam 22116FL-09-01-04_S10_L004.female.bam 18032FL-158-01-04_S8_L007.female.bam 18032FL-129-03-09_S19_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90932_merged.male.bam 18032FL-129-03-10_S20_L001.male.bam 18032FL-158-01-03_S7_L007.male.bam 22116FL-09-01-03_S9_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90675_merged.male.bam 18032FL-152-02-06_S6.male.bam 22116FL-03-01-03_S3_L002.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90565_merged.female.bam 22116FL-07-01-03_S3.female.bam 22116FL-03-01-04_S4_L002.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90199_merged.male.bam 18032FL-129-03-05_S15_L001.male.bam 18032FL-158-01-02_S6_L007.male.bam 22116FL-09-01-02_S8_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 90085_merged.female.bam 22116FL-09-01-01_S7_L004.female.bam 18032FL-158-01-01_S5_L007.female.bam 18032FL-129-03-11_S21_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206500_merged.male.bam 22116FL-09-01-12_S18_L004.male.bam 206500_S1_L001.male.bam 18032FL-158-01-12_S16_L007.male.bam 22116FL-07-01-06_S6.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206501_merged.female.bam 206501_S2_L001.female.bam 22116FL-07-01-07_S7.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206502_merged.male.bam 206502_S3_L001.male.bam 22116FL-07-01-08_S8.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206503_merged.male.bam 206503_S4_L001.male.bam 22116FL-07-01-09_S9.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206504_merged.male.bam 206504_S5_L001.male.bam 22116FL-07-01-10_S10.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206505_merged.female.bam 206505_S6_L001.female.bam 22116FL-07-01-11_S11.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206506_merged.female.bam 206506_S7_L001.female.bam 22116FL-07-01-12_S12.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206507_merged.male.bam 206507_S8_L001.male.bam 22116FL-07-01-13_S13.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206508_merged.male.bam 206508_S9_L001.male.bam 22116FL-07-01-14_S14.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206509_merged.female.bam 22116FL-07-01-15_S15.female.bam 206509_S10_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206510_merged.female.bam 206510_S11_L001.female.bam 22116FL-07-01-16_S16.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206511_merged.female.bam 22116FL-07-01-17_S17.female.bam 206511_S12_L001.female.bam 18032FL-158-01-13_S17_L007.female.bam 22116FL-09-01-13_S19_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 206512_merged.female.bam 206512_S13_L001.female.bam 22116FL-07-01-18_S18.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_577056_merged.male.bam 22116FL-09-01-21_S27_L004.male.bam 18032FL-158-01-21_S25_L007.male.bam 22116FL-03-01-14_S14_L002.male.bam 18032FL-129-03-03_S13_L001.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_125827_merged.female.bam 22116FL-03-01-12_S12_L002.female.bam 18032FL-158-01-20_S24_L007.female.bam 18032FL-150-07-01_S6_L006.female.bam 22116FL-09-01-20_S26_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_125813_merged.male.bam 22116FL-03-01-21_S21_L002.male.bam 18032FL-158-01-19_S23_L007.male.bam 18032FL-150-07-02_S7_L006.male.bam 22116FL-09-01-19_S25_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_125800_merged.male.bam 22116FL-09-01-22_S28_L004.male.bam 18032FL-158-01-22_S26_L007.male.bam 22116FL-05-01-44_S30_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_122748_merged.female.bam 22116FL-04-01-05_S5_L003.female.bam 18032FL-158-01-18_S22_L007.female.bam 22116FL-09-01-18_S24_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_121019_merged.female.bam 18032FL-158-01-17_S21_L007.female.bam 22116FL-03-01-25_S25_L002.female.bam 18032FL-152-02-05_S5.female.bam 22116FL-09-01-17_S23_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_120740_merged.male.bam 18032FL-158-01-16_S20_L007.male.bam 22116FL-09-01-16_S22_L004.male.bam 22116FL-03-01-26_S26_L002.male.bam 18032FL-150-07-03_S8_L006.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_116905_merged.male.bam 22116FL-03-01-15_S15_L002.male.bam 18032FL-129-03-04_S14_L001.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_115253_merged.female.bam 18032FL-158-01-15_S19_L007.female.bam 22116FL-09-01-15_S21_L004.female.bam 22116FL-03-01-31_S31_L002.female.bam 18032FL-152-02-03_S3.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_115184_merged.female.bam 18032FL-158-01-14_S18_L007.female.bam 22116FL-03-01-23_S23_L002.female.bam 22116FL-09-01-14_S20_L004.female.bam 18032FL-152-02-04_S4.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 2_merged.male.bam 22116FL-04-01-30_S30_L003.male.bam 18032FL-158-01-27_S31_L007.male.bam 22116FL-09-01-27_S33_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 3_merged.female.bam 22116FL-04-01-13_S13_L003.female.bam 18032FL-158-01-34_S38_L007.female.bam 22116FL-09-01-34_S40_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 5_merged.female.bam 22116FL-04-01-35_S35_L003.female.bam 18032FL-158-01-30_S34_L007.female.bam 22116FL-09-01-30_S36_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 6_merged.female.bam 22116FL-04-01-22_S22_L003.female.bam 18032FL-158-01-38_S42_L007.female.bam 22116FL-09-01-38_S44_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 7_merged.female.bam 22116FL-09-01-33_S39_L004.female.bam 18032FL-158-01-33_S37_L007.female.bam 22116FL-04-01-08_S8_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 8_merged.female.bam 22116FL-04-01-16_S16_L003.female.bam 18032FL-158-01-35_S39_L007.female.bam 22116FL-09-01-35_S41_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 9_merged.female.bam 22116FL-04-01-20_S20_L003.female.bam 18032FL-158-01-37_S41_L007.female.bam 22116FL-09-01-37_S43_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 10_merged.male.bam 22116FL-09-01-42_S48_L004.male.bam 18032FL-158-01-42_S46_L007.male.bam 22116FL-04-01-26_S26_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 11_merged.male.bam 22116FL-04-01-32_S32_L003.male.bam 18032FL-158-01-28_S32_L007.male.bam 22116FL-09-01-28_S34_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 115_merged.female.bam 22116FL-09-01-24_S30_L004.female.bam 18032FL-158-01-24_S28_L007.female.bam 22116FL-04-01-12_S12_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 167_merged.female.bam 22116FL-05-01-32_S23_L003.female.bam 22116FL-05-01-07_S6_L003_repair.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 393_merged.female.bam 22116FL-09-01-31_S37_L004.female.bam 18032FL-158-01-31_S35_L007.female.bam 22116FL-04-01-29_S29_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 16558_merged.female.bam 22116FL-09-01-49_S55_L004.female.bam 18032FL-158-01-49_S53_L007.female.bam 22116FL-04-01-09_S9_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 16559_merged.female.bam 22116FL-04-01-01_S1_L003.female.bam 18032FL-158-01-43_S47_L007.female.bam 22116FL-09-01-43_S49_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 16560_merged.female.bam 22116FL-04-01-28_S28_L003.female.bam 22116FL-09-01-29_S35_L004.female.bam 18032FL-158-01-29_S33_L007.female.bam 

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 17591_merged.male.bam 22116FL-04-01-02_S2_L003.male.bam 18032FL-158-01-44_S48_L007.male.bam 22116FL-09-01-44_S50_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 17596_merged.male.bam 22116FL-09-01-51_S57_L004.male.bam 18032FL-158-01-51_S55_L007.male.bam 22116FL-04-01-14_S14_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 17602_merged.male.bam 22116FL-04-01-27_S27_L003.male.bam 18032FL-158-01-32_S36_L007.male.bam 22116FL-09-01-32_S38_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 027_KATM_merged.female.bam 22116FL-05-01-21_S12_L003.female.bam 18032FL-129-02-06_S8_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 1603_GAAR_merged.female.bam 22116FL-05-01-29_S20_L003.female.bam 22116FL-05-01-30_S21_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 421_LACL_merged.male.bam 22116FL-05-01-33_S24_L003.male.bam 22116FL-05-01-34_S25_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 502_LACL_merged.female.bam 22116FL-09-01-23_S29_L004.female.bam 18032FL-158-01-23_S27_L007.female.bam 22116FL-04-01-33_S33_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 112022_merged.male.bam 22116FL-09-01-36_S42_L004.male.bam 18032FL-158-01-36_S40_L007.male.bam 22116FL-02-01-16_S16_L004.male.bam 22116FL-04-01-18_S18_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 111926_merged.male.bam 22116FL-03-01-19_S19_L002.male.bam 22116FL-02-01-14_S14_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 111857_merged.female.bam 22116FL-09-01-39_S45_L004.female.bam 18032FL-158-01-39_S43_L007.female.bam 22116FL-04-01-24_S24_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 111830_merged.male.bam 22116FL-09-01-41_S47_L004.male.bam 18032FL-158-01-41_S45_L007.male.bam 22116FL-04-01-15_S15_L003.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 104694_merged.female.bam 22116FL-04-01-10_S10_L003.female.bam 18032FL-158-01-40_S44_L007.female.bam 22116FL-09-01-40_S46_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 101182_merged.female.bam 22116FL-07-01-19_S19.female.bam 101182_S14_L001.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 20787_merged.female.bam 22116FL-04-01-23_S23_L003.female.bam 18032FL-158-01-55_S59_L007.female.bam 22116FL-09-01-55_S61_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 20781_merged.male.bam 22116FL-04-01-07_S7_L003.male.bam 18032FL-158-01-48_S52_L007.male.bam 22116FL-09-01-48_S54_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 20773_merged.male.bam 22116FL-04-01-11_S11_L003.male.bam 18032FL-158-01-50_S54_L007.male.bam 22116FL-09-01-50_S56_L004.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 GB_0105144_merged.male.bam GB_0105144_L002.edit.male.bam GB_0105144_L003.edit.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 20701_merged.female.bam 22116FL-09-01-52_S58_L004.female.bam 18032FL-158-01-52_S56_L007.female.bam 22116FL-04-01-17_S17_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 19648_merged.male.bam 22116FL-03-01-36_S36_L002.male.bam 18032FL-152-02-23_S23.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18671_merged.female.bam 22116FL-04-01-04_S4_L003.female.bam 18032FL-158-01-46_S50_L007.female.bam 22116FL-09-01-46_S52_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18624_merged.male.bam 18032FL-152-02-19_S19.male.bam 22116FL-03-01-13_S13_L002.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18538_merged.female.bam 22116FL-09-01-47_S53_L004.female.bam 18032FL-158-01-47_S51_L007.female.bam 22116FL-04-01-06_S6_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18536_merged.female.bam 22116FL-04-01-19_S19_L003.female.bam 18032FL-158-01-53_S57_L007.female.bam 22116FL-09-01-53_S59_L004.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18524_merged.male.bam 18032FL-152-02-14_S14.male.bam 22116FL-03-01-39_S39_L002.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18520_merged.female.bam 22116FL-03-01-41_S41_L002.female.bam 18032FL-152-02-13_S13.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 18516_merged.male.bam 22116FL-03-01-46_S46_L002.male.bam 18032FL-152-02-12_S12.male.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 17612_merged.female.bam 22116FL-09-01-45_S51_L004.female.bam 18032FL-158-01-45_S49_L007.female.bam 22116FL-04-01-03_S3_L003.female.bam

#/oak/stanford/groups/dpetrov/armstrong/applications/sambamba-0.7.1-linux-static merge -t 24 17611_merged.female.bam 22116FL-09-01-54_S60_L004.female.bam 18032FL-158-01-54_S58_L007.female.bam 22116FL-04-01-21_S21_L003.female.bam


