# "Lab Notebook" for Camelina heterozygosity analysis

## Download Genome
* Page containing links to genome, PEP sequence, annotation, etc:
  * `http://www.camelinadb.ca/downloads.html`
### Download genome
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data
wget http://www.camelinadb.ca/downloads/Cs_genome_v2.fa.gz
gunzip Cs_genome_v2.fa.gz
```

## Mask Genome
### Example of Command used for masked genome with 48mers
```
/mnt/local/EXBIN/mask_repeats_hashn -m 48 -z 2g -t 2 -L -s kmer48masked Cs_genome_v2.fa
```
### Shell scripts
* `/home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data/mask_CSgenome_48mer.sh`

### Submit script
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data
qsub mask_CSgenome_48mer.sh
```
### Rename output
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data
mv Camelina_mask48.o1065023 Camelina_mask48.fa
```

## Extract SNPs from un-masked regions of genome
### Files
* initial VCF
  * `/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2/Csa_30xbiallele.recode.vcf`
* Generate bz2 versipon
  * `bzip2 -zk Csa_30xbiallele.recode.vcf`
* zipped VCF  
  * `/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2/Csa_30xbiallele.recode.vcf.bz2`
* masked genome
  * `/home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data/Camelina_mask48.fa`
* Sujan's program for extracting SNPs from unmasked regions
  * `/home/t4c1/WORK/sujan/softwares/snpClean_Repeats_gaps.py`
  * Usage:
    * `python snpClean_Repeats_gaps.py RefGenome.softMasked.fasta 25 output.vcf input.vcf.bz2`
    * where 25 is the bp distance away from the masked regions that will \
keep SNPs
### Run program
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2
python /home/t4c1/WORK/sujan/softwares/snpClean_Repeats_gaps.py \
/home/t4c1/WORK/grabowsk/data/Camelina_reseq/Cset_genome/prairiegold_data/\
Camelina_mask48.fa \
25 Csa_unmasked48.vcf Csa_30xbiallele.recode.vcf.bz2
```
### Background of initial VCF
* Was generated for first round of analysis.
* Used vcfTools to remove indels, choose only bi-alleleic SNPs, and \
SNPs with 30x+ coverage
#### Commands used to generate initial VCF
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/jgi_files
vcftools --vcf Csa_multi_3X_anno.vcf --max-alleles 2 --remove-indels --recode --recode-INFO-all --out Csa_multi_bialleleSNPs

cp Csa_multi_bialleleSNPs.recode.vcf /home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_analysis
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_analysis
head -37476 Csa_multi_bialleleSNPs.recode.vcf | tail -n 10

# Filter SNPs with less than 30X coverage
vcftools --vcf Csa_multi_bialleleSNPs.recode.vcf --minDP 30 --recode --recode-INFO-all --out Csa_30xbiallele

cp Csa_30xbiallele.recode.vcf ../het_try2/
```

## Measure heterozygosity in unmasked VCF
### VCF tools to calculate genome-wide heterozygosity
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2
vcftools --vcf Csa_unmasked48.vcf --het --out Csa_unmasked48
```
* the heterozygosity measures are still very messy. I'll try filtering the SNPs

## Heterozygosity in MTSD RILs
### Overview
* Parents of MTSD RILs are MT5 and MT102
* Can use SNPs that are fixed differences between MT5 and MT102 to estimate \
the number of generations of inbreeding
* Can use other SNPs for error estimates
  * SNPs that are homozygous for same allele in MT5 and MT102 should be \
invariant in MTSD RILs
### Genotype Freqs for MT5 and MT102
```
vcftools --vcf Csa_unmasked48.vcf --hardy --indv MT5 --indv MT102 \
--max-missing 1 --out Csa_unmasked48_MTSDParents
```
### Generate lists of SNPs for analysis
* R code:
  * `./r_code/unmask_MTSD_parent_analysis.r`
* Data directory: 
  * `/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2`
* Fixed difference SNP file: 
  * `Csa_unmasked48_MTSDParents_fixedDiffs.txt`
* Homozygous Reference SNPs in both parents:
  * `Csa_unmasked48_MTSDParents_homRef.txt`
* Homozygous Alt SNPs in both parents:
  * `Csa_unmasked48_MTSDParents_homAlt.txt`
* Invariant SNPs (homozygous same allele in both parents)
  * `Csa_unmasked48_MTSDParents_invariant.txt`
### Calculate Heterozygosity in different types of SNPs
```
cd /home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2

vcftools --vcf Csa_unmasked48.vcf --het --positions \
Csa_unmasked48_MTSDParents_fixedDiffs.txt --out Csa_unmasked48_MTSD_fixedDiff

vcftools --vcf Csa_unmasked48.vcf --het --positions \
Csa_unmasked48_MTSDParents_homRef.txt --out Csa_unmasked48_MTSD_homRef

vcftools --vcf Csa_unmasked48.vcf --het --positions \
Csa_unmasked48_MTSDParents_homAlt.txt --out Csa_unmasked48_MTSD_homAlt

```
### Analyze results
* `./r_code/unmask_MTSD_het_analysis.r`
  * continue analysis here
