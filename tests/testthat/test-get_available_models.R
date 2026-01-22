### get_available_models

test_that("get_available_models - myownrobs no models", {
  local_mocked_bindings(
    get_api_key = function(...) list(myownrobs = "api_key"),
    .package = "myownrobs"
  )
  expect_length(get_available_models(), 0)
})

test_that("get_available_models - api_keys", {
  local_mocked_bindings(
    get_api_key = function(...) {
      list(
        myownrobs = "api_key", provider_a = "key_a", provider_b = "key_b"
      )
    },
    get_ellmer_models = function(provider, api_key) {
      if (provider == "provider_a") {
        list(Model_A = "model_a")
      } else if (provider == "provider_b") {
        list(Model_B = "model_b", Model_C = "model_c")
      }
    },
    .package = "myownrobs"
  )
  expect_equal(get_available_models(), list(
    provider_a = list(Model_A = "model_a"),
    provider_b = list(Model_B = "model_b", Model_C = "model_c")
  ))
})

test_that("get_available_models - api_keys no models", {
  local_mocked_bindings(
    get_api_key = function(...) {
      list(
        myownrobs = "api_key", provider_a = "key_a", provider_b = "key_b"
      )
    },
    get_ellmer_models = function(provider, api_key) list(),
    .package = "myownrobs"
  )
  expect_equal(get_available_models(), list(provider_a = list(), provider_b = list()))
})

### get_ellmer_models

test_that("get_ellmer_models - random failure", {
  local_mocked_bindings(
    models_anthropic = function(...) stop("Some random failure"),
    .package = "myownrobs"
  )
  expect_null(get_ellmer_models("anthropic"))
})

test_that("get_ellmer_models - anthropic", {
  available_models <- list("Model A" = "model-a", "Model A" = "model-b", "Model C" = "model-c")
  local_mocked_bindings(
    models_anthropic = function(...) {
      data.frame(
        id = unlist(available_models), name = names(available_models)
      )
    },
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("anthropic"), unlist(available_models))
})

test_that("get_ellmer_models - deepseek", {
  available_models <- list("Model a" = "model-a", "Model b" = "model-b", "Model c" = "model-c")
  local_mocked_bindings(
    models_deepseek = function(...) data.frame(id = unlist(available_models)),
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("deepseek"), unlist(available_models))
})

test_that("get_ellmer_models - google_gemini", {
  available_models <- list("Model a" = "model-a", "Model b" = "model-b", "Model c" = "model-c")
  local_mocked_bindings(
    models_google_gemini = function(...) data.frame(id = unlist(available_models)),
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("google_gemini"), unlist(available_models))
})

test_that("get_ellmer_models - ollama", {
  available_models <- list("Model a" = "model-a", "Model b" = "model-b", "Model c" = "model-c")
  local_mocked_bindings(
    models_ollama = function(...) data.frame(id = unlist(available_models)),
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("ollama"), unlist(available_models))
})

test_that("get_ellmer_models - openai", {
  available_models <- list("Model a" = "model-a", "Model b" = "model-b", "Model c" = "model-c")
  local_mocked_bindings(
    models_openai = function(...) data.frame(id = unlist(available_models)),
    .package = "myownrobs"
  )
  expect_equal(get_ellmer_models("openai"), unlist(available_models))
})

### models_deepseek

test_that("models_deepseek", {
  available_models <- c("model-a", "model-b", "model-c")
  local_mocked_bindings(
    GET = function(...) NULL,
    content = function(...) list(data = lapply(available_models, function(x) list(id = x))),
    .package = "myownrobs"
  )
  expect_equal(models_deepseek(), data.frame(id = available_models))
})

### nice_names

test_that("nice_names", {
  expect_length(nice_names(c()), 0)
  expect_equal(nice_names("google_gemini"), "Google Gemini")
  expect_equal(nice_names(c("google_gemini", "anthropic")), c("Google Gemini", "Anthropic"))
  expect_equal(nice_names(c("provider_a", "some_provider")), c("Provider a", "some Provider"))
})
