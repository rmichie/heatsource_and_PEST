# make a PEST ptf file for heat source landcover data input

top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST/Obs_Effective_Shade_v1/"
mod_dir <- "hs_inputs/"
in_name <- "lcdata.csv"
out_name <- "ptf_lcdata.tpl"
pst_in <- "pest_control.pst"
pst_out <- "pest_control.pst"

# Read the PEST control file as a character vector
control <- scan(paste0(top_dir,pst_in), sep = "\n", what=character())

# Read original Land cover codes
df.in <- read.table(paste0(top_dir,mod_dir,in_name),
                       sep=",",dec=".",
                       skip=0, header=TRUE,
                       stringsAsFactors = FALSE, 
                       na.strings = "NA")

# ------------------------------------------
# construct the parameter data section for the
# control file

parnme <- paste0("topo",seq(from=1,to=nrow(df.in)*3,by=1))
partrans <- "log"
parchglim <-"factor"
parval1 <- c(df.in$TOPO_W, df.in$TOPO_S, df.in$TOPO_E)
parlbnd <- 0.0
parubnd <- 90.0
pargp <- "topo"
scale_ <- 1
offset_ <- 1
dercom <- 1

pardata <- paste(parnme,partrans,parchglim,parval1,parlbnd,parubnd,
                 pargp,scale_,offset_,dercom,sep=" ")

# ------------------------------------------
# insert new parameter data into control file

# get the starting and ending line for this section
line.start <- grep("\\* parameter data" ,control)
line.end <- line.start + min(grep("\\* " ,
                                  control[(line.start + 1):length(control)]))

# insert existing parameter data
control.new <- c(control[1:line.start],
                 pardata,
                 control[(line.start+1:)length(control)])

# insert and exclude existing parameter data
#control.new <- c(control[1:line.start],
#                 pardata,
#                 control[line.end:length(control)])

# get number of parameters
npar <- length(pardata) + line.end - line.start -1
#npar<- length(pardata)

# update the number of parameters on control line 4
line.4 <- strsplit(control[4],"\\s+")[[1]]
line.4[1] <- npar

# insert new line
control.new[4] <- paste(line.4, sep ="",collapse =" ")

# write updated control file
write.table(control.new, file=paste0(top_dir,pst_out), 
            row.names=FALSE, col.names=FALSE, quote=FALSE)

# ------------------------------------------
# construct the parameter markers for topo
seqA <- rep("#topo",nrow(df.in))
seqB.0 <- seq(from=1,to=nrow(df.in),by=1)
seqB.1 <- sprintf("%-9s",seqB.0)
seqB.2 <- sprintf("%-9s",seqB.0 + nrow(df.in))
seqB.3 <- sprintf("%-9s",seqB.0 + (2*nrow(df.in)))
seqC <- rep("#",nrow(df.in))

# insert the topo parameter marker
df.in$TOPO_W <- paste0(seqA,seqB.1,seqC)
df.in$TOPO_S <- paste0(seqA,seqB.2,seqC)
df.in$TOPO_E <- paste0(seqA,seqB.3,seqC)

write.table(df.in, file=paste0(top_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)