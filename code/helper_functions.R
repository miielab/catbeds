### ========================================
### Helper Functions
### ========================================
Cosine_Similarity <- function(emb){
  
  # Remove non-numeric variables and convert to matrix
  path <- unique(emb$path)[1]
  emb %<>% select(-path)
  emb %<>% as.matrix()
  
  # Create list of groups
  race <- c("black","white", "asian", "latinx", "indigeneous")
  sex <- c("queer", "heterosexual")
  gender <- c("male", "female")
  race_gender <- c(paste0(race,"_male"), paste0(race,"_female"))
  
  groups <- c(race_gender,
              unlist(lapply(c(race, sex, gender), paste0, "_famous")),
              c(paste0(race,"_queer"), paste0(race,"_heterosexual")),
              c(paste0(race_gender,"_queer"), paste0(race_gender,"_heterosexual")),
              c(paste0(gender,"_queer"), paste0(gender,"_heterosexual")))
  
  # Create list of domains
  domains = c("struggle", "business", "family", "power", "sports", "performance_arts")
  
  # Subset to only domains / groups in embeddings
  domains %<>% intersect(colnames(emb))
  groups %<>% intersect(colnames(emb))
  
  # Calculate Cosine Similarity
  cos = cosine(emb[,c(domains, groups)])
  cos = cos[domains, groups] %>% as.data.frame
  cos$domain = rownames(cos) %>% str_to_title()
  cos$model = path
  rownames(cos) <- NULL
  cos$collection  <- str_extract(path, "mainstream|diversity|WSJ|NYT")
  if(any(cos$collection %in% c("mainstream", "diversity"))){cos$collection %<>% str_to_title()}
  colnames(cos) %<>% str_remove("_famous")
  
  return(cos)
}

Centeredness <- function(df, x, y){
  df %>%
    mutate(c = get(x)-get(y)) %>%
    group_by(domain, collection) %>% 
    summarise(max = quantile(c, 0.90, na.rm=T),
              min = quantile(c, 0.1, na.rm=T),
              mean = mean(c, na.rm=T))
}

Relevel_Domains <- function(df, d=T){
  df %>%
    mutate(domain = as.character(domain),
           domain = factor(ifelse(domain == "Performance_arts", "Perf. Arts", domain)),
           domain = forcats::fct_relevel(domain, function(x){sort(x, decreasing = d)}))
}