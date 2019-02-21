# Code for analysis of heterozygosity in un-masked SNPs

# LOAD LIBRARIES #


# SET INPUTS #
data_dir <- '/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2/'
het_file_short <- 'Csa_unmasked48.het'
het_file_full <- paste(data_dir, het_file_short, sep = '')
het_data <- read.table(het_file_full, header = T, sep = '\t', 
  stringsAsFactors = F)

old_data_dir <- '/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_analysis/'
old_het_short <- 'Csa_30xFilt.het'
old_het_full <- paste(old_data_dir, old_het_short, sep = '')
old_het_data <- read.table(old_het_full, header = T, sep = '\t',
  stringsAsFactors = F)


# SET OUTPUTS #


# SET VARIABLES #


# SET CONSTANTS #


##############
het_data$het <- 1 - (het_data$O.HOM. / het_data$N_SITES)

old_het_data$het <- 1 - (old_het_data$O.HOM. / old_het_data$N_SITES)

cbind(het_data$het, old_het_data$het)
quit(save = 'no')

