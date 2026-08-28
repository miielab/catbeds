### ========================================
### Graph Themes
### ========================================
theme_set(theme_bw() + 
            theme(plot.title = element_text(hjust = 0.5), # Center Graph Title
                  # Text
                  text = element_text(size=9, family = "serif", color="black"),
                  axis.text = element_text(size=9),
                  axis.title = element_text(size=9, face="bold"),
                  # Set Facet Theme
                  strip.background = element_rect(fill="grey90", colour = "grey90"),
                  strip.text = element_text(face="bold", size=8),
                  # Remove Axis Lines
                  panel.border = element_blank(), 
                  # Remove panel grid lines
                  # panel.grid.minor = element_blank(),
                  panel.grid.minor = element_line(colour = "grey65"), # Grid Color
                  panel.grid.minor.x = element_blank(),
                  # explicitly set the horizontal lines
                  panel.grid.minor.y = element_line(size=.25, color="gray90", linetype = "longdash"),
                  panel.grid.major = element_blank(),
                  # Remove panel background
                  panel.background = element_blank(),
                  # Change legend 
                  legend.position = "bottom",
                  legend.box.margin=margin(-10,-10,-10,-10),
                  legend.text = element_text(size=8),
                  legend.title = element_blank()))

race_colors <- c("White" = "#5665AD", 
                 "Black" = "#DCA708", 
                 "Latine" = "#AF2E2E",
                 "Asian" = "#0F9E86")

centeredness_theme <- list(
  geom_hline(yintercept = 0, color="gray"),
  geom_errorbar(aes(ymin=min, ymax=max), width=0.4, size=0.2),
  geom_point(size=3), 
  scale_color_manual(values=c("#CC79A7", "#0072B2")),
  theme(axis.title.y = element_blank(),
        panel.grid.major.y = element_line(linewidth=.20, color="gray85")),
  scale_shape_manual(values=c(18,19,21)),
  coord_flip())


bar_theme <-  list(
  scale_alpha_manual(values=c("Heterosexual" = 1, "LGB" = 0.35)),
  scale_pattern_manual(values=c("Male" = "stripe", "Female" = "none")),
  scale_y_continuous(breaks=scales::pretty_breaks(), limits = c(-0.12, 0.8)),
  scale_fill_manual(values=race_colors),
  facet_grid(rows=vars(collection), cols=vars(domain), scales="free"),
  theme(axis.text.x=element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.title.x= element_blank(),
        legend.position = "right"),
  ylab("Cosine Similarity"),
  guides(fill = guide_legend(override.aes = list(pattern = "none", order = 1))),
  geom_hline(yintercept = 0, size=0.25))
