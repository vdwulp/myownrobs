#' Add a Provider to be Used
#'
#' Set API keys for running models locally.
#'
#' @param name Name of the provider (one of "anthropic", "deepseek", "google_gemini", "ollama", or
#'   "openai").
#' @param api_key The provider's API key to use for authentication. If `NULL`, the provider will be
#'   deleted.
#'
#' @examples
#' \dontrun{
#' # Configure providers.
#' configure_provider("anthropic", Sys.getenv("ANTHROPIC_API_KEY"))
#' configure_provider("deepseek", Sys.getenv("DEEPSEEK_API_KEY"))
#' configure_provider("google_gemini", Sys.getenv("GEMINI_API_KEY"))
#' configure_provider("openai", Sys.getenv("OPENAI_API_KEY"))
#' configure_provider("ollama", Sys.getenv("OLLAMA_API_KEY"))
#' # Delete the provider for google_gemini.
#' configure_provider("google_gemini", NULL)
#' }
#'
#' @importFrom ellmer models_anthropic models_google_gemini models_ollama models_openai
#' @importFrom jsonlite fromJSON toJSON
#'
#' @export
#'
configure_provider <- function(name, api_key) {
  if (!name %in% c("anthropic", "deepseek", "google_gemini", "ollama", "openai")) {
    stop('`name` must be one of "anthropic", "deepseek", "google_gemini", "ollama", or "openai".')
  }
  # Load the already configured providers.
  api_keys <- get_config("api_keys")
  if (!is.null(api_keys)) api_keys <- fromJSON(api_keys)
  models <- NULL
  if (is.null(api_key)) {
    # API key to be removed.
    if (name %in% names(api_keys)) {
      api_keys <- api_keys[names(api_keys) != name]
    }
  } else {
    if (name == "anthropic") {
      # Check if the API key works.
      models <- try(models_anthropic(api_key = api_key), silent = TRUE)
    } else if (name == "deepseek") {
      models <- try(models_deepseek(credentials = function() api_key), silent = TRUE)
    } else if (name == "google_gemini") {
      models <- try(models_google_gemini(credentials = function() api_key), silent = TRUE)
    } else if (name == "ollama") {
      models <- try(models_ollama(credentials = function() api_key), silent = TRUE)
    } else if (name == "openai") {
      models <- try(models_openai(credentials = function() api_key), silent = TRUE)
    }
    api_keys[[name]] <- api_key
  }
  if (inherits(models, "try-error")) stop("The provided `api_key` is not working.")
  # Set the new list of providers.
  set_config("api_keys", toJSON(api_keys, auto_unbox = TRUE))
  invisible(api_keys)
}
