% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/OverlappingGenes.r
\name{readBNBedFiles}
\alias{readBNBedFiles}
\title{Reads Bionano Bedfiles}
\usage{
readBNBedFiles(BNFile)
}
\arguments{
\item{BNFile}{character. Path to Bionano Bed File.}
}
\value{
Data Frame Contains the gene information.
}
\description{
Reads Bionano Bedfiles
}
\examples{
BNFile <- system.file("extdata", "HomoSapienGRCH19_lift37_BN.bed", package="nanotatoR")
bed<-readBNBedFiles(BNFile)
}
