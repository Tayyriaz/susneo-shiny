test_that("susneo_normalize_names standardizes column names", {
  x <- c(" Carbon emission in kgco2e ", "Site", "DATE")
  expect_equal(
    susneo_normalize_names(x),
    c("carbon_emission_in_kgco2e", "site", "date")
  )
})

