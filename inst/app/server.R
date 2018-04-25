the_dat <- tibble(chain = integer(0), id = integer(0), end = character(0),
                  frame = integer(0), x = numeric(0), y = numeric(0),
                  mod = logical(0))

shinyServer(function(input, output, session) {

  # Initialize reactive container
  react <- reactiveValues(the_range = list(x = NULL, y = NULL, zoom = FALSE),
                          update_plot = 0,
                          the_success = 0)

  # Choose and load video
  source("bits/load_video.R", local = TRUE)

  # Render frame slider
  source("bits/frame_slider.R", local = TRUE)

  # Render plot output
  source("bits/plot.R", local = TRUE)

  # Add, remove, modify
  source("bits/add_remove_mod.R", local = TRUE)

  # Save data
  source("bits/save.R", local = TRUE)
})
