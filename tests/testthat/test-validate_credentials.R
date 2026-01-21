### validate_credentials

test_that("validate_credentials - valid credentials", {
  local_mocked_bindings(
    get_api_key = function() {
      list(openai = "VALID_API_KEY")
    },
    .package = "myownrobs"
  )
  result <- validate_credentials()
  expect_null(result)
})
