
# receives path argument from batch file and converts csv to txt.

options(echo=TRUE)

outpath <- commandArgs(trailingOnly = TRUE)

shade <- read.table(paste0(outpath,"Obs_Effective_Shade_v1/outputs/Shade.csv"),
                    sep=",",dec=".",
                    skip=6, header=FALSE, 
                    stringsAsFactors = FALSE, 
                    na.strings = "NA")

write.table(shade, file=paste0(outpath,"Obs_Effective_Shade_v1/outputs/Shade.txt"),
            sep = "\t",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = FALSE)

