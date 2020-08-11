**nanotatoR: structural variant annotation and classification**
**author: "Surajit Bhattacharya,Hayk Barsheghyan, Emmanuele C Delot and Eric Vilain**

# Introduction
Short-read sequencing (**SRS**) is the predominant technique of DNA sequencing used for clinical diagnosis. It utilizes flowcells covered with millions of surface-bound oligonucleotides that allow parallel sequencing of hundreds of millions of independent short reads. However, as the average sequencing read length is approximately 150 bp, large structural variants (**SVs**) and copy number variants (**CNVs**) are challenging to observe. This creates a diagnostic gap between the clinical phenotypes and the underlying genetic mechanisms in the field of biomedical sciences. Novel technologies such as optical genome mapping and long-read sequencing have partially addressed the issues of SV and CNV detection; however, the identification of pathogenic variants among thousands of called SVs/CNVs throughout the genome has proven to be challenging as the analytical pipelines available for single nucleotide variants are not applicable to SV analysis. Thus, we have built an R-based annotation package “nanotatoR” specifically for structural variants to provide a multitude of critical functional annotations for large genomic variations.

#Package Installation

**nanotatoR** is currently available from the GitHub repository. Installation method is as follows:
```{r eval=FALSE}
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("nanotatoR", version = "3.8")
```

```{r eval=TRUE}
library("nanotatoR")
```

The **nanotatoR** package is compatible with R versions ≥ 3.6.

#Package Functionalities

Given a list of structural variants with chromosome number, SV type, and variant start/end positions, nanotatoR can perform the following functions (both GRCh37/38 can be used):

##Structural Variant Frequency

Genomic variant frequencies are one of the most important filtration characteristics for identification of rare, possibly pathogenic, variants. NanotatoR uses the Database of Genomic Variants (**DGV**) and DECIPHER (**DECIPHER**), publicly available reference control database, to estimate structural variant frequencies in the general population. Compared with the traditional single nucleotide variant frequency calculations, frequency estimates for structural variants pose larger difficulty due to the much higher breakpoint variability between “same” structural variants. In order to provide accurate estimates of population frequencies, nanotatoR recognizes five categories of SVs: insertions, deletions, duplications, inversions and translocations (e.g. “gains” of DNA material are considered as “insertions/duplications” and “losses” of DNA material as “deletions”). In order for two SVs to be considered as “same”, nanotatoR, by default, checks whether they belong to the same category (e.g. deletion), have greater than 50% size similarity and the SV breakpoints (start and end positions) are within 10 kbp from each other. Currently the 50% size similarity cutoff is not applied for duplications, inversions and translocations as the sizes for these structural variants are not computed by most SV callers; however, a breakpoint cutoff of 50 kbp is applied in order to identify matching variants (note: duplication breakpoint cutoff is 10 kbp). Default breakpoint cutoffs and percent similarity determined by Bionano Genomics (see the references). 
In order for the natotatoR to estimate SV frequencies it requires the following input files: DECIPHER reference file(**decipherpath**) and “smap” file containing structural variant information generated via default Bionano Genomics Solve/Tools Pipelines for optical mapping-based SV calling (**smappath**). The default input parameters for SV breakpoints and percent similarities are as follows: insertions/duplications/deletions (**win_indel**) of 10,000 bases, inversions and translocations (**win_inv_trans**) of 50,000 bases and percentage similarity (**perc_similarity**) of 
0.5 or 50%. The user has to provide the (**EnzymeType**) as an input, which signifies whether BSPQI and BSSSI was used (**EnzymeType = "SVmerge"**) or DLE was used (**EnzymeType = "SVmerge"**). The output from this function can be of 2 types: an R object (**dataFrame**) or a text file (**Text**).

```{r eval=TRUE}
decipherpath = system.file("extdata", "population_cnv.txt",
    package="nanotatoR")
smappath=system.file("extdata", "GM24385_Ason_DLE1_VAP_trio5.smap", 
package="nanotatoR")
datdecipher <- Decipherfrequency (decipherpath = decipherpath, 
    smap = smappath, win_indel = 10000,
    EnzymeType= "SE",
    perc_similarity = 0.5,returnMethod="dataFrame", 
    input_fmt_SV = "Text")
```

For DGV the only parameter which is different from Decipher frequency function is **hgpath**, which stores the DGV database path.
```{r eval=TRUE}
hgpath=system.file("extdata", "GRCh37_hg19_variants_2016-05-15.txt", package="nanotatoR")
smappath=system.file("extdata", "GM24385_Ason_DLE1_VAP_trio5.smap", package="nanotatoR")
datDGV <- DGVfrequency (hgpath = hgpath, 
    smap = smappath,
    win_indel_DGV = 10000,
    EnzymeType = "SE", 
    input_fmt_SV = "Text",
    perc_similarity_DGV = 0.5,returnMethod="dataFrame")
```
Other than **DGV** and **DECIPHER**, nanotatoR can also take as input a data set of variants created by Bionano Genomics comprising of 234 samples. Input parameters are similar to that of **DECIPHER**, with an addition of following parameters: confidence score threshold for insertion and deletion (**indelconf**; Default is 0.5), inversion (**invconf**; Default is 0.01) and translocation (**transconf**; Default is 0.1 (determined by Bionano Genomics) and  size limit (**limsize**; default 1000 bp). Additionally, the user is also given an option to build the bionano internal database(**buildBNInternalDB** = TRUE). If TRUE, the user has to provide the path (**BNDBpath**) and the pattern  or the human reference genome used (**BNDBpattern**). This currently is either "*_hg19_*" or "*_hg38_*". If *buildBNInternalDB** = FALSE, then the  **internalBNDB** parameter would have the path to the internal bndb database.
Note: The Bionano genomic reference database can be downloaded using the following command wget http://bnxinstall.com/solve/Solve3.3_10252018.tar.gz , followed by decompressing it using the tar -xvzf Solve3.3_10252018.tar.gz. The folder containing the database is in the config file which can be found in the folowing directory $PWD/Solve3.3_10252018/VariantAnnotation/10252018/config/. The reference files are named  based on the variant type and reference genome. For example: current_ctrl_dup_hg19_anonymize.txt, would be the duplication reference variant file for hg19 reference genome.

```{r eval=TRUE}
path <- system.file("extdata", "Bionano_config/", package = "nanotatoR")
pattern <- "*_hg19_*"
smapName="GM24385_Ason_DLE1_VAP_trio5.smap"
smap = system.file("extdata", smapName, package="nanotatoR")
BNDBfrequency(smap = smap, 
   buildBNInternalDB=TRUE, 
   input_fmt_SV = "Text",
   dbOutput="dataframe",
   BNDBpath = path, 
   BNDBpattern = pattern, 
   outpath, 
   win_indel = 10000,
   win_inv_trans = 50000, 
   perc_similarity = 0.5, 
   indelconf = 0.5, 
   invconf = 0.01, 
   limsize = 1000,
   transconf = 0.1,
   returnMethod=c("dataFrame"), 
   EnzymeType = c("SE"))
```

##Cohort Analysis

The cohort analysis is designed to provide internal variant frequency, and parental zygosity within the cohort. This function has similar input parameters like **BNDBfrequency**, for confidnce, percentage and Enzyme type. Additionally, the user is given an option to build an internal reference” (**buildSVInternalDB**=*TRUE*), in that scenario the user has to provide enzyme type of the datasets they want to merge (**labelType** = c("SVMerge", "SE", "Both")), the path and pattern to chose for each label(**SVMerge_path**  and **SVMerge_pattern** for samples using both enzymes and **SE_path**  and **SE_pattern** for samples using only one enzyme for labelling), relationship index file (**Samplecodes**), sample id information table (**mergeKey**), path for the internal database index (**mergedKeyoutpath**), file name for the internal database index (**mergedKeyFname**) and **outputMode** = "dataframe", to provide the internal database as a dataframe. For **buildSVInternalDB**=*FALSE*, the user has to just provide the **mergedFiles** and the sample index **indexfile**. In the example we show the functionality using the *internalFrequency_solo* function for SE. For dual label we can use *internalFrequencyTrio_Duo*.

```{r eval=TRUE}
smapName="GM24385_Ason_DLE1_VAP_trio5.smap"
smap = system.file("extdata", smapName, package="nanotatoR")
indelconf = 0.5; invconf = 0.01;transconf = 0.1;input_fmt_SV="Text";
datInf <- internalFrequency_solo( smap = smap, 
buildSVInternalDB = FALSE, win_indel=10000, 
win_inv_trans=50000, EnzymeType = "SE",
mergedFiles = system.file("extdata", "nanotatoRControl.txt", package="nanotatoR"), 
perc_similarity_parents =0.9,
indexfile = system.file("extdata", "Sample_index.csv", package="nanotatoR"),
perc_similarity=0.5, indelconf=0.5, invconf=0.01, 
transconf=0.1, limsize=1000, win_indel_parents=5000,input_fmt="Text",
win_inv_trans_parents=40000,
returnMethod="dataFrame", input_fmt_SV = "Text")

```

##Gene Overlap 

Incorporates known gene and non-coding RNA genomic locations that overlap with or are near the identified structural variants. NanotatoR automatically determines the number of overlapping genes for a given structural variant, provides gene strandedness (+ or -) as well as the percent overlap of SVs with the gene. The function also provides gene names and corresponding distances from SVs for the nearest genes (user selected, default 3 on each side) that are upstream and downstream.
The function requires an input BED file (**inputfmt**=*BED*) or Bionano compliant BED file (**inputfmt**=*BNBED*), which re-codes the X and Y chromosome notations to 23 and 24, respectively. The BED files are used to overlap structural variants of the query smap file (**smap**) with overlapping and non-overlapping upstream and downstream genes (**n**;default is 3). Additionally the user also has to provide the base pair error for indel (**bperrorindel**; default 3000 bp) and inversion and translocation (**bperrorinvtrans**; default 50000 bp) The output from this function can be of 2 types: an R object (**dataFrame**) or a text file (**Text**).



```{r eval=TRUE}
smapName="GM24385_Ason_DLE1_VAP_trio5.smap"
smap = system.file("extdata", smapName, package="nanotatoR")
bedFile <- system.file("extdata", "HomoSapienGRCH19_lift37.bed", package="nanotatoR")
outpath <- system.file("extdata", package="nanotatoR")
datcomp<-overlapnearestgeneSearch(smap = smap, 
bed=bedFile, inputfmtBed = "bed", outpath, 
n = 3, returnMethod_bedcomp = c("dataFrame"), 
input_fmt_SV = "Text",
EnzymeType = "SE", 
bperrorindel = 3000, bperrorinvtrans = 50000)
```

##Entrez Extract

Generates a list of genes involved with the patient phenotype and overlaps it with gene names that span structural variants. The user provided, phenotypic key words are used to generate gene lists from selected databases such as ClinVar, OMIM, GTR and Gene Registry. The generated lists are used to prioritize structural variants that occur in genes known to be associated with patient’s phenotype.
The input to the function is a term, which can be provided as a single character input (**method**="Single"), or a vector of terms (**method**="Multiple") or as a text file (**method**="Text"). Additionally, the user has to provide the location to omim (**omim**), Clinvar (**clinvar**), download option for gtr and clinvar (**downloadClinvar** and **downloadGTR**) and remove the clinvar and gtr database after the function is done (**removeClinvar** and **removeGTR**). The output can be selected as a (**dataFrame**) or a text file (**Text**).

```{r eval=TRUE}
terms="CIRRHOSIS, FAMILIAL"
genes <- gene_list_generation(
     method_entrez = c("Single"), 
     term = terms,
     returnMethod=c("dataFrame"), 
     omimID = "OMIM:118980",
       omim = system.file("extdata", "mim2gene.txt", package="nanotatoR"), 
     clinvar = system.file("extdata", "localPDB/", package="nanotatoR"), 
       gtr = system.file("extdata", "gtrDatabase.txt", package="nanotatoR"),
       downloadClinvar = FALSE, downloadGTR = FALSE)
 gene[1:10,]
```


##Filter Variants 

Provides easy to use, user-selected, filtration criteria to segregate variants into corresponding groups (such as de novo, inherited or occurring in the gene list). In this step the generated or available gene lists are appended to the smap file.
The input file for this function can either be an (**smap**) or a dataframe. Both raw and nanotatoR-annotated smaps can serve as inputs. It has an option to take the input of the smap (**input_fmt_svMap**) and genelist (**input_fmt_geneList**) as a dataFrame or a text file, and produces an excel as the output. The example is for a single label trio sample(function is **run_bionano_filter_SE_Trio**), but the user can also filter dual label trio samples (**run_bionano_filter_SVmerge_trio**), single label dyad sample (**run_bionano_filter_SE_duo**), dual dyad samples (**run_bionano_filter_SVmerge_duo**), single label singleton samples (**run_bionano_filter_SE_solo**) and dual label singleton samples (**run_bionano_filter_SVmerge_solo**).

```{r eval=FALSE}
smapName <- "GM24385_Ason_DLE1_VAP_trio5.smap"
outputFilename <- "GM24385_Ason_DLE1_VAP_trio5_out"
smappath <- system.file("extdata", smapName, package = "nanotatoR")
outpath <- system.file("extdata", smapName, package = "nanotatoR")
RZIPpath <- system.file("extdata", "zip.exe", package = "nanotatoR")
smap = system.file("extdata", smapName, package="nanotatoR")
bedFile <- system.file("extdata", "HomoSapienGRCH19_lift37.bed", package="nanotatoR")
outpath <- system.file("extdata", package="nanotatoR")
datcomp<-overlapnearestgeneSearch(smap = smap, 
    bed=bedFile, inputfmtBed = "bed", outpath, 
    n = 3, returnMethod_bedcomp = c("dataFrame"), 
    input_fmt_SV = "Text",
    EnzymeType = "SE", 
    bperrorindel = 3000, bperrorinvtrans = 50000)
hgpath=system.file("extdata", "GRCh37_hg19_variants_2016-05-15.txt", package="nanotatoR")
datDGV <- DGVfrequency (hgpath = hgpath, 
    smap_data = datcomp,
    win_indel_DGV = 10000, 
    input_fmt_SV = "dataFrame",
    perc_similarity_DGV = 0.5,returnMethod="dataFrame")
    indelconf = 0.5; invconf = 0.01;transconf = 0.1;
datInf <- internalFrequencyTrio_Duo(smapdata = datDGV, 
    buildSVInternalDB=TRUE, win_indel=10000, 
    win_inv_trans=50000, 
    labelType = c("SE"),
    SE_path = system.file("extdata", "SoloFile/", package="nanotatoR"),
    SE_pattern = "*_DLE1_*", perc_similarity_parents =0.9,
    Samplecodes = system.file("extdata", "nanotatoR_sample_codes.csv", package="nanotatoR"),
    mergeKey = system.file("extdata", "nanotatoR_control_sample_codes.csv", package="nanotatoR"),
    mergedKeyoutpath = system.file("extdata", package="nanotatoR"), 
    mergedKeyFname = "Sample_index.csv",
    indexfile = system.file("extdata", mergedKeyFname, package="nanotatoR"),
    perc_similarity = 0.5, indelconf = 0.5, invconf = 0.01, 
    transconf = 0.1, limsize = 1000, win_indel_parents = 5000,
    win_inv_trans_parents=40000,
    returnMethod="dataFrame", input_fmt_SV = "dataFrame")
path <- system.file("extdata", "Bionano_config/", package = "nanotatoR")
pattern <- "*_hg19_*"
datBNDB <- BNDBfrequency(smapdata = datInf, 
    buildBNInternalDB=TRUE, 
    input_fmt_SV = "dataFrame",
    dbOutput="dataframe",
    BNDBpath = path, 
    BNDBpattern = pattern, 
    fname, outpath, 
    win_indel = 10000,
    win_inv_trans = 50000, 
    perc_similarity = 0.5, 
    indelconf = 0.5, 
    invconf = 0.01, 
    limsize = 1000,
    transconf = 0.1,
    returnMethod=c("dataFrame"), 
    EnzymeType = c("SE"))
decipherpath = system.file("extdata", "population_cnv.txt", package="nanotatoR")
datdecipher <- Decipherfrequency (decipherpath = decipherpath, 
    smap_data = datBNDB, win_indel = 10000, 
    perc_similarity = 0.5,returnMethod="dataFrame", 
    input_fmt_SV = "dataFrame", EnzymeType = c("SE"))
run_bionano_filter_SE_Trio (input_fmt_geneList = c("Text"),
    input_fmt_SV = c("dataFrame"),
    svData = datdecipher, 
    dat_geneList = dat_geneList,
    RZIPpath = RZIPpath, EnzymeType = c("SE"),
    outputType = c("Excel"),
    primaryGenesPresent = FALSE, 
    outputFilename = outputFilename,
    outpath = outpath)
```

##Main

The main function consecutively runs the available nanotatoR sub-functions by appending the outputs from each function. 
It takes as an input the smap file, DGV file, BED file, internal database file, phenotype term list as an input. It also takes in the output path and the filename for the final excel file. Individual, sub-function, input parameters are also available for user selections.
Again the functions are different for different samples and label types; with the nomenclature **nanotatoR_main_Sample type_Label type**. So the functions are **nanotatoR_main_Solo_SE**, **nanotatoR_main_Duo_SE**, **nanotatoR_main_Trio_SE**, **nanotatoR_main_Solo_SVmerge**, **nanotatoR_Duo_SVmerge** and **nanotatoR_SVmerge_Trio**, respectively. 


```{r eval=FALSE}
    smapName="GM24385_Ason_DLE1_VAP_trio5.smap"
    smap = system.file("extdata", smapName, package="nanotatoR")
    bedFile <- system.file("extdata", "HomoSapienGRCH19_lift37.bed", package="nanotatoR")
    hgpath=system.file("extdata", "GRCh37_hg19_variants_2016-05-15.txt", package="nanotatoR")
    decipherpath = system.file("extdata", "population_cnv.txt", package="nanotatoR")
    omim = system.file("extdata", "mim2gene.txt", package="nanotatoR") 
    clinvar = system.file("extdata", "localPDB/", package="nanotatoR") 
    gtr = system.file("extdata", "gtrDatabase.txt", package="nanotatoR")
    mergedFiles = system.file("extdata", "nanotatoRControl.txt", package="nanotatoR")
    indexfile = system.file("extdata", "Sample_index.csv", package="nanotatoR")
    RNASeqDir = system.file("extdata", "NA12878_P_Blood_S1.genes.results", package="nanotatoR")
    path = system.file("extdata", "Bionano_config/", package = "nanotatoR")
    pattern = "_hg19.txt"
    outputFilename <- "NA12878_DLE1_VAP_solo5_out"
    outpath <- system.file("extdata", smapName, package = "nanotatoR")
    RZIPpath <- system.file("extdata", "zip.exe", package = "nanotatoR")
    nanotatoR_main_Trio_SE(
        smap = smap, bed = bedFile, inputfmtBed = c("bed"), 
        n=3,EnzymeType = c("SE"),
        buildBNInternalDB=TRUE,
        path = path , pattern = pattern, 
        buildSVInternalDB = FALSE,
        decipherpath = decipherpath,
        win_indel_INF = 10000, win_inv_trans_INF = 50000, 
        perc_similarity_INF= 0.5, indelconf = 0.5, invconf = 0.01, 
        transconf = 0.1, perc_similarity_INF_parents = 0.9,
        hgpath = hgpath, win_indel_DGV = 10000, 
        win_inv_trans_DGV = 50000, 
        perc_similarity_DGV = 0.5, limsize = 1000,
        method_entrez=c("Single"), 
        term = "Liver cirrhosis", RZIPpath = RZIPpath,
        omim = omim, clinvar = clinvar, gtr = gtr, 
        removeClinvar = TRUE, removeGTR = TRUE, 
        downloadClinvar = FALSE, downloadGTR = FALSE,
        RNASeqDatasetPresent = TRUE,
        RNAseqcombo = TRUE, geneListPresent = FALSE,
        RNASeqDir = RNASeqDir, returnMethod = "dataFrame",
        pattern_Proband = "*_P_*",
        outpath = outpath,
        indexfile = system.file("extdata", "Sample_index.csv",package="nanotatoR"),
        primaryGenesPresent = FALSE,
        outputFilename = outputFilename, 
        termListPresent = FALSE,
        InternaldatabasePresent = TRUE,
        outputType = c("Excel"))
```

#References

1. Hayk Barseghyan, Wilson Tang, Richard T. Wang, Miguel Almalvez, Eva Segura, Matthew S. Bramble, Allen Lipson, Emilie D. Douine, Hane Lee, Emmanuèle C. Délot, Stanley F. Nelson and Eric Vilain.Next-generation mapping: a novel approach for detection of pathogenic structural variants with a potential utility in clinical diagnosis. Genome Medicine 2017 9:90. https://doi.org/10.1186/s13073-017-0479-0

2. Winter, D. J.  rentrez: an R package for the NCBI eUtils API The R Journal 2017 9(2):520-526

3. Christopher Brown.  hash: Full feature implementation of hash/associated arrays/dictionaries.2013. R package version 2.2.6. https://CRAN.R-project.org/package=hash

4. Hadley Wickham. stringr: Simple, Consistent Wrappers for Common String Operations. 2018. R package version 1.3.1. https://CRAN.R-project.org/package=stringr

5. Bionano Genomics. Theory Of Operation – Structural Variant Calling. https://bionanogenomics.com/wp-content/uploads/2018/04/30110-Bionano-Solve-Theory-of-Operation-Structural-Variant-Calling.pdf

6. Bionano Genomics. Theory of Operation - Variant Annotation Pipeline. https://bionanogenomics.com/wp-content/uploads/2018/04/30190-Bionano-Solve-Theory-of-Operation-Variant-Annotation-Pipeline.pdf
