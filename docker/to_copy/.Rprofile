# Setup a better R prompt. With continue as spaces instead of the default '+',
# it's much quicker to copy previous commands from the console back into source files
options(prompt = "> ", continue = "  ")

## .First() run at the start of every R session.
.set.width <- function(width=NULL) {
  if(is.null(width)) {
    cols <- as.integer(system("stty -a | head -n 1 | awk '{print $6}'", intern=T))
    if(length(cols) == 0) {
      cols = 200
    } else {
      if (is.na(cols) || cols > 10000 || cols < 10) cols=200
    }
    options(width=cols)
    options(list(dplyr.print_min = 40,
      dplyr.width = cols))

  } else {
    options(width=width)
    options(list(dplyr.print_min = 40,
      dplyr.width = width))
  }
}

# Custom welcome and quit messages
.First <- function(){
    message("You are currently working in ", getwd())

    # additional display options
    options(
      dplyr.print_max = 100,
      scipen=99,
      digits=8,
      menu.graphics = FALSE
    )

    try(.set.width())
}
