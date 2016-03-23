# Read PEST input file for land cover codes and update 
# the heat source land cover input
options(echo=TRUE)

cmd_args <- commandArgs(trailingOnly = TRUE)

top_dir <- cmd_args[1]
mod_dir <- cmd_args[2]
dum_dir <- cmd_args[3]
dummy_name <- cmd_args[4]
in_name <- cmd_args[5]
out_name <- cmd_args[6]

rescale <- function(x,xmin,xmax,ymin,ymax){
  # function to rescale x on the range of y
  (x - xmin)/(xmax - xmin) * (ymax - ymin) + ymin
  }

#top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST"
#mod_dir <- "/Obs_Effective_Shade_v1/inputs/"
#dum_dir <- "/"
#dummy_name <- "lccodes_dummy.csv"
#in_name <- "start_lccodes_emergent.csv"
#out_name <- "lccodes_emergent.csv"

df.dummy <- read.table(paste0(top_dir,dum_dir,dummy_name),
                       sep=",",dec=".",
                       skip=0, header=TRUE, 
                       stringsAsFactors = FALSE, 
                       na.strings = "NA")


# Read Land cover codes
df.model <- read.table(paste0(top_dir,mod_dir,in_name),
                       sep=",",dec=".",
                       skip=0, header=TRUE,
                       stringsAsFactors = FALSE, 
                       na.strings = "NA")

# --HEIGHT-------------------------------------------------------------
# Rescale value from PEST to the upper and lower bound for height adjustments
# Using first row since they are all the same

ht_adj <- rescale(x=df.dummy$HEIGHT[1],xmin=1,xmax=101,ymin=-2,ymax=2)

ht_new <- df.model$HEIGHT + ht_adj

df.model$HEIGHT <- ifelse(ht_new <0,0,ht_new)

# --CANOPY-------------------------------------------------------------
# codes < 100 are non emergent codes
df.model$CANOPY_COVER <- ifelse(df.model$CODE < 100,
                                df.dummy$CANOPY_COVER[1],
                                df.dummy$CANOPY_COVER[2])

# --OVERHANG-----------------------------------------------------------
# No change to Overhang

# Write output
write.table(df.model, file=paste0(top_dir,mod_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)
