#' Add a Provider to be Used
#'
#' Set API keys for running models locally.
#'
#' @param name Name of the provider (one of "anthropic", "deepseek", "google_gemini", "ollama",
#'   "openai" or "openai_compatible").
#' @param api_key The provider's API key to use for authentication. For "openai_compatible",
#'   provide a list with elements `api_key` and `base_url`. If `NULL`, the provider will be
#'   deleted.
#'
#' @examples
#' \dontrun{
#' # Configure providers.
#' configure_provider("anthropic", Sys.getenv("ANTHROPIC_API_KEY"))
#' configure_provider("deepseek", Sys.getenv("DEEPSEEK_API_KEY"))
#' configure_provider("google_gemini", Sys.getenv("GEMINI_API_KEY"))
#' configure_provider("openai", Sys.getenv("OPENAI_API_KEY"))
#' configure_provider("openai_compatible", list(api_key = Sys.getenv("OPENAI_COMPATIBLE_API_KEY"),
#'                                              base_url = Sys.getenv("OPENAI_COMPATIBLE_BASE_URL")))
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
  if (!name %in% c("anthropic", "deepseek", "google_gemini", "ollama", "openai", "openai_compatible")) {
    stop('`name` must be one of "anthropic", "deepseek", "google_gemini", "ollama", "openai", or "openai_compatible".')
  }
  if (name == "openai_compatible" && (!is.list(api_key) || is.null(api_key$api_key) || is.null(api_key$base_url)) ) {
    stop('For "openai_compatible", `api_key` must be a list with elements `api_key` and `base_url`.')
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
    } else if (name == "openai_compatible") {
      models <- try(models_openai(base_url = api_key$base_url,
                                  credentials = function() api_key$api_key), silent = TRUE)
    }
    api_keys[[name]] <- api_key
  }
  if (inherits(models, "try-error")) stop("The provided `api_key` is not working.")
  # Set the new list of providers.
  set_config("api_keys", toJSON(api_keys, auto_unbox = TRUE))
  invisible(api_keys)
}
