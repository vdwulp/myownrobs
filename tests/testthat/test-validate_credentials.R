### validate_credentials

test_that("validate_credentials - valid credential", {
  local_mocked_bindings(
    get_api_key = function() {
      list(openai = "VALID_API_KEY")
    },
    .package = "myownrobs"
  )
  result <- validate_credentials()
  expect_null(result)
})

test_that("validate_credentials - valid credentials", {
  local_mocked_bindings(
    get_api_key = function() {
      list(anthropic = "VALID_API_KEY_1", openai = "VALID_API_KEY_2")
    },
    .package = "myownrobs"
  )
  result <- validate_credentials()
  expect_null(result)
})

test_that("validate_credentials - invalid credentials NULL", {
  local_mocked_bindings(
    get_api_key = function() NULL,
    .package = "myownrobs"
  )
  expect_error(validate_credentials())
})

test_that("validate_credentials - invalid credentials empty", {
  local_mocked_bindings(
    get_api_key = function() list(),
    .package = "myownrobs"
  )
  expect_error(validate_credentials())
})
