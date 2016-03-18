# converts heat source landcover input from Wide to long format
# ouputs at txt
options(echo=TRUE)

cmd_args <- commandArgs(trailingOnly = TRUE)

top_dir <- cmd_args[1]
mod_dir <- cmd_args[2]
in_name <- cmd_args[3]
out_name <- cmd_args[4]

library(reshape2)
library(stringr)

top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST/"
mod_dir <- "Obs_Effective_Shade_v1/outputs/"
in_name <- "lcdata.csv"
out_name <- "lcdata.txt"

df.wide <- read.table(paste0(top_dir,mod_dir,in_name),
                    sep=",",dec=".",
                    skip=0, header=TRUE, 
                    stringsAsFactors = FALSE, 
                    na.strings = "NA")

df.long <- melt(df.wide, id=c("STREAM_ID","NODE_ID","STREAM_KM"),na.rm=TRUE)

var.names <- as.character(unique(df.long $variable))

var.names

lc.cols <- var.names[unlist(lapply(var.names, 
                                       function(x) 
                                         any(grepl("LC", x),grepl("ELE", x))))]
lc.cols

df.lc <- df.long[(which(df.long$variable %in% lc.cols)),]
df.other <- df.long[(which(!(df.long$variable %in% lc.cols))),]

as.character(unique(df.lc$variable))

df.lc$TRANSECT <- as.numeric(gsub(pattern="T",
                                 replacement="", 
                                 lapply(df.lc$variable,
                                        FUN= function(x) unlist(str_split(x,"_"))[2]),
                                 ignore.case = FALSE, 
                                 fixed = FALSE))

df.lc$SAMPLE <- as.numeric(gsub(pattern="S", replacement="",
                               lapply(df.lc$variable,
                                      FUN= function(x) unlist(str_split(x,"_"))[3]),
                               ignore.case = FALSE,
                               fixed = FALSE))
df.lc$VARIABLE <- df.lc$variable
df.lc$VALUE <- df.lc$value

df.lc$VARIABLE <- lapply(df.lc$variable,FUN= function(x) unlist(str_split(x,"_"))[1])

df.other$TRANSECT <- NA
df.other$SAMPLE <- NA
df.other$VARIABLE <- df.other$variable
df.other$VALUE <- df.other$value

df.other$variable <- NULL
df.other$value <- NULL
df.lc$variable <- NULL
df.lc$value <- NULL

# remove the factors
df.lc$VARIABLE <-as.character(df.lc$VARIABLE)
df.other$VARIABLE <-as.character(df.other$VARIABLE)

df.long.f <- rbind(df.other,df.lc)

write.table(df.long.f, file=paste0(top_dir,mod_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)


