% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene_extract.r
\name{gene_extraction}
\alias{gene_extraction}
\title{Extracting genes from gene database NCBI.}
\usage{
gene_extraction(terms)
}
\arguments{
\item{terms}{Single or Multiple Terms.}
}
\value{
Dataframe returned containing gene lists in entrezid and Gene 
Symbols, and terms associated with it
}
\description{
Extracting genes from gene database NCBI.
}
\examples{
terms="Liver cirrhosis"
ge <- gene_extraction(terms)
}
