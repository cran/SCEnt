#' Feature Selection by Gene Heterogeneity
#'
#' @param expr A matrix of gene expression data. Cells should be represented
#' as rows and genes should be represented as columns.
#' @param bit_threshold The threshold for the amount of bits of information a
#' gene must add to be selected as a feature. Only one threshold can be used
#' at a time.
#' @param count_threshold A number represented how many of the most
#' heterogeneous cells should be selected. Only one threshold can be used at
#' a time.
#' @param perc_threshold The percentile of the hetergeneity distribution above
#' which a gene should be to be selected as a feature.
#' @param unit The units to be used when calculating entropy.
#' @param normalise A logical value representing whether the gene counts
#' should be normalised into a probability distribution.
#' @param transpose  A logical value representing whether the matrix should
#' be transposed before having any operations computed on it.
#'
#' @return A matrix of gene expression values where genes with low
#' heterogeneity have been removed.
#' @export
#'
#' @examples
#' #Creating Data
#' gene1 <- c(0,0,0,0,1,2,3)
#' gene2 <- c(5,5,3,2,0,0,0)
#' gene3 <- c(2,0,2,1,3,0,1)
#' gene4 <- c(3,3,3,3,3,3,3)
#' gene5 <- c(0,0,0,0,5,0,0)
#' gene_counts <- matrix(c(gene1,gene2,gene3,gene4,gene5), ncol = 5)
#' rownames(gene_counts) <- paste0("cell",1:7)
#' colnames(gene_counts) <- paste0("gene",1:5)
#'
#' #Performing Feature Selection
#' scent_select(gene_counts, bit_threshold = 0.85)
#' scent_select(gene_counts, count_threshold = 2)
#' scent_select(gene_counts, perc_threshold = 0.25)
scent_select <- function(expr, bit_threshold = NULL, count_threshold = NULL, perc_threshold = NULL, unit = "log2", normalise = TRUE, transpose = FALSE) {
  #Transposing the matrix if required
  if (transpose) {
    expr <- t(expr)
  }

  #Checking only one threshold has been supplied
  if (is.null(bit_threshold) + is.null(count_threshold) + is.null(perc_threshold) != 2) {
    stop("\n Only one threshold can be set at a time")
  }

  #Finding heterogeneity values for each of the genes
  het_vals <- gene_het(expr, unit, normalise, transpose = TRUE)

  #If bit_threshold supplied, finding all genes above the threshold
  if (!is.null(bit_threshold)) {
    indices <- het_vals > bit_threshold
    return(as.matrix(expr[,indices]))
  }

  #If count_threshold is supplied, find the top n given genes by heterogeneity
  if (!is.null(count_threshold)) {
    indices <- sort(het_vals, decreasing = TRUE, index.return = TRUE)$ix
    if (length(indices) < count_threshold) {
      return(expr)
    } else {
      indices <- sort(indices[1:count_threshold])
      return(as.matrix(expr[,indices]))
    }
  }

  #If perc_threshold is supplied, finding all genes with heterogeneity above
  #the given percentile
  if (!is.null(perc_threshold)) {
    indices <- het_vals >= stats::quantile(het_vals, perc_threshold)
    return(as.matrix(expr[,indices]))
  }
}

#' A Tidy Wrapper for Feature Selection by Heterogeneity
#'
#' @param expr A tibble of gene expression data. Cells should be represented
#' as rows and genes should be represented as columns.
#' @param bit_threshold The threshold for the amount of bits of information a
#' gene must add to be selected as a feature. Only one threshold can be used
#' at a time.
#' @param count_threshold A number represented how many of the most
#' heterogeneous cells should be selected. Only one threshold can be used at
#' a time.
#' @param perc_threshold The percentile of the hetergeneity distribution above
#' which a gene should be to be selected as a feature.
#' @param unit The units to be used when calculating entropy.
#' @param normalise A logical value representing whether the gene counts
#' should be normalised into a probability distribution.
#' @param transpose  A logical value representing whether the matrix should
#' be transposed before having any operations computed on it.
#'
#' @return A tibble of gene expression values where genes with low
#' heterogeneity have been removed.
#' @export
#'
#' @examples
#' #Creating Data
#' library(tibble)
#' gene1 <- c(0,0,0,0,1,2,3)
#' gene2 <- c(5,5,3,2,0,0,0)
#' gene3 <- c(2,0,2,1,3,0,1)
#' gene4 <- c(3,3,3,3,3,3,3)
#' gene5 <- c(0,0,0,0,5,0,0)
#' gene_counts <- matrix(c(gene1,gene2,gene3,gene4,gene5), ncol = 5)
#' rownames(gene_counts) <- paste0("cell",1:7)
#' colnames(gene_counts) <- paste0("gene",1:5)
#' gene_counts <- as_tibble(gene_counts)
#'
#' #Performing Feature Selection
#' scent_select_tidy(gene_counts, bit_threshold = 0.85)
#' scent_select_tidy(gene_counts, count_threshold = 2)
#' scent_select_tidy(gene_counts, perc_threshold = 0.25)
scent_select_tidy <- function(expr, bit_threshold = NULL, count_threshold = NULL, perc_threshold = NULL, unit = "log2", normalise = TRUE, transpose = FALSE) {
  #Converting tibble to matrix
  expr <- as.matrix(expr)
  #Calling the feature selection on the matrix
  reduced_expr <- scent_select(expr, bit_threshold, count_threshold, perc_threshold, unit, normalise, transpose)
  #Converting the matrix back to a tibble
  tibble::as_tibble(reduced_expr)
}
