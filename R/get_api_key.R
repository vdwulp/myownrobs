#' Get API Key
#'
#' Retrieves the configured AI provider API keys from the user's configuration directory.
#'
#' @importFrom jsonlite fromJSON
#'
#' @keywords internal
#'
get_api_key <- function() {
  api_keys <- get_config("api_keys")
  if (!is.null(api_keys)) {
    api_keys <- fromJSON(api_keys)
    api_keys <- api_keys[order(names(api_keys))]
  }
  api_keys
}
