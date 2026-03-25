test_that("susneo_validate_data fails when required columns missing", {
  df <- data.frame(
    id = 1:2,
    site = c("A", "B"),
    date = as.Date(c("2025-08-01", "2025-08-02")),
    type = c("Electricity", "Gas"),
    value = c(1, 2)
  )

  expect_error(susneo_validate_data(df), "Missing required columns")
})

