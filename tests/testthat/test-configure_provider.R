test_that("configure_provider - wrong provider", {
  expect_error(configure_provider("FAKE_PROVIDER"), "`name` must be one of ")
})

test_that("configure_provider - network issues", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    models_anthropic = function(...) stop("some error"),
    .package = "myownrobs"
  )
  expect_error(configure_provider("anthropic", "ANT_KEY"), "The provided `api_key` is not working.")
})

### anthropic

test_that("configure_provider - anthropic - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("anthropic", "ANT_KEY"), list(anthropic = "ANT_KEY"))
})

test_that("configure_provider - anthropic - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY")
  )
})

test_that("configure_provider - anthropic - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY")
  )
  expect_equal(
    configure_provider("anthropic", "ANT_KEY2"),
    list(provider = "FAKE_KEY", anthropic = "ANT_KEY2")
  )
})

test_that("configure_provider - anthropic - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("anthropic", NULL), list(provider = "FAKE_KEY"))
})

test_that("configure_provider - anthropic - delete key to empty", {
  local_mocked_bindings(
    get_config = function(...) '{"anthropic":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_anthropic = function(...) NULL,
    .package = "myownrobs"
  )
  expect_length(configure_provider("anthropic", NULL), 0)
})

### deepseek

test_that("configure_provider - deepseek - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_deepseek = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("deepseek", "DS_KEY"), list(deepseek = "DS_KEY"))
})

test_that("configure_provider - deepseek - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_deepseek = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("deepseek", "DS_KEY"),
    list(provider = "FAKE_KEY", deepseek = "DS_KEY")
  )
})

test_that("configure_provider - deepseek - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","deepseek":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_deepseek = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("deepseek", "DS_KEY"),
    list(provider = "FAKE_KEY", deepseek = "DS_KEY")
  )
  expect_equal(
    configure_provider("deepseek", "DS_KEY2"),
    list(provider = "FAKE_KEY", deepseek = "DS_KEY2")
  )
})

test_that("configure_provider - deepseek - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","deepseek":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_deepseek = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("deepseek", NULL), list(provider = "FAKE_KEY"))
})

### google_gemini

test_that("configure_provider - google_gemini - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("google_gemini", "GG_KEY"), list(google_gemini = "GG_KEY"))
})

test_that("configure_provider - google_gemini - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY")
  )
})

test_that("configure_provider - google_gemini - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","google_gemini":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY")
  )
  expect_equal(
    configure_provider("google_gemini", "GG_KEY2"),
    list(provider = "FAKE_KEY", google_gemini = "GG_KEY2")
  )
})

test_that("configure_provider - google_gemini - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","google_gemini":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_google_gemini = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("google_gemini", NULL), list(provider = "FAKE_KEY"))
})

### ollama

test_that("configure_provider - ollama - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_ollama = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("ollama", "OL_KEY"), list(ollama = "OL_KEY"))
})

test_that("configure_provider - ollama - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_ollama = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("ollama", "OL_KEY"),
    list(provider = "FAKE_KEY", ollama = "OL_KEY")
  )
})

test_that("configure_provider - ollama - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","ollama":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_ollama = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("ollama", "OL_KEY"),
    list(provider = "FAKE_KEY", ollama = "OL_KEY")
  )
  expect_equal(
    configure_provider("ollama", "OL_KEY2"),
    list(provider = "FAKE_KEY", ollama = "OL_KEY2")
  )
})

test_that("configure_provider - ollama - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","ollama":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_ollama = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("ollama", NULL), list(provider = "FAKE_KEY"))
})

### openai

test_that("configure_provider - openai - add key", {
  local_mocked_bindings(
    get_config = function(...) NULL,
    set_config = function(...) NULL,
    models_openai = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("openai", "OA_KEY"), list(openai = "OA_KEY"))
})

test_that("configure_provider - openai - add key to non-empty keys", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY"}',
    set_config = function(...) NULL,
    models_openai = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("openai", "OA_KEY"),
    list(provider = "FAKE_KEY", openai = "OA_KEY")
  )
})

test_that("configure_provider - openai - update key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","openai":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_openai = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(
    configure_provider("openai", "OA_KEY"),
    list(provider = "FAKE_KEY", openai = "OA_KEY")
  )
  expect_equal(
    configure_provider("openai", "OA_KEY2"),
    list(provider = "FAKE_KEY", openai = "OA_KEY2")
  )
})

test_that("configure_provider - openai - delete key", {
  local_mocked_bindings(
    get_config = function(...) '{"provider":"FAKE_KEY","openai":"OLD_KEY"}',
    set_config = function(...) NULL,
    models_openai = function(...) NULL,
    .package = "myownrobs"
  )
  expect_equal(configure_provider("openai", NULL), list(provider = "FAKE_KEY"))
})
