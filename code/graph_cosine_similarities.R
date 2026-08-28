###############################################
# Author: Emileigh Harrison & Jake Nicolls
# Description: Figures for Category Embeddings Paper

### ========================================
### Set up
### ========================================
# Set working directory
library(rstudioapi)
library(tidyverse)
library(magrittr)
library(lsa)
library(ggplot2)
library(ggpattern)

# Set Working Directory to folder where this script is saved
here <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(here)

# Read in helper functions
source("helper_functions.R")

# Read in graph themes
source("graph_themes.R")

### ========================================
### Read Embeddings Data
### ========================================
load("../data/news_embeddings.Rdata")
load("../data/children_embeddings.Rdata")


### ========================================
### Calculate Cosine Similarity For Children's Books
### ========================================
# Wide
children <- c(
  mainstream_gender, 
  diversity_gender,
  mainstream_race, 
  diversity_race,
  mainstream_race_gender, 
  diversity_race_gender) %>% 
  lapply(Cosine_Similarity) %>% bind_rows() %>% Relevel_Domains() %>%
  mutate(collection = forcats::fct_relevel(collection, c("Mainstream", "Diversity")))

# Long
children_long <- children %>% 
  pivot_longer(cols=-c("domain", "model","collection")) %>%
  mutate(name = str_to_title(str_replace(name, "_"," "))) %>%
  Relevel_Domains(F) %>% na.omit()


### ========================================
### Calculate Cosine Similarity For Newspapers
### ========================================
# Wide
news <- c(
  nyt_gender, 
  wsj_gender,
  nyt_sex,
  wsj_sex,
  nyt_race_gender, 
  wsj_race_gender,
  nyt_sex_gender,
  wsj_sex_gender,
  nyt_race_sex, 
  wsj_race_sex,
  nyt_race_gender_sex, 
  wsj_race_gender_sex) %>% 
  lapply(Cosine_Similarity) %>% bind_rows() %>% Relevel_Domains() 

# Long
news_long <- news %>% 
  pivot_longer(cols=-c("domain", "model","collection")) %>%
  mutate(name = str_to_title(str_replace_all(name, "_"," ")),
         name = str_to_title(str_replace(name, "Latinx", "Latine"))) %>%
  Relevel_Domains(F) %>% na.omit()


### ========================================
### Graph Cosine Similarity
### ========================================
# Children Race-Gender
children_race_gender_long <- children_long %>%
  subset(name %in% c("White Female", "White Male", "Black Female", "Black Male")) %>%
  separate(name, into = c("race", "gender"), sep = " ", remove=F)

children_race_gender_long %>%
  group_by(name, race, gender, domain, collection) %>%
  summarise(mean_value = mean(value)) %>%
  ggplot(aes(x=name, fill=race,  y=value, pattern=gender)) + 
  geom_boxplot(data=children_race_gender_long, size=0.3, outlier.size = 0.6, width=0.5, alpha=0) +
  geom_bar_pattern(aes(y=mean_value),
                   stat="identity", position="dodge",
                   pattern_fill = "black",
                   pattern_angle = 30,
                   pattern_density = 0.01,
                   pattern_spacing = 0.13,
                   pattern_size = 0.4,
                   pattern_key_scale_factor = 0.4) +
  bar_theme
ggsave("../figures/figure_1a.pdf", scale=0.9, width=17.8, height=8, units="cm")


# Newspaper Race-Gender
news_gender_race_long <- news_long %>% 
  subset(grepl("race_gender/", model)) %>% 
  separate(name, into = c("race", "gender"), sep = " ", remove=F) 

news_gender_race_long %>%
  group_by(name, race, gender, domain, collection) %>%
  summarise(mean_value = mean(value)) %>%

ggplot(aes(x=name, fill=race,  y=value, pattern=gender)) + 
  geom_boxplot(data=news_gender_race_long, size=0.3, 
               outlier.size = 0.6, width=0.5, alpha=0) +
  guides(alpha = guide_legend(override.aes = list(pattern = "none", order = 1))) +
  geom_bar_pattern(aes(y=mean_value),
                   stat="identity", position="dodge",
                   pattern_fill = "black",
                   pattern_angle = 30,
                   pattern_density = 0.01,
                   pattern_spacing = 0.13,
                   pattern_size = 0.4,
                   pattern_key_scale_factor = 0.4) +
  bar_theme
ggsave("../figures/figure_1b.pdf", scale=0.9, width=17.8, height=8, units="cm")


# Newspaper Gender-Sex
news_gender_sex_long <- news_long %>% 
  subset(grepl("gender_orientation/", model) & !grepl("race", model)) %>% 
  separate(name, into = c("gender", "sex"), sep = " ", remove=F) %>%
  mutate(name = paste0(sex, gender))

news_gender_sex_long %>%
  group_by(name, sex, gender, domain, collection) %>%
  summarise(mean_value = mean(value)) %>%
  
  ggplot(aes(x=name, alpha=sex,  y=value, pattern=gender)) + 
  geom_boxplot(data=news_gender_sex_long, size=0.3, outlier.size = 0.6, width=0.5, alpha=0) +
  guides(alpha = guide_legend(override.aes = list(pattern = "none", order = 1))) +
  geom_bar_pattern(aes(y=mean_value),
                   stat="identity", position="dodge",
                   pattern_fill = "black",
                   pattern_angle = 30,
                   pattern_density = 0.01,
                   pattern_spacing = 0.13,
                   pattern_size = 0.4,
                   pattern_key_scale_factor = 0.4) +
  bar_theme
ggsave("../figures/figure_2a.pdf", scale=0.9, width=17.8, height=8, units="cm")


# Newspaper Race-Sex
news_race_sex_long <- news_long %>% 
  subset(grepl("race_orientation/", model)) %>% 
  separate(name, into = c("race", "sex"), sep = " ", remove=F) 

news_race_sex_long %>%
  group_by(name, sex, race, domain, collection) %>%
  summarise(mean_value = mean(value)) %>%
  ggplot(aes(x=name, alpha=sex,  y=value, fill=race)) + 
  geom_boxplot(data=news_race_sex_long, size=0.3, outlier.size = 0.6, width=0.5, alpha=0) +
  geom_bar(aes(y=mean_value), stat="identity", position="dodge") + 
  bar_theme
ggsave("../figures/figure_2b.pdf", scale=0.9, width=17.8, height=8, units="cm")


# Newspaper Gender-Sex
news_race_gender_sex_long <- news_long %>% 
  subset(grepl("race_gender_orientation/", model)) %>% 
  separate(name, into = c("race", "gender", "sex"), sep = " ", remove=F)  %>%
  mutate(name = paste0( race, sex, gender))

news_race_gender_sex_long %>%
  group_by(name, sex, gender, race, domain, collection) %>%
  summarise(mean_value = mean(value, na.rm=T)) %>%
  
  ggplot(aes(x=name, alpha=sex, fill=race, y=value, pattern=gender)) + 
  guides(alpha = guide_legend(override.aes = list(pattern = "none", order = 1))) +
  geom_boxplot(data=news_race_gender_sex_long, size=0.3, outlier.size = 0.6, width=0.5, alpha=0) +
  geom_bar_pattern(aes(y=mean_value),
                   stat="identity", position="dodge",
                   pattern_fill = "black",
                   pattern_angle = 30,
                   pattern_density = 0.01,
                   pattern_spacing = 0.13,
                   pattern_size = 0.4,
                   pattern_key_scale_factor = 0.4) +
  bar_theme
ggsave("../figures/figure_3.pdf", scale=0.9, width=17.8, height=8, units="cm")


### ========================================
### Graph Centeredness
### ========================================
# Graph Gender Centeredness for Children's books
Centeredness(children,"female", "male") %>%
  ggplot(aes(x=domain, y=mean, color=collection, shape=collection)) +
  centeredness_theme + 
  ylab(expression(bold("  "%<-%"Male Centered              Female Centered"%->%""))) +
  ylim(-0.25,0.25) 
ggsave("../figures/figure_4a.pdf", width=8.7, height=4, units="cm")


# Graph Race Centeredness for Children's books
Centeredness(children, "black", "white") %>% 
  ggplot(aes(x=domain, y=mean, color=collection, shape=collection)) +
  centeredness_theme + 
  ylab(expression(bold(""%<-%"White Centered              Black Centered"%->%" "))) +
  ylim(-0.25,0.25) 
ggsave("../figures/figure_4b.pdf", width=8.7, height=4, units="cm")


# Graph Gender Centeredness for Newspapers
Centeredness(news, "female", "male") %>%
  ggplot(aes(x=domain, y=mean, color=collection, shape=collection)) +
  centeredness_theme + 
  ylab(expression(bold("  "%<-%"Male Centered              Female Centered"%->%""))) +
  ylim(-0.25,0.25) 
ggsave("../figures/figure_5a.pdf", width=8.7, height=4, units="cm")


# Graph Sex Centeredness for Newspapers
Centeredness(news, "queer", "heterosexual") %>%
  ggplot(aes(x=domain, y=mean, color=collection, shape=collection)) +
  centeredness_theme + 
  ylab(expression(bold(""%<-%"Heterosexual Centered         LBG Centered"%->%"                         "))) +
  ylim(-0.2,0.42) 
ggsave("../figures/figure_5b.pdf", width=8.7, height=4, units="cm")


### ========================================
### Graph Variance
### ========================================
# variance <- read.csv("../../../../text_analysis/supplemental_data/variance_scores/removed_missing_ppl_variance_n25.csv")
variance <- read.csv("../../../../text_analysis/supplemental_data/variance_scores/variance_n25.csv")
# load("../data/children_ALC_variance.Rdata")
variance %<>% bind_rows(variance_d) %>% bind_rows(variance_m)
variance$bundle_type %<>% str_replace("_all_famous","")
variance$race_gender %<>% str_replace("_"," ") %>% str_to_title() %>% as.factor()
variance$name %<>% str_replace("_"," ") %>% str_to_title() %>% as.factor()
variance %<>% separate(bundle_type, c("bundle", "collection"), sep="_")
variance$collection %<>% str_to_title()
variance$bundle %<>% str_to_title()


ggplot(variance) + 
  geom_boxplot(aes(y=variance, x=1, fill=bundle), color="black") + 
  facet_grid(cols=vars(race_gender)) +
  theme(axis.title.x = element_blank(), 
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank()) +
  ylab("Variability") +
  scale_fill_manual(values=c("#0F9E86","#DCA708")) 
ggsave("../figures/figure_6.pdf", width=8.7, height=7, units="cm")







