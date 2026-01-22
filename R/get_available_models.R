#' Return the Available Models
#'
#' @importFrom stats setNames
#'
#' @keywords internal
#'
get_available_models <- function() {
  api_keys <- get_api_key()
  providers <- setdiff(names(api_keys), "myownrobs")
  models <- lapply(providers, function(provider) {
    get_ellmer_models(provider, api_keys[[provider]])
  })
  setNames(models, providers)
}

#' Get Ellmer Models
#'
#' @param provider A character string indicating the model provider (e.g., "anthropic", "deepseek",
#'   "google_gemini", "ollama", "openai").
#' @param api_key A character string containing the API key or credentials used to query the
#'   provider.
#'
#' @importFrom ellmer models_anthropic models_google_gemini models_ollama models_openai
#' @importFrom stats setNames
#' @importFrom tools toTitleCase
#'
#' @keywords internal
#'
get_ellmer_models <- function(provider, api_key) {
  if (provider == "anthropic") {
    models <- try(models_anthropic(api_key = api_key), silent = TRUE)
  } else if (provider == "deepseek") {
    models <- try(models_deepseek(credentials = function() api_key), silent = TRUE)
  } else if (provider == "google_gemini") {
    models <- try(models_google_gemini(credentials = function() api_key), silent = TRUE)
  } else if (provider == "ollama") {
    models <- try(models_ollama(credentials = function() api_key), silent = TRUE)
  } else if (provider == "openai") {
    models <- try(models_openai(credentials = function() api_key), silent = TRUE)
  }
  if (inherits(models, "try-error")) {
    message("Couldn't fetch models for ", provider, ".")
    return()
  }
  if ("name" %in% colnames(models)) {
    models <- setNames(models$id, models$name)
  } else {
    models <- setNames(models$id, gsub("-", " ", toTitleCase(models$id)))
  }
  models
}

#' Retrieve Available DeepSeek Models
#'
#' Fetches a list of currently available models from the DeepSeek API.
#'
#' @param credentials A function that returns the API key as a character string.
#'
#' @importFrom httr add_headers content GET
#'
#' @keywords internal
#'
models_deepseek <- function(credentials = NULL) {
  models <- GET(
    "https://api.deepseek.com/models",
    add_headers(Authorization = paste("Bearer", credentials()))
  )
  models <- content(models, as = "parsed")
  data.frame(id = sapply(models$data, function(x) x$id))
}

#' Make Nicer Names
#'
#' @param names A character vector of names to be converted to a nicer, title-cased form.
#'
#' @importFrom tools toTitleCase
#'
#' @keywords internal
#'
nice_names <- function(names) {
  toTitleCase(gsub("_", " ", names))
}
