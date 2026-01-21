test_that("get_api_key - valid API keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider_a":"key_a", "provider_b":"key_b"}',
    .package = "myownrobs"
  )
  expect_equal(get_api_key(), list(provider_a = "key_a", provider_b = "key_b"))
})
