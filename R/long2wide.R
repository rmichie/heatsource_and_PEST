# converts heat source landcover input from long to wide format
# outputs as csv
options(echo=TRUE)

cmd_args <- commandArgs(trailingOnly = TRUE)

top_dir <- cmd_args[1]
mod_dir <- cmd_args[2]
in_name <- cmd_args[3]
out_name <- cmd_args[4]

library(reshape2)

top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST/"
mod_dir <- "Obs_Effective_Shade_v1/outputs/"
in_name <- "lcdata.txt"
out_name <- "lcdata.csv"

df.long <- read.table(paste0(top_dir,mod_dir,in_name),
                      sep=",",dec=".",
                      skip=0, header=TRUE, 
                      stringsAsFactors = FALSE, 
                      na.strings = "NA")

# This is for ordering the wide col names below
# needs to be done before rebuilding the LC/ELE names
df.long$ORDER <-0
df.long$ORDER <- ifelse(df.long$VARIABLE=="LONGITUDE",1,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="LATITUDE",2,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="TOPO_W",3,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="TOPO_S",4,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="TOPO_E",5,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="LC",6,df.long$ORDER)
df.long$ORDER <- ifelse(df.long$VARIABLE=="ELE",7,df.long$ORDER)

# Reconstruct the LC and ELE col names
df.long$VARIABLE <- ifelse(df.long$VARIABLE == "LC", 
                            paste0(df.long$VARIABLE,
                                   "_T",df.long$TRANSECT,
                                   "_S",df.long$SAMPLE),
                            df.long$VARIABLE)

df.long$VARIABLE <- ifelse(df.long$VARIABLE == "ELE", 
                            paste0(df.long$VARIABLE,
                                   "_T",df.long$TRANSECT,
                                   "_S",df.long$SAMPLE),
                            df.long$VARIABLE)

# cast to wide
df.wide <- dcast(df.long, STREAM_ID + NODE_ID + STREAM_KM ~ VARIABLE, value.var="VALUE",drop=TRUE)

# make a vector of the wide col names in order
df.long <- df.long[with(df.long, order(ORDER,-STREAM_KM,TRANSECT,SAMPLE)), ]
col.names <- c("STREAM_ID","NODE_ID","STREAM_KM", as.character(unique(df.long$VARIABLE)))

# sort on col order
df.wide <- df.wide[,col.names]
# row order
df.wide <- df.wide[with(df.wide,order(-STREAM_KM)),]

write.table(df.wide, file=paste0(top_dir,mod_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)
