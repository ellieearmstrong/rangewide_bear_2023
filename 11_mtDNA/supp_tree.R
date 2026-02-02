bear_palette_mtdna <- c("Baranof & Chichagof Islands" = "violet",
                        "Alberta"="lightblue",
                        "British Columbia (Central)" = "seagreen2",
                        "British Columbia (South Purcells)" = "darkgreen",
                        "British Columbia (South Rockies)" = "limegreen", 
                        "GYE" = "purple3", 
                        "Cabinets" = "turquoise",
                        "Yaak" = "firebrick",
                        "Selkirks" = "grey60",
                        "NCDE" = "darkorange",
                        "Hudson Bay" = "pink1",
                        "Kodiak" = "black",
                        "Inside Passage" = 'gold1',
                        "Admiralty" = "goldenrod2",
                        "Mainland Alaska" = "dodgerblue4",
                        'Kenai & Katmai'='maroon2',
                        'Polar bear' = 'lemonchiffon1',
                        'European brown bear' = 'black')


metadata <- read.csv('tip_labels.csv', header = TRUE)

mtdna_tree <- "WGS_polar_EuroBB_May2625_renamed_aligned_trimmed_filtered.contree"  
tree <- read.tree(mtdna_tree)

outgroup_ids <- metadata %>% filter(Group == "European brown bear") %>% pull(New_ID)
tree_rooted <- root(tree, outgroup = outgroup_ids, resolve.root = TRUE)

tree_data <- as_tibble(tree_rooted) %>%
  full_join(metadata, by = c("label" = "New_ID"))

tree2 <- as.treedata(tree_data)

p <- ggtree(tree2)
