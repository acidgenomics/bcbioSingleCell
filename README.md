# bcbioSingleCell

[![Repo status: active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Travis CI build status](https://travis-ci.org/hbc/bcbioSingleCell.svg?branch=master)](https://travis-ci.org/hbc/bcbioSingleCell)
[![AppVeyor CI build status](https://ci.appveyor.com/api/projects/status/npy0mhfjn9saqv4g/branch/master?svg=true)](https://ci.appveyor.com/project/mjsteinbaugh/bcbiosinglecell/branch/master)
[![Anaconda version](https://anaconda.org/bioconda/r-bcbiosinglecell/badges/version.svg) ![Anaconda latest release date](https://anaconda.org/bioconda/r-bcbiosinglecell/badges/latest_release_date.svg) ![Anaconda downloads](https://anaconda.org/bioconda/r-bcbiosinglecell/badges/downloads.svg)](https://anaconda.org/bioconda/r-bcbiosinglecell)

[R][] package for [bcbio][] single-cell RNA-seq analysis.

## Installation

### [R][] method

```r
if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
}
Sys.setenv(R_REMOTES_UPGRADE = "always")
# Set `GITHUB_PAT` in `~/.Renviron` if you get a rate limit error.
remotes::install_github("hbc/bcbioSingleCell")
```

Here's how to update to the latest version on GitHub:

```r
Sys.setenv(R_REMOTES_UPGRADE = "always")
remotes::update_packages()
```

Always check that your Bioconductor installation is valid before proceeding.

```r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
BiocManager::valid()
```

### [conda][] method

Configure [conda][] to use the [bioconda][] channels.

```sh
conda install -c bioconda r-bcbiosinglecell
```

## Load [bcbio][] single-cell RNA-seq data

```r
library(bcbioSingleCell)
bcb <- bcbioSingleCell(
    uploadDir = "indrops/final",
    interestingGroups = c("genotype", "treatment"),
    sampleMetadataFile = "sample_metadata.csv",
    organism = "Homo sapiens",
    ensemblRelease = 90L
)
saveData(bcb, dir = ".")
```

This will return a `bcbioSingleCell` object, which is an extension of the [Bioconductor][] [SingleCellExperiment][SCE] container class. Consult the `bcbioSingleCell()` constructor function documentation for detailed information on the supported parameters:

```r
help(topic = "bcbioSingleCell", package = "bcbioSingleCell")
```

## Sample metadata examples

### FASTQ files with samples multiplexed by index barcode

This is our current recommended method for analyzing an [inDrops][] dataset. The sample index barcodes are multiplexed per FASTQ set. For Illumina sequencing data, the raw binary base call (BCL) data must be converted into FASTQs (split into `R1`-`R4` files) using [bcl2fastq][].

The [inDrops][] library version is automatically detected by [bcbio][], but ensure that the sample index sequences provided match the library version when attempting to create a `bcbioSingleCell` object.

Consult the [bcbio][] documentation for more information on how to configure an [inDrops][] run prior to loading into [R][] with the `bcbioSingleCell()` function.

| description | index | sequence | sampleName | aggregate | genotype |
|-------------|-------|----------|------------|-----------|----------|
| indrops1    | 1     | CTCTCTAT | sample1_1  | sample1   | wildtype |
| indrops1    | 2     | TATCCTCT | sample2_1  | sample2   | knockout |
| indrops1    | 3     | GTAAGGAG | sample3_1  | sample3   | wildtype |
| indrops1    | 4     | ACTGCATA | sample4_1  | sample4   | knockout |
| indrops2    | 1     | CTCTCTAT | sample1_2  | sample1   | wildtype |
| indrops2    | 2     | TATCCTCT | sample1_2  | sample2   | knockout |
| indrops2    | 3     | GTAAGGAG | sample1_2  | sample3   | wildtype |
| indrops2    | 4     | ACTGCATA | sample1_2  | sample4   | knockout |

Note that bcbio currently outputs the reverse complement index sequence in the sample directory names (e.g. `sample-ATAGAGAG`). Define the forward index barcode in the `sequence` column here, not the reverse complement. The reverse complement will be calculated automatically and added as the `revcomp` column in the sample metadata.

### FASTQ files demultiplexed per sample

This is our current method for handling [10X Genomics Chromium][chromium] and [Illumina SureCell][surecell] cell barcodes.

| description | genotype |
|-------------|----------|
| sample1     | wildtype |
| sample2     | knockout |
| sample3     | wildtype |
| sample4     | knockout |

### Invalid object

If you encounter a `validObject` error when attempting to load a `bcbioSingleCell` object from a previous analysis, run this step to update the object to the current version of the package:

```r
object <- updateObject(object)
validObject(object)
## [1] TRUE
```

## References

The papers and software cited in our workflows are available as a [shared library](https://paperpile.com/shared/C8EMxl) on [Paperpile][].

[bcbio]: https://bcbio-nextgen.readthedocs.io/
[bcl2fastq]: https://support.illumina.com/sequencing/sequencing_software/bcl2fastq-conversion-software.html
[biocmanager]: https://cran.r-project.org/package=BiocManager
[bioconda]: https://bioconda.github.io/
[bioconductor]: https://bioconductor.org/
[chromium]: https://www.10xgenomics.com/solutions/single-cell/
[conda]: https://conda.io/
[devtools]: https://cran.r-project.org/package=devtools
[indrops v3 index barcodes]: https://github.com/steinbaugh/koopa/blob/master/workflows/indrops/harvard_v3_sample_barcodes.csv
[indrops]: https://github.com/indrops/indrops/
[paperpile]: https://paperpile.com/
[r]: https://www.r-project.org/
[sce]: https://bioconductor.org/packages/SingleCellExperiment/
[surecell]: https://www.illumina.com/products/by-type/sequencing-kits/library-prep-kits/surecell-wta-ddseq.html
