# Code for analysis of the MTSD RIL parents MT5 and MT102

# LOAD LIBRARIES #


# SET INPUTS #
data_dir <- '/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2/'
hw_file_short <- 'Csa_unmasked48_MTSDParents.hwe'
hw_file_full <- paste(data_dir, hw_file_short, sep = '')
hw_data <- read.table(hw_file_full, header = T, sep = '\t', 
  stringsAsFactors = F)


# SET OUTPUTS #
fix_diff_out <- paste(data_dir, 'Csa_unmasked48_MTSDParents_fixedDiffs.txt', 
  sep = '')
homRef_out <- paste(data_dir, 'Csa_unmasked48_MTSDParents_homRef.txt', 
  sep = '')
homAlt_out <- paste(data_dir, 'Csa_unmasked48_MTSDParents_homAlt.txt',    
  sep = '')
invar_out <- paste(data_dir, 'Csa_unmasked48_MTSDParents_invariant.txt',
  sep = '')

# SET VARIABLES #


# SET CONSTANTS #


##############
table(hw_data[,3])
#  0/0/2  0/1/1  0/2/0  1/0/1  1/1/0  2/0/0 
#  87837   1773  12089 223493  18059 140067
# 223,493 SNPs are fixed diffs between MT5 and MT102
# That seems like a lot, but I guess heterozygosity is low, so most variation
#   will be fixed differences between samples

fix_dif_inds <- which(hw_data[,3] == '1/0/1')
hom_ref_inds <- which(hw_data[,3] == '2/0/0')
hom_alt_inds <- which(hw_data[,3] == '0/0/2')

write.table(hw_data[fix_dif_inds, c(1,2)], file = fix_diff_out, quote = F, 
  sep = '\t', row.names = F, col.names = F)
write.table(hw_data[hom_ref_inds, c(1,2)], file = homRef_out, quote = F, 
  sep = '\t', row.names = F, col.names = F)
write.table(hw_data[hom_alt_inds, c(1,2)], file = homAlt_out, quote = F,  
  sep = '\t', row.names = F, col.names = F)
write.table(hw_data[sort(union(hom_ref_inds, hom_alt_inds)), c(1,2)], 
  file = invar_out, quote = F, sep = '\t', row.names = F, col.names = F)
quit(save = 'no')

