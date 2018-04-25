output$the_frame_slider <- renderUI({
  if (!is.null(react$the_video) & !is.null(input$the_framerate)) {
    sliderInput("the_frame_slider", NULL, min = 1, max = nframes(react$the_video),
                value = 1, ticks = FALSE, step = input$the_framerate)
  } else {
    sliderInput("the_frame_slider", NULL, min = 1, max = 1,
                value = 1, ticks = FALSE, step = 1)
  }
})

observe({
  if (!is.null(input$the_previous_frame)) {
    isolate({
      updateSliderInput(session, "the_frame_slider",
                        value = input$the_frame_slider - input$the_framerate)
    })
  }
})

observe({
  if (!is.null(input$the_next_frame)) {
    isolate({
      updateSliderInput(session, "the_frame_slider",
                        value = input$the_frame_slider + input$the_framerate)
    })
  }
})
