##plotting coverage for sdr etc
setwd('Sex-Determination-Files/')

#load libraries
library(ggplot2)
library(tidyverse)

#read in ymer info
SDRY_depth <- read.csv('SDRCovFinal_Oct2024.csv', header = TRUE)
per_ind <- SDRY_depth %>%
  dplyr::filter(
    !is.na(Individual),
    !is.na(SDR_Coverage),
    !is.na(SDR_Depth)
  ) %>%
  dplyr::mutate(
    Individual = trimws(as.character(Individual))
  ) %>%
  dplyr::group_by(Individual) %>%
  dplyr::summarise(
    mean_SDR_Coverage = mean(SDR_Coverage, na.rm = TRUE),
    mean_SDR_Depth    = mean(SDR_Depth,    na.rm = TRUE),
    Sample_Sex        = dplyr::first(na.omit(Sample_Sex))
  ) %>%
  dplyr::ungroup()

ggplot(per_ind, aes(x = mean_SDR_Coverage, y = mean_SDR_Depth, color = Sample_Sex)) +
  geom_point(size = 1, alpha = 0.85) +
  labs(
    x = "Mean SDRY Coverage",
    y = "Mean SDRY Depth",
    color = "Sample Sex"
  ) +
  theme_bw()
