box::use(./obs)

obs$new_obs(
    .dt = "2022-09-23 22:00:00 PDT",
    .duration = "6H",
    .nick = "calstar",
    .seeing = "VG",
    .trans = 6,
    .notes = "1st night at 2022 Calstar"
)

obs$new_obs(
    .dt = "2022-09-24 22:00:00 PDT",
    .duration = "7H",
    .nick = "calstar",
    .seeing = "VG",
    .trans = 6,
    .notes = "2nd night at 2022 Calstar"
)

obs$new_obs(
    .dt = "2022-09-03 22:00:00 PDT",
    .duration = "2H",
    .location = "Pine Mountain Club",
    .lat = 34.836761,
    .long = -119.150865,
    .sqm = 20.5,
    .notes = "Casual observations with the family using the ED80"
)

obs$new_obs(
    .dt = "2022-07-10 21:55:00 PDT",
    .duration = "1H",
    .nick = "home",
    .notes = "Constellation work"
)

obs$new_obs(
    .dt = "2022-07-12 22:45:00 PDT",
    .duration = "1H",
    .nick = "home",
    .notes = "Constellation work"
)

obs$new_obs(
    .dt = "2022-07-16 21:55:00 PDT",
    .duration = "5H",
    .nick = "monte",
    .seeing = "G",
    .trans = 6,
    .notes = "Constellation work. JWST Challenge."
)

obs$new_obs(
    .dt = "2022-08-06 20:00:00 PDT",
    .duration = "5H",
    .nick = "coyote",
    .notes = "Gibbous Moon. Constellation work."
)


obs$new_obs(
    .dt = "2022-07-18 21:22:00 PDT",
    .duration = "4H",
    .nick = "rcdo",
    .seeing = "VG",
    .trans = 6,
    .notes = "AL Globular Cluster Challenge work. ~15 objects"
)


obs$new_obs(
    .dt = "2022-10-06 19:00:00 PDT",
    .duration = "3H",
    .seeing = "VG",
    .trans = 3,
    .location = "Stevens Creek Elementary School",
    .lat = 37.328276,
    .long = -122.063239,
    .notes = "2022 Int'l Moon Obs Day. Moon, Jupiter  Saturn"
)


obs$new_obs(
    .dt = "2022-10-07 19:00:00 PDT",
    .duration = "3H",
    .seeing = "G",
    .trans = 3,
    .location = "Cadwallader Elementary School",
    .lat = 37.306577,
    .long = -121.788782,
    .notes = "2022 Int'l Moon Obs Day. Moon, Jupiter  Saturn"
)
