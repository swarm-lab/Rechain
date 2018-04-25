observe({
  if (!is.null(react$the_video) & !is.null(input$the_frame_slider)) {
    isolate({
      react$the_frame <- readFrame(react$the_video, input$the_frame_slider)
    })
  }
})

observeEvent(input$the_frame_brush, {
  isolate({
    brush <- input$the_frame_brush
    if (!is.null(brush)) {
      react$the_range$x <- c(brush$xmin, brush$xmax)
      react$the_range$y <- c(brush$ymin, brush$ymax)
      react$the_range$zoom <- TRUE
    }
  })
})

output$the_unzoom_button <- renderUI({
  if (react$the_range$zoom) {
    actionButton("the_unzoom", "Unzoom")
  }
})

observe({
  if (!is.null(input$the_unzoom) && (input$the_unzoom > 0)) {
    isolate({
      react$the_range$x <- NULL
      react$the_range$y <- NULL
      react$the_range$zoom <- FALSE
    })
  }
})

output$the_timer <- renderText({
  if (!is.null(react$the_video) & !is.null(input$the_frame_slider)) {
    the_time <- input$the_frame_slider / fps(react$the_video)
    the_floor_time <- floor(the_time)
    the_img <- round(fps(react$the_video) * (the_time - the_floor_time))
    the_period <- seconds_to_period(the_floor_time)
    the_second <- sprintf("%02d", second(the_period))
    the_minute <- sprintf("%02d", minute(the_period))
    the_hour <- sprintf("%02d", hour(the_period))

    paste0(the_hour, ":", the_minute, ":", the_second, ".", the_img)
  }
})

output$the_frame <- renderPlot({
  if (!is.null(react$the_frame) & (react$update_plot > 0)) {
    plot(react$the_frame, xlim = react$the_range$x, ylim = react$the_range$y)

    if (nrow(the_dat) > 0) {
      tmp <- filter(the_dat, frame <= input$the_frame_slider) %>%
        group_by(id) %>%
        filter(frame == max(frame)) %>%
        ungroup()

      tmp %>%
        group_by(chain) %>%
        do(tmp = lines(y ~ x, data = ., col = "white", lwd = 2))

      points(y ~ x, data = tmp, col = "white", bg = ifelse(tmp$mod, "green", "red"),
             cex = 2, lwd = 2, pch = ifelse(tmp$end == "head", 21, 23))

      tmp <- tmp %>%
        group_by(chain) %>%
        filter(n() > 1) %>%
        summarize(x = mean(x), y = mean(y)) %>%
        group_by(chain) %>%
        do(tmp = ifelse(nrow(.) == 0, NA, legend(.$x, .$y, .$chain,
                                                 box.col = "white", bg = "white",
                                                 xjust = 0.5, yjust = 0.5,
                                                 x.intersp = -0.5, y.intersp = -0.5)))
    }
  }
})



