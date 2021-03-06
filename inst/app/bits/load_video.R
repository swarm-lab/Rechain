shinyFileChoose(input, "the_video", session = session,
                roots = c(wd = normalizePath(ifelse(.Platform$OS.type == "unix", "~/", "~/.."))))

observeEvent(input$the_video, {
  path <- parseFilePaths(roots = c(wd = normalizePath(ifelse(.Platform$OS.type == "unix",
                                                             "~/", "~/.."))), input$the_video)

  if (nrow(path) > 0) {
    if (file.exists(paste0(as.character(path$datapath), ".csv"))) {
      the_dat <<- suppressMessages(read_csv(paste0(as.character(path$datapath), ".csv")))
      updateSliderInput(session, "the_frame_slider", value = max(the_dat$frame, na.rm = TRUE))
    }

    react$the_video <- video(as.character(path$datapath))
    react$update_plot <- react$update_plot + 1
  }
})
