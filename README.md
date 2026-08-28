# Category Embeddings Replication Code

This folder contains code for estimating word embeddings from corpus text and for generating the cosine-similarity figures used in the category embeddings paper.

The underlying corpus text and embedding files are restricted by copyright or license. They are not suitable for public redistribution. The public replication package should therefore share the code and documentation, while requiring users to supply any restricted raw text or derived embedding files through authorized access.

## Folder Structure

```text
replication/
  code/
    estimate_embeddings/
      main.py
      utils.py
      word_vecs.py
      input.yaml
    analyze_embeddings/
      graph_cosine_similarities.R
      helper_functions.R
      graph_themes.R
  data/
    restricted derived data files, not for public redistribution
```

## Restricted Inputs

The code assumes that users have local access to the restricted data needed for their own authorized replication run.

For embedding estimation, provide one or more tokenized plain-text corpus files. Each entry in `data_dir` must be a full path to a `.txt` file. 

For figure generation, the R analysis expects precomputed embedding data files named:
These are constructed from the embeddings estimated using code in the estimate_embeddings/ folder

- `news_embeddings.RData`
- `children_embeddings.RData`

These files should contain the objects referenced in `code/analyze_embeddings/graph_cosine_similarities.R`.

## Python Setup

The Python embedding-estimation code uses:

- Python 3
- `PyYAML`
- `alive-progress`
- `gensim`

Install dependencies in your preferred Python environment, for example:

```bash
pip install PyYAML alive-progress "gensim<4"
```

The `gensim<4` pin reflects the current script API, which uses the Gensim 3 argument names `size` and `iter`.

## Estimate Word Embeddings

Edit `code/estimate_embeddings/input.yaml` so that `data_dir` contains full paths to authorized `.txt` corpus files:

```yaml
data_dir:
  - /full/path/to/corpus.txt

model:
  name: word2vec
  num_models: 1
  size: 300
  window: 7
  min_count: 30
  workers: 5
  sg: 1
  hs: 1
  negative: 0
  epochs: 10

output:
  output_model_dir: /full/path/to/output/
```

Then run:

```bash
cd code/estimate_embeddings
python main.py -i input.yaml
```

The script writes Word2Vec binary files named `model_0.bin`, `model_1.bin`, and so on, depending on `num_models`.

## R Setup

The R figure-generation code uses:

- `tidyverse`
- `magrittr`
- `lsa`
- `ggplot2`
- `ggpattern`

Install dependencies in R:

```r
install.packages(c("tidyverse", "magrittr", "lsa", "ggplot2", "ggpattern"))
```

## Generate Figures

The R script is:

```text
code/analyze_embeddings/graph_cosine_similarities.R
```

As currently written, it should be run from a working directory that contains the helper scripts and the restricted `.RData` files loaded by the script. If you keep restricted data in `replication/data/`, update the `load()` paths in the R script or copy/symlink the authorized local data files into the analysis working directory.

Create the figure output directory before running the script:

```bash
mkdir -p code/figures
cd code/analyze_embeddings
Rscript graph_cosine_similarities.R
```

The script writes PDF figures to `code/figures/`.

## Notes For Public Release

Before sharing this package publicly:

- Do not include raw corpus text.
- Do not include restricted embedding files or trained model binaries unless redistribution is explicitly permitted.
- Remove local system files such as `.DS_Store`.
- Include this README so users know which restricted inputs must be supplied separately.
