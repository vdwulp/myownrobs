test_that("get_chat_instance - api_keys", {
  api_keys <- '{"provider_a":"api_key_a", "provider_b":"api_key_b"}'
  local_mocked_bindings(
    chat = function(...) {
      list(
        test_value = "myownrobs_chat_instance",
        register_tools = function(...) NULL,
        set_turns = function(...) NULL
      )
    },
    .package = "myownrobs"
  )
  mock_ci <- get_chat_instance(
    "mode", "MODEL", "project_context", jsonlite::fromJSON(api_keys),
    available_models = list(provider_a = c("MODEL_A", "MODEL"), provider_b = c("MODEL_B"))
  )
  expect_equal(mock_ci$test_value, "myownrobs_chat_instance")
  mock_ci <- get_chat_instance(
    "mode", "MODEL_B", "project_context", jsonlite::fromJSON(api_keys),
    available_models = list(provider_a = c("MODEL_A", "MODEL"), provider_b = c("MODEL_B"))
  )
  expect_equal(mock_ci$test_value, "myownrobs_chat_instance")
})
