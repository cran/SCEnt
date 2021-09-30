## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup entopy analysis data, include=FALSE--------------------------------
library(SCEnt)
gene_counts <- matrix(0,5,7)
gene_counts[1,5:7] <- 1:3
gene_counts[2,1:4] <- c(5,5,3,2)
gene_counts[3,] <- c(2,0,2,1,3,0,1)
gene_counts[4,] <- rep(3, 7)
gene_counts[5,5] <-5 

rownames(gene_counts) <- paste0("gene", 1:5)
colnames(gene_counts) <- paste0("cell", 1:7)
gene_counts <- t(gene_counts)

## ----print synthetic data-----------------------------------------------------
gene_counts

## ----example entropy calculations on a gene-----------------------------------
(gene1 <- gene_counts[,1])
gene_hom(gene1)
gene_het(gene1)

(gene2 <- gene_counts[,2])
gene_hom(gene2)
gene_het(gene2)

(gene3 <- gene_counts[,3])
gene_hom(gene3)
gene_het(gene3)

(gene4 <- gene_counts[,4])
gene_hom(gene4)
gene_het(gene4)

(gene5 <- gene_counts[,5])
gene_hom(gene5)
gene_het(gene5)

## ----explicit transpose matrix entropy calculation----------------------------
gene_hom(t(gene_counts))

## ----parameter transpose matrix entropy calculation---------------------------
gene_het(gene_counts, transpose = TRUE)

## ----print example data again-------------------------------------------------
gene_counts

## ----example feature selection using scent_select()---------------------------
scent_select(gene_counts, bit_threshold = 0.85)
scent_select(gene_counts, count_threshold = 2)
scent_select(gene_counts, perc_threshold = 0.25)

## ----throw an error from multiple arguments, error=TRUE-----------------------
scent_select(gene_counts, bit_threshold = 0.85, count_threshold = 2)

## ---- eval=FALSE--------------------------------------------------------------
#  gene_counts %>%
#    scent_select(bit_threshold = 0.85) %>%
#    scent_select(count_threshold = 2)

