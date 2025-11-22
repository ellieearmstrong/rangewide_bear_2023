library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

windows_path <- "all_samples_10kb.tsv"
win <- read_tsv(windows_path, show_col_types = FALSE)
lowcov_windows <- "lowcov_10kb.tsv"
win_low <- read_tsv(lowcov_windows, show_col_types = FALSE)


roh <- read_tsv("filtered_roh_with_depth.tsv", show_col_types = FALSE) |>
  rename(SAMPLE = INDIVIDUAL,
         CHROM  = CHROM,
         ROH_START = ROH_START,
         ROH_END   = ROH_END)

# keep just the three chromosomes of interest
keep_chr <- c("NW_026622763.1","NW_026622874.1")
keep_indv <- c('BB_L48_Cab_3', 'BB_AK_8_pub','BB_AK_13_pub')
keep_low <- c('BB_AK_8_12', 'BB_AK_13A_4', 'BB_CAN_pub_HB_9')
win_low <- win_low |>
  filter(CHROM %in% keep_chr, N_CALLED > 0) %>%
  filter(SAMPLE %in% keep_low)

roh <- roh |>
  filter(CHROM %in% keep_chr) %>%
  filter(SAMPLE %in% keep_low)

win2 <- win_low %>%
  filter(CHROM %in% keep_chr, N_CALLED > 0) %>%
  mutate(
    CHROM    = factor(CHROM, levels = keep_chr),
    POS_MID  = 0.5*(BIN_START + BIN_END),
    HET_PROP = N_HET / N_CALLED        # proportion of het genotypes
  )

roh2 <- roh %>%
  filter(CHROM %in% keep_chr) %>%
  mutate(
    CHROM = factor(CHROM, levels = keep_chr),
    y0 = -0.0009,       # position of ROH bars
    y1 = -0.0009
  ) %>% 
  filter(ROH_LENGTH > 1000000)

ymax <- max(win2$HET_PROP, na.rm = TRUE)

p <- ggplot() +
  geom_point(
    data = win2,
    aes(x = POS_MID, y = HET_PROP),
    size = 1.1, alpha = 0.85, color = "#7A1E1E"
  ) +
  geom_segment(
    data = roh2,
    aes(x = ROH_START, xend = ROH_END, y = y0, yend = y1),
    inherit.aes = FALSE,
    linewidth = 0.9, lineend = "butt", color = "black"
  ) +
  facet_grid(rows = vars(SAMPLE), cols = vars(CHROM),
             scales = "free_x", space = "free_x") +
  scale_x_continuous(labels = function(x) x/1e6, name = "Position (Mb)") +
  scale_y_continuous(
    name = "Proportion heterozygous (per 10 kb)",
    limits = c(-0.002, 0.03),   # fixed y-axis max = 0.005
    expand = c(0, 0)
  ) +
  theme_bw() +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_blank(),
    axis.title.y = element_text(margin = margin(r = 10)),
    axis.title.x = element_text(margin = margin(t = 6))
  )
