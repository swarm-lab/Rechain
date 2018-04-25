observe({
  if (input$the_save > 0) {
    path <- parseFilePaths(roots = c(wd = normalizePath(ifelse(.Platform$OS.type == "unix", "~/", "~/.."))),
                           input$the_video)
    the_dat %>%
      arrange(chain, id, frame) %>%
      write_csv(paste0(as.character(path$datapath), ".csv"))

    isolate({
      react$the_success <- react$the_success + 1
    })
  }
})

output$the_confirmation <- renderText({
  if (react$the_success > 0) {
    invalidateLater(1000, session)
    the_last_success <<- react$the_success
    "Success!"
  } else {
    ""
  }
})
