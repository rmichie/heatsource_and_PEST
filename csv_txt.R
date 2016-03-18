
# Receives path arguments from csv2txt batch file and converts heat soure csv to txt or vice versa.

options(echo=TRUE)

cmd_args <- commandArgs(trailingOnly = TRUE)

top_dir <- cmd_args[1]
mod_dir <- cmd_args[2]
in_name <- cmd_args[3]
out_name <- cmd_args[4]

#top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST/"
#mod_dir <- "Obs_Effective_Shade_v1/inputs/"
#in_name <- "lccodes_current.csv"
#out_name <- "lccodes_current.txt"

df <- read.table(paste0(top_dir,mod_dir,in_name),
                    sep=",",dec=".",
                    skip=0, header=FALSE, 
                    stringsAsFactors = FALSE, 
                    na.strings = "NA")
#sep = "\t",
write.table(df, file=paste0(top_dir,mod_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = FALSE)

