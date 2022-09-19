box::use(./obs)

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