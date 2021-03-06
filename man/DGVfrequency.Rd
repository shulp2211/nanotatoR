% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DGV_extraction.r
\name{DGVfrequency}
\alias{DGVfrequency}
\title{Frequency calculation of variants compared to DGV.}
\usage{
DGVfrequency(
  hgpath,
  smap,
  smap_data,
  win_indel_DGV = 10000,
  win_inv_trans_DGV = 50000,
  perc_similarity_DGV = 0.5,
  input_fmt_SV = c("Text", "dataframe"),
  returnMethod = c("Text", "dataFrame"),
  outpath,
  EnzymeType = c("SVMerge", "SE")
)
}
\arguments{
\item{hgpath}{character. Path to Database of Genomic Variants (DGV)
Text file.}

\item{smap}{character. File name for smap textfile.}

\item{smap_data}{dataframe. Dataset containing smap data.}

\item{win_indel_DGV}{Numeric. Insertion and deletion error window.Default 10000
bases.}

\item{win_inv_trans_DGV}{Numeric. Inversion and translocation error window.
Default 50000 bases.}

\item{perc_similarity_DGV}{Numeric . ThresholdPercentage similarity 
of the query SV and reference SV. Default 0.5.}

\item{input_fmt_SV}{boolean . Options Text and dataframe.}

\item{returnMethod}{character. Choice between text or data frame as the output.}

\item{outpath}{character. Path where gene lists are saved.}

\item{EnzymeType}{boolean . Options SE and SVMerge.}
}
\value{
Text and character vector containg gene list and terms associated with them
        are stored as text files.
}
\description{
Frequency calculation of variants compared to DGV.
}
\examples{
hgpath=system.file("extdata", "GRCh37_hg19_variants_2016-05-15.txt", package="nanotatoR")
smappath=system.file("extdata", "GM24385_Ason_DLE1_VAP_trio5.smap", package="nanotatoR")
datDGV <- DGVfrequency (hgpath = hgpath, 
smap = smappath,
win_indel_DGV = 10000,
EnzymeType = "SE", 
input_fmt_SV = "Text",
perc_similarity_DGV = 0.5,returnMethod="dataFrame")
}
