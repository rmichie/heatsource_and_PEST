# Read PEST input file for land cover data and update 
# the heat source input
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
#dummy_name <- "lcdata_dummy.csv"
#in_name <- "start_lcdata_emergent.csv"
#out_name <- "lcdata_emergent.csv"

df.dummy <- read.table(paste0(top_dir,dum_dir,dummy_name),
                       sep=",",dec=".",
                       skip=0, header=TRUE, 
                       stringsAsFactors = FALSE, 
                       na.strings = "NA")

# Read original Land cover codes
df.model <- read.table(paste0(top_dir,mod_dir,in_name),
                       sep=",",dec=".",
                       skip=0, header=TRUE,
                       stringsAsFactors = FALSE, 
                       na.strings = "NA")

# --TOPO---------------------------------------------------------------
# Rescale value from PEST to the upper and lower bound for topo adjustments
# Using first row since they are all the same

topo_w_adj <- rescale(x=df.dummy$TOPO_W[1],xmin=1,xmax=101,ymin=-90,ymax=90)
topo_s_adj <- rescale(x=df.dummy$TOPO_S[1],xmin=1,xmax=101,ymin=-90,ymax=90)
topo_e_adj <- rescale(x=df.dummy$TOPO_E[1],xmin=1,xmax=101,ymin=-90,ymax=90)

topo_w_new <- df.model$TOPO_W + topo_w_adj
topo_s_new <- df.model$TOPO_S + topo_s_adj
topo_e_new <- df.model$TOPO_E + topo_e_adj

df.model$TOPO_W <- ifelse(topo_w_new <0,0,topo_w_new)
df.model$TOPO_S <- ifelse(topo_s_new <0,0,topo_s_new)
df.model$TOPO_E <- ifelse(topo_e_new <0,0,topo_e_new)

df.model$TOPO_W <- ifelse(topo_w_new >90,90,topo_w_new)
df.model$TOPO_S <- ifelse(topo_s_new >90,90,topo_s_new)
df.model$TOPO_E <- ifelse(topo_e_new >90,90,topo_e_new)

# --LC-------------------------------------------------------------
# No Change to land cover values

# --ELE-----------------------------------------------------------
# No change to Elevation values

# Write output
write.table(df.model, file=paste0(top_dir,mod_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)
