#' @importFrom fs dir_ls
file_glob_search <- function(pattern) {
  matched_files <- dir_ls(ipc_call("getActiveProject"), glob = pattern, recurse = TRUE, type = "file")
  matches <- paste(matched_files, collapse = "\n")
  list(output = matches)
}

#' @importFrom ellmer tool type_string
ai_tool_file_glob_search <- tool(
  file_glob_search,
  name = "FileGlobSearch",
  description = paste0(
    "Search for files recursively in the project using glob patterns. Supports ** for recursive ",
    "directory search. Output may be truncated; use targeted patterns."
  ),
  arguments = list(
    pattern = type_string("Glob pattern for file path matching.")
  )
)
