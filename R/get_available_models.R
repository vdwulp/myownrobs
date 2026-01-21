#' Return the Available Models
#'
#' @importFrom stats setNames
#'
#' @keywords internal
#'
get_available_models <- function() {
  api_keys <- get_api_key()
  providers <- setdiff(names(api_keys), "myownrobs")
  lapply(providers, function(provider) {
    get_ellmer_models(provider, api_keys[[provider]])
  }) |> setNames(providers)
}

#' Get Ellmer Models
#'
#' @importFrom ellmer models_anthropic models_google_gemini models_openai
#' @importFrom stats setNames
#' @importFrom tools toTitleCase
#'
#' @keywords internal
#'
get_ellmer_models <- function(provider, api_key) {
  if (provider == "anthropic") {
    models <- models_anthropic(api_key = api_key)
  } else if (provider == "google_gemini") {
    models <- models_google_gemini(credentials = function() api_key)
  } else if (provider == "openai") {
    models <- models_openai(credentials = function() api_key)
  }
  if ("name" %in% colnames(models)) {
    models <- setNames(models$id, models$name)
  } else {
    models <- setNames(models$id, gsub("-", " ", toTitleCase(models$id)))
  }
  models
}


#' Make Nicer Names
#'
#' @importFrom tools toTitleCase
#'
#' @keywords internal
#'
nice_names <- function(names) {
  toTitleCase(gsub("_", " ", names))
}
