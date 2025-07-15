# see `?aspell` and `?aspell-utils` for help
# run below function to update aspell dictionary
# saveRDS(
#   c("Kremer", "et", "al", "Kucharski", "Lloyd", "Smith"),
#   file = ".aspell/superspreading.rds",
#   version = 2
# )
description <- list(
  encoding = "UTF-8",
  language = "en",
  dictionaries = c("en_stats", "superspreading")
)
