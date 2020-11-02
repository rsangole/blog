options(prompt = "> ", continue = "  ")

.First <- function(){
    message("You are currently working in ", getwd())

    # additional display options
    options(
        dplyr.print_max = 100,
        scipen=99,
        digits=8,
        menu.graphics = FALSE
    )

    r <- getOption("repos")
    r["MRAN"] <- "https://mran.microsoft.com/snapshot/2020-09-01"
    r <- r["MRAN"]
    options(repos = r)

}
