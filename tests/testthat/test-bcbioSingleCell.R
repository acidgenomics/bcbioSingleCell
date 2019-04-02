context("S4 class")



test_that("bcbioSingleCell", {
    uploadDir <- system.file("extdata/indrops", package = "bcbioSingleCell")

    # Minimal mode, with no metadata or annotations.
    # This is fast but doesn't slot a lot of useful info.
    x <- bcbioSingleCell(uploadDir = uploadDir)
    expect_s4_class(x, "bcbioSingleCell")

    # User-defined metadata.
    x <- bcbioSingleCell(
        uploadDir = uploadDir,
        sampleMetadataFile <- file.path(uploadDir, "metadata.csv")
    )
    expect_s4_class(x, "bcbioSingleCell")

    # Automatic organism annotations from AnnotationHub.
    x <- bcbioSingleCell(
        uploadDir = uploadDir,
        organism = "Homo sapiens"
    )
    expect_s4_class(x, "bcbioSingleCell")
})