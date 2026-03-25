test_that("SusneoEnergyService KPI calculations are correct", {
  svc <- SusneoEnergyService$new()

  df <- data.frame(
    id = 1:4,
    site = c("A", "A", "B", "B"),
    date = as.Date(c("2025-08-01", "2025-08-01", "2025-08-02", "2025-08-02")),
    type = c("Electricity", "Gas", "Electricity", "Gas"),
    value = c(10, 5, 7, 3),
    carbon_emission_kgco2e = c(1, 2, 3, 4)
  )

  k <- svc$kpis(df)
  expect_equal(k$total_consumption, 25)
  expect_equal(k$total_emissions, 10)

  # daily totals: 15 and 10 -> avg 12.5
  expect_equal(k$avg_daily_consumption, 12.5)
})

