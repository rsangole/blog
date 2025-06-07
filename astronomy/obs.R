#' @export
get_locs <- function(locfile = "astronomy/locs.json") {
    jsonlite::fromJSON(locfile) |>
        tibble::as_tibble()
}

#' @export
new_obs <- function(.dt = Sys.time(),
                    .duration = NULL,
                    .nick = NULL,
                    .location = NULL,
                    .lat = NULL,
                    .long = NULL,
                    .sqm = NULL,
                    .trans = NULL,
                    .seeing = NULL,
                    .notes = NULL) {
    con <- file("astronomy/obs.json", "a+")
    on.exit(close(con))

    if (!is.null(.nick)) {
        locs <- get_locs() |>
            dplyr::filter(nick == .nick)
        stopifnot(nrow(locs) != 0)
        .lat <- locs$lat
        .long <- locs$long
        .location <- locs$name
    }

    list(
        dt = .dt,
        duration = .duration,
        location = .location,
        lat = .lat,
        long = .long,
        sqm = .sqm,
        trans = .trans,
        seeing = .seeing,
        notes = .notes
    ) |>
        jsonlite::write_json(
            POSIXt = "ISO8601",
            auto_unbox = TRUE,
            null = "null",
            pretty = FALSE,
            con
        )
}

#' @export
read_obs <- function(obsfile = "astronomy/obs.json") {
    con <- file(obsfile, "r")
    on.exit(close(con))

    jsonlite::stream_in(con = con, verbose = FALSE) |>
                         tibble::as_tibble()
}

#' @export
plot_cal <- function(dat) {
    dat <- dat |>
        dplyr::mutate(dt = lubridate::as_date(dt))
    start_date <- lubridate::round_date(min(dat$dt), unit = "month")
    sdays <- as.numeric(dat$dt - start_date) + 1
    calendR::calendR(
        year = 2022,
        title = NULL,
        from = start_date,
        to = as.Date("2022-12-31"),
        start = "M",
        special.days = sdays,
        special.col = "lightblue",
        days.col = "gray30",
        weeknames.col = "gray30",
        months.col = "gray30",
        lwd = 0,
        col = "#fcfcfc",
        low.col = "#fcfcfc",
        bg.col = "#fcfcfc",
        mbg.col = "#fcfcfc",
        weeknames = c('M', 'T', 'W', 'T', 'F', 'S', 'S')
    )
}

#' @export
plot_tile <- function(dat) {
    box::use(ggplot2[...])
    box::use(dplyr[...])
    box::use(timetk[pad_by_time])
    box::use(lubridate[floor_date, wday])
    box::use(lunar[lunar.illumination])

    by_day <- dat |>
        mutate(dt = lubridate::as_date(dt)) |>
        mutate(obs = TRUE) |>
        pad_by_time(dt,
                            .by = "day",
                            .start_date = "2022-01-01",
                            .end_date = "2022-12-31") |>
        mutate(wday = wday(dt, label = TRUE, week_start = 1)) |>
        mutate(
            phase = round(lunar.illumination(dt), 2),
            nomoon = phase == 0,
            fullmoon = phase == 1,
            week = floor_date(dt, "week"),
            month = floor_date(dt, "month"),
            obs_label = case_when(
                nomoon == TRUE ~ 'No Moon',
                fullmoon == TRUE ~ 'Full Moon',
                obs == TRUE ~ 'Observations',
                TRUE ~ ""
            )
        )

    month_breaks = seq(as.Date("2022-01-01", ), as.Date("2022-12-31"), by = "month")
    month_labels = strftime(month_breaks, format = "%b")
    by_day |>
        filter(obs_label != "") |>
        ggplot(aes(week, wday)) +
        geom_tile(aes(fill = obs_label),
                  linejoin = "round",
                  width = 6.8, height = .96) +
        labs(x = NULL, y = NULL) +
        # coord_fixed(ratio = 4) +
        scale_x_date(
            expand = c(0, 0),
            breaks = seq(as.Date("2022-01-01", ), as.Date("2022-12-31"), by = "month"),
            labels = month_labels,
            position = "top"
        ) +
        scale_fill_manual(values = c("#e3f2fd", "#1565c0", "#f6aa1c")) +
        theme_minimal() +
        theme(
            panel.background = element_rect(fill = 'white', color = 'white'),
            panel.grid = element_blank(),
            legend.title = element_blank()
            # legend.position = "bottom"
        )
}

#' @export
plot_moons <- function(dat) {
    box::use(ggplot2[...])
    box::use(dplyr[...])
    box::use(timetk[pad_by_time])
    box::use(lubridate[floor_date, wday])
    box::use(lunar[lunar.illumination, lunar.phase])
    box::use(data.table[rleid])

    by_day <- dat |>
        mutate(dt = lubridate::as_date(dt)) |>
        mutate(obs = TRUE) |>
        pad_by_time(dt,
                    .by = "day",
                    .start_date = "2022-01-01",
                    .end_date = "2022-12-31") |>
        mutate(wday = wday(dt, label = TRUE, week_start = 1)) |>
        mutate(
            week = floor_date(dt, "week"),
            month = floor_date(dt, "month"),
            phase = lunar.phase(dt, name = TRUE),
            illum = lunar.illumination(dt),
            phase_id = rleid(phase)
        )

    fullmoons <- by_day |>
        filter(phase == "Full") |>
        group_by(phase_id) |>
        slice_max(illum)
    nomoons <- by_day |>
        filter(phase == "New") |>
        group_by(phase_id) |>
        slice_min(illum)

    by_day <- by_day |>
        mutate(
            fullmoon = dt %in% fullmoons$dt,
            nomoon = dt %in% nomoons$dt,
            obs_label = case_when(
                nomoon == TRUE ~ 'No Moon',
                fullmoon == TRUE ~ 'Full Moon',
                obs == TRUE ~ 'Observations',
                TRUE ~ "na"
            )
        )

    month_breaks = seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "month")
    month_labels = strftime(month_breaks, format = "%b")

    vlines <- by_day |>
        select(week) |>
        unique() |>
        mutate(month = lubridate::month(week, label = TRUE)) |>
        group_by(month) |>
        slice_tail(n = 1)

    by_day |>
        ggplot(aes(week, forcats::fct_rev(wday))) +
        geom_vline(# data = vlines,
            xintercept = vlines$week,
            color = "gray90") +
        geom_point(aes(
            size = obs_label,
            shape = obs_label,
            fill = obs_label,
            color = obs_label
        )) +
        scale_color_manual(
            breaks = c("Full Moon",
                       "No Moon",
                       "Observations"),
            values = c(
                "Full Moon" = "black",
                "No Moon" = "black",
                "Observations" = "orange",
                "na" = NA
            )
        ) +
        scale_fill_manual(
            breaks = c("Full Moon",
                       "No Moon",
                       "Observations"),
            values = c(
                "Full Moon" = "white",
                "No Moon" = "gray30",
                "Observations" = NA,
                "na" = NA
            )
        ) +
        scale_shape_manual(
            breaks = c("Full Moon",
                       "No Moon",
                       "Observations"),
            values = c(
                "Full Moon" = 21,
                "No Moon" = 21,
                "Observations" = 13,
                "na" = NA
            )
        ) +
        scale_size_manual(
            values = c(
                "Full Moon" = 4,
                "No Moon" = 4,
                "Observations" = 4,
                "na" = NA
            ),
            guide = "none"
        ) +
        guides(shape = guide_legend(override.aes = list(size = 4))) +
        theme_minimal() +
        theme(
            panel.background = element_rect(fill = 'white', color = 'white'),
            panel.grid = element_blank(),
            legend.title = element_blank()
            # legend.position = "bottom"
        ) +
        labs(x = NULL, y = NULL) +
        scale_x_date(
            expand = c(0, 0),
            breaks = month_breaks,
            labels = month_labels,
            position = "top"
        )
}

read_obs() |> plot_cal()
read_obs() |> plot_tile()
read_obs() |> plot_moons()
