# =============================================================================
# IPC infrastructure — file-based communication between the background Shiny
# process and the main R session that owns the rstudioapi.
# =============================================================================

# --- Path helpers ------------------------------------------------------------

#' @keywords internal
ipc_dir <- function() {
  env <- Sys.getenv("MYOWNROBS_IPC_DIR", unset = "")
  if (nzchar(env)) return(env)
  d <- file.path(tempdir(), "myownrobs_ipc")
  dir.create(d, showWarnings = FALSE)
  d
}

#' @keywords internal
ipc_request_path <- function() file.path(ipc_dir(), "request.json")

#' @keywords internal
ipc_response_path <- function() file.path(ipc_dir(), "response.json")

#' @keywords internal
ipc_url_path <- function() file.path(ipc_dir(), "myownrobs_url.txt")

# --- Background process: call main session via IPC ---------------------------

#' Send an IPC request and wait for the response (called from background process)
#'
#' @importFrom jsonlite write_json read_json
#'
#' @keywords internal
ipc_call <- function(action, params = list()) {
  req_path <- ipc_request_path()
  resp_path <- ipc_response_path()

  jsonlite::write_json(list(action = action, params = params), req_path, auto_unbox = TRUE)

  deadline <- Sys.time() + 5
  while (Sys.time() < deadline) {
    if (file.exists(resp_path)) {
      result <- jsonlite::read_json(resp_path, simplifyVector = FALSE)
      file.remove(resp_path)
      if (!is.null(result$error)) stop(result$error)
      return(result$value)
    }
    Sys.sleep(0.05)
  }
  stop("IPC timeout waiting for: ", action)
}

# --- Main session: IPC polling loop ------------------------------------------

#' Start polling for IPC requests from the background process.
#' Runs in the main R session via later::later so the console stays free.
#'
#' @importFrom later later
#' @importFrom jsonlite read_json write_json
#' @importFrom rstudioapi getSourceEditorContext getActiveProject getThemeInfo documentOpen insertText
#'
#' @keywords internal
start_ipc_listener <- function() {
  poll <- function() {
    req_path <- ipc_request_path()
    resp_path <- ipc_response_path()

    if (file.exists(req_path)) {
      tryCatch({
        req <- jsonlite::read_json(req_path, simplifyVector = TRUE)
        file.remove(req_path)
        p <- req$params

        value <- switch(req$action,
          "getSourceEditorContext" = {
            ctx <- rstudioapi::getSourceEditorContext()
            list(
              id = ctx$id,
              path = ctx$path,
              contents = as.list(ctx$contents),
              selection = lapply(ctx$selection, function(s) list(
                range = list(
                  start = list(row = s$range$start[[1]], column = s$range$start[[2]]),
                  end   = list(row = s$range$end[[1]],   column = s$range$end[[2]])
                ),
                text = s$text
              ))
            )
          },
          "getActiveProject" = rstudioapi::getActiveProject(),
          "getThemeInfo" = {
            t <- rstudioapi::getThemeInfo()
            list(
              editor = t$editor,
              global = t$global,
              dark = t$dark,
              foreground = t$foreground,
              background = t$background
            )
          },
          "documentOpen" = {
            rstudioapi::documentOpen(p$path)
            NULL
          },
          "insertText" = {
            rstudioapi::insertText(p$location, p$text, p$id)
            NULL
          },
          stop("Unknown IPC action: ", req$action)
        )

        jsonlite::write_json(
          list(value = value),
          resp_path,
          auto_unbox = TRUE,
          null = "null"
        )
      }, error = function(e) {
        jsonlite::write_json(list(error = e$message), resp_path, auto_unbox = TRUE)
      })
    }

    later::later(poll, delay = 0.2)
  }

  later::later(poll, delay = 0.2)
  invisible(NULL)
}
