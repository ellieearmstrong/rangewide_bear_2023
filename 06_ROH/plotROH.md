library(tidyverse)
library(data.table)
library(patchwork)
library(colorspace)
library(ggplot2)
library(ggtext)

bear_palette_3 <- c("Baranof & Chichagof Islands" = "violet",
                        "Alberta"="lightblue",
                        "British Columbia (Central)" = "seagreen2",
                        "British Columbia (South Purcells)" = "darkgreen",
                        "British Columbia (South Rockies)" = "limegreen", 
                        "GYE" = "purple3", 
                        "Cabinets" = "navy",
                        "Yaak" = "firebrick",
                        "Selkirks" = "grey60",
                        "NCDE" = "darkorange",
                        "Hudson Bay" = "pink1",
                        "Kodiak" = "black",
                        #"Inside Passage" = 'gold1',
                        "Admiralty & Inside Passage" = "goldenrod2",
                        "Mainland Alaska" = "dodgerblue4",
                        'Kenai & Katmai'='maroon2')

                        metadata <- read.csv('~/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents - Ellie’s MacBook Pro (2)/WSU-Business/Rangewide_bear/Sample_Information_Final/Sample_Sheet_Final_Oct24.csv', header = TRUE)


remove_list <- c('BB_WSU_Adak', 'BB_WSU_Cooke', 'BB_WSU_Frank', 'BB_WSU_Willow', 'BB_WSU_Dodge',
                   'BB_WSU_Zuri', 'BB_WSU_973', 'BB_WSU_974','BB_WSU_975', 'BB_WSU_John', 'BB_WSU_Oakley', 
                 'BB_AK_Captive_pub', 'BB_CAN_BC_pub','BB_AK_4_pub7', 'BB_AK_4_pub15')

# post-filtering-plotting (output of depth filtering) -------------------------------------------------
garlic_filtered <- read.csv('filtered_roh_with_depth.tsv', header = TRUE, sep = '\t')
garlic_filtered <- garlic_filtered %>%
  dplyr::rename(Individual = INDIVIDUAL) %>%
  filter(! Individual %in% remove_list) 
garlic_filtered <- merge(garlic_filtered, metadata, by="Individual")

#this just renames the populations so they are consistent with the other naming conventions
pop_name_map <- c(
  "South Purcells" = "British Columbia (South Purcells)",
  "South Rockies" = "British Columbia (South Rockies)",
  "Central British Columbia" = "British Columbia (Central)",
  "HudsonBay" = "Hudson Bay",
  "Admiralty_Inside" = "Admiralty & Inside Passage",
  "Kenai_Katmai" = "Kenai & Katmai"
)
garlic_filtered <- garlic_filtered %>%
  mutate(Locale3 = recode(Locale3, !!!pop_name_map))

#calculate coverage of each segment by call
garlic_filtered$ROH_COV_PERC <- (garlic_filtered$ROH_COV / garlic_filtered$ROH_LENGTH)*100
MEAN_COV <- mean(garlic_filtered$ROH_COV_PERC)
SD_COV <- sd(garlic_filtered$ROH_COV_PERC)

lower_bound <- MEAN_COV - SD_COV
upper_bound <- MEAN_COV + SD_COV

garlic_filtered_mean_sd <- garlic_filtered %>%
  filter(ROH_COV_PERC >= lower_bound) 


#set different classes 
garlic_A = garlic_filtered_mean_sd %>%
  filter(CLASS == 'A') %>%
  mutate(ROH_LENGTH_MB = (ROH_LENGTH/1000000))

garlic_B = garlic_filtered_mean_sd %>%
  filter(CLASS == 'B') %>%
  mutate(ROH_LENGTH_MB = (ROH_LENGTH/1000000))

garlic_C = garlic_filtered_mean_sd %>%
  filter(CLASS == 'C') %>%
  mutate(ROH_LENGTH_MB = (ROH_LENGTH/1000000))

garlic_D = garlic_filtered_mean_sd %>%
  filter(CLASS == 'D') %>%
  mutate(ROH_LENGTH_MB = (ROH_LENGTH/1000000))

garlic_filtered_mean_sd_ROH = garlic_filtered_mean_sd %>%
  filter(CLASS %in% c("C", "D")) %>%
  group_by(Individual, Locale3) %>%
  summarise_at(c("ROH_LENGTH"), sum) %>%
  ungroup() %>%
  mutate(Froh = ROH_LENGTH/1101122851)

level_order3 <- c("GYE", "Cabinets", "Yaak", "Selkirks", "NCDE", "Alberta",
                  "British Columbia (South Purcells)", "British Columbia (South Rockies)",
                  "British Columbia (Central)", "Hudson Bay", "Mainland Alaska",
                  "Kenai & Katmai", "Admiralty & Inside Passage", "Baranof & Chichagof Islands", "Kodiak")

garlicFROH <- ggplot(garlic_filtered_mean_sd_ROH, aes(x=Froh, y=factor(Locale3, level = level_order3), fill = Locale3)) +
  geom_boxplot(position = position_dodge(width = 0.8), outlier.alpha = 0.4) + 
#  geom_point(aes(fill = Locale3)) +
  scale_fill_manual(name = "Population", values = bear_palette_3) + 
#  scale_color_manual(name = "Population", values = bear_palette_3) +
  labs(x=expression(F[ROH]), y = "") + 
  theme_bw() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10, color = "black"), 
        axis.text.y = element_text(size = 10, color = "black"),
        axis.title.x = element_blank(), 
        axis.title.y = element_text(size = 16, color = "black", line = 0, vjust = 2),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        legend.position = "none",
        plot.margin = margin(1, 0, 0, 0.5, "cm")) 
ggsave('FROH_1Mbmin_Dec6.png', garlicFROH, width = 15, height = 8,dpi = 1000)

df <- garlic_filtered_mean_sd %>%
  mutate(Locale3 = fct_relevel(
    Locale3,
    "Kodiak", "Baranof & Chichagof Islands", "Admiralty & Inside Passage", "Kenai & Katmai",
    "Mainland Alaska","Hudson Bay", "British Columbia (Central)", "British Columbia (South Rockies)",
    "British Columbia (South Purcells)", "Alberta", "NCDE", "Selkirks", "Yaak",
    "Cabinets", "GYE"
  ))

ord_ind <- df %>%
  arrange(Locale3, Individual) %>%
  pull(Individual) %>%
  unique()

df <- df %>% mutate(Individual_f = factor(Individual, levels = ord_ind))

# 2) y axis coloring
lab_map <- df %>%
  distinct(Individual_f, Individual, Locale3) %>%
  mutate(label_html = paste0(
    "<span style='color:", bear_palette_3[as.character(Locale3)], "'>",
    Individual, "</span>"
  )) %>%
  { setNames(.$label_html, .$Individual_f) }

# 3) Plot absolute lengths, bars filled by ROH class only
p <- ggplot(
  df,
  aes(
    x = ROH_LENGTH,
    y = Individual_f,
    fill = factor(CLASS, levels = c("D","C","B","A"))
  )
) +
  geom_col() +                                     # absolute lengths
  scale_y_discrete(labels = lab_map) +
  scale_fill_manual(
    name = "ROH class",
    values = c("D"="#6A65AB","C"="#3A93C3","B"="#8EC0DE","A"="#D1E5F0")
  ) +
  labs(x = "Length (bp)", y = "Individual") +
  theme_bw() +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1, vjust = 1, size = 16, color = "black"),
    axis.text.y  = element_markdown(size = 10),   # enables colored labels
    axis.title.y = element_text(size = 16, color = "black", vjust = 2),
    legend.title = element_text(size = 16),
    legend.text  = element_text(size = 14),
    legend.position = "right"
  )

# 4) Add Locale3 legend
p + geom_point(
  data = distinct(df, Locale3),
  aes(x = 0, y = 0, color = Locale3),
  inherit.aes = FALSE
) +
  scale_color_manual(name = "Locale", values = bear_palette_3) +
  guides(color = guide_legend(order = 1),
         fill  = guide_legend(order = 2))

