if (requireNamespace("testthat", quietly = TRUE)) {
  library("checkmate")
  library("testthat")
  library("mlr3spatiotempcv")
  # skips all tests on CRAN
  if (identical(Sys.getenv("NOT_CRAN"), "true")) {
    test_check("mlr3spatiotempcv")
  }
}
