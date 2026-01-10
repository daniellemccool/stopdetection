test_that("haversine_cpp calculates correct distance", {
  # Distance between two known points (Amsterdam to Utrecht, ~34km)
  dist <- haversine_cpp(52.3676, 4.9041, 52.0907, 5.1214)
  expect_true(dist > 33000 && dist < 35000)

  # Same point should return 0
  expect_equal(haversine_cpp(52.0, 5.0, 52.0, 5.0), 0)
})

test_that("haversine_vec works with vectors", {
  lat1 <- c(52.0, 52.1)
  lon1 <- c(5.0, 5.1)
  lat2 <- c(52.1, 52.2)
  lon2 <- c(5.1, 5.2)

  dists <- haversine_vec(lat1, lon1, lat2, lon2)

  expect_length(dists, 2)
  expect_true(all(dists > 0))
})

test_that("haversine_seq works with sequential points", {
  lat <- c(52.0, 52.1, 52.2)
  lon <- c(5.0, 5.1, 5.2)

  dists <- haversine_seq(lat, lon)

  expect_length(dists, 2) # n-1 distances
  expect_true(all(dists > 0))
})

test_that("haversine functions handle edge cases", {
  # Empty vectors
  expect_length(haversine_seq(numeric(0), numeric(0)), 0)

  # Single point
  expect_length(haversine_seq(52.0, 5.0), 0)

  # Mismatched lengths should error
  expect_error(haversine_vec(c(52.0, 52.1), 5.0, 52.1, 5.1))
})
