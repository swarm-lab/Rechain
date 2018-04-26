observe({
  if (!is.null(input$the_frame_click)) {
    isolate({
      if (input$the_action == "add") {
        if (nrow(the_dat) == 0) {
          tmp <- tibble(chain = 1,
                        id = 1,
                        end = "head",
                        frame = input$the_frame_slider,
                        x = input$the_frame_click$x,
                        y = input$the_frame_click$y,
                        mod = FALSE)
          the_dat <<- bind_rows(the_dat, tmp)
        } else {
          current <- filter(the_dat, chain == max(the_dat$chain))$chain
          tmp <- tibble(chain = if_else(length(current) == 1,
                                        current[1],
                                        current[1] + 1L),
                        id = max(the_dat$id) + 1L,
                        end = if_else(length(current) == 1,
                                     "tail",
                                     "head"),
                        frame = input$the_frame_slider,
                        x = input$the_frame_click$x,
                        y = input$the_frame_click$y,
                        mod = FALSE)
          the_dat <<- bind_rows(the_dat, tmp)
        }
      } else if (input$the_action == "mod") {
        if (any(the_dat$mod)) {
          the_dat[the_dat$mod, ]$x <<- input$the_frame_click$x
          the_dat[the_dat$mod, ]$y <<- input$the_frame_click$y
          the_dat[the_dat$mod, ]$mod <<- FALSE
        } else {
          tmp <- filter(the_dat, frame <= input$the_frame_slider) %>%
            group_by(id) %>%
            filter(frame == max(frame)) %>%
            ungroup() %>%
            mutate(d = (input$the_frame_click$x - x) ^ 2 + (input$the_frame_click$y - y) ^ 2) %>%
            filter(d == min(d, na.rm = TRUE))

          if (tmp$frame == input$the_frame_slider) {
            the_dat[the_dat$id == tmp$id & the_dat$frame == tmp$frame, ]$mod <<- TRUE

          } else {
            the_dat <<- tmp %>%
              mutate(frame = input$the_frame_slider,
                     mod = TRUE) %>%
              select(-d) %>%
              bind_rows(the_dat, .)
          }
        }
      } else if (input$the_action == "rmv") {
        tmp1 <- filter(the_dat, frame <= input$the_frame_slider) %>%
          group_by(id) %>%
          filter(frame == max(frame)) %>%
          ungroup() %>%
          mutate(d = (input$the_frame_click$x - x) ^ 2 + (input$the_frame_click$y - y) ^ 2) %>%
          filter(d == min(d, na.rm = TRUE))

        tmp2 <- filter(the_dat, chain == tmp1$chain, frame <= input$the_frame_slider) %>%
          group_by(id) %>%
          filter(frame == max(frame)) %>%
          mutate(x = NA, y = NA, frame = input$the_frame_slider)

        the_dat <<- the_dat %>%
          filter(!(chain == tmp1$chain & frame >= input$the_frame_slider)) %>%
          bind_rows(tmp2)
      }

      react$update_plot <- react$update_plot + 1
    })
  }
})
