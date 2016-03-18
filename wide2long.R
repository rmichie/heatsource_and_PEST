# converts heat source landcover input from Wide to long format
# ouputs at txt

library(reshape2)
library(stringr)

options(echo=TRUE)

outpath <- commandArgs(trailingOnly = TRUE)

outpath <- "C:/WorkSpace/Quantifying_Conservation_2014/SouthernWillamette/Heat_Source/01_Current_ObsEffectiveShade/"

df.wide <- read.table(paste0(outpath,"Obs_Effective_Shade_v1/inputs/lcdata.csv"),
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

write.table(df.long.f, file=paste0(outpath,"Obs_Effective_Shade_v1/inputs/lcdata.txt"),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)


