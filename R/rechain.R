#' @export
#'
rechain <- function(...) {
  shiny::runApp(appDir = system.file("app", package = "Rechain"), ...)
}
