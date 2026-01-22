#' Validate MyOwnRobs Credentials
#'
#' @keywords internal
#'
validate_credentials <- function() {
  if (isTRUE(length(get_api_key()) == 0)) {
    stop("Please, configure at least one provider with `myownrobs::configure_provider()`.")
  }
}
