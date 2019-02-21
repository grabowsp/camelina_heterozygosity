# Code for analysis of MTSD RIL heterozygosity

# LOAD LIBRARIES #


# SET INPUTS #
data_dir <- '/home/t4c1/WORK/grabowsk/data/Camelina_reseq/het_try2/'
fix_dif_short <- 'Csa_unmasked48_MTSD_fixedDiff.het'
homRef_short <- 'Csa_unmasked48_MTSD_homRef.het'
homAlt_short <- 'Csa_unmasked48_MTSD_homAlt.het'

fixDif_het <- read.table(paste(data_dir, fix_dif_short, sep = ''), header = T,
  stringsAsFactors = F, sep = '\t')
homRef_het <- read.table(paste(data_dir, homRef_short, sep = ''), header = T,
  stringsAsFactors = F, sep = '\t')
homAlt_het <- read.table(paste(data_dir, homAlt_short, sep = ''), header = T,
  stringsAsFactors = F, sep = '\t')



# SET OUTPUTS #

# SET VARIABLES #


# SET CONSTANTS #


##############
(fixDif_het$N_SITES - fixDif_het$'O.HOM.') / fixDif_het$N_SITES

# Make dataframe with % het for each SNP class

quit(save = 'no')

