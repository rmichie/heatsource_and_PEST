# make a PEST ptf file for heat source landcover data input

top_dir <- "C:/WorkSpace/GitHub/heatsource_and_PEST/Obs_Effective_Shade_v1/"
mod_dir <- "hs_inputs/"
in_name <- "lccodes_current.csv"
out_name <- "ptf_lccodes.tpl"
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

parnme <- paste0("canopy",seq(from=1,to=nrow(df.in),by=1))
partrans <- "log"
parchglim <-"factor"
parval1 <- df.in$CANOPY_COVER
parlbnd <- 0.0
parubnd <- 1.0
pargp <- "canopy"
scale_ <- 1
offset_ <- 1
dercom <- 1

pardata <- paste(parnme,partrans,parchglim,parval1,parlbnd,parubnd,
                 pargp,scale_,offset_,dercom,sep=" ")

# ------------------------------------------
# construct the parameter group section for the
# control file

pargpnme <- "canopy"
inctyp <- "relative"
derinc <- 0.01
derinclb <- 0.001
forcen <- "switch"
derincmul <- 2.0000
dermthd <- "parabolic"

pargpdata <- paste(pargpnme,inctyp,derinc,derinclb,forcen,
                   derincmul,dermthd,sep=" ")

# get the starting and ending line for this section
line.start <- grep("\\* parameter groups" ,control)
line.end <- line.start + min(grep("\\* " ,
                                  control[(line.start + 1):length(control)]))

# insert and include existing data
control <- c(control[1:line.start],
                 pargpdata,
                 control[(line.start+1):length(control)])
# get number of parameter groups
npargp <- length(pargpdata) + line.end - line.start -1

# ------------------------------------------
# insert new parameter data into control file

# get the starting and ending line for this section
line.start <- grep("\\* parameter data" ,control)
line.end <- line.start + min(grep("\\* " ,
                                  control[(line.start + 1):length(control)]))

# insert with existing parameter data
control <- c(control[1:line.start],
             pardata,
             control[(line.start+1):length(control)])

# get number of parameters & parameter groups
npar <- length(pardata) + line.end - line.start -1

# update the number of parameters on control line 4
line.4 <- strsplit(control[4],"\\s+")[[1]]
line.4[1] <- npar
line.4[3] <- npargp

# write updated control file
write.table(control.new, file=paste0(top_dir,pst_out), 
            row.names=FALSE, col.names=FALSE, quote=FALSE)

# ------------------------------------------
# construct the parameter markers for canopy
seqA <- rep("#canopy",nrow(df.in))
seqB.0 <- seq(from=1,to=nrow(df.in),by=1)
seqB.1 <- sprintf("%-7s",seqB.0)
seqC <- rep("#",nrow(df.in))

# insert the canopy parameter marker
df.in$CANOPY_COVER <- paste0(seqA,seqB.1,seqC)

write.table(df.in, file=paste0(top_dir,out_name),
            sep = ",",
            dec = ".", 
            quote = FALSE, 
            row.names = FALSE, 
            col.names = TRUE)