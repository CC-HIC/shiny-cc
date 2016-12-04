library(assertthat)
library(devtools)
library(data.table)
library(yaml)
library(ccdata)

# ccfun library
library(ccfun)

# Load data
cc <- readRDS(file="../data/cc.RDS")
data_fields <- yaml::yaml.load_file("../config/data_fields.yaml")
ccfun::relabel_cols(cc, "NHICcode", "shortName", dict=data_fields)
setnames(cc, "episode_id", "id")

summary(cc$hrate)

library(ggplot2)
sample(unique(cc$id), 3)
cc.plot <- cc[id == sample(unique(cc$id), 5) & time < 168]
ggplot(data=cc.plot, aes(x=time, y=hrate, colour=id, group=id)) +
    geom_smooth() +
    geom_point() +
    coord_cartesian(x=c(0,168), y=c(0,200)) +
    guides(colour=FALSE, group=FALSE) +
    theme_minimal()