# =============================================================================
# Builds nyc_zones_map.png for EC 325 Concept Check 10: a map of the three
# zones in zone_speeds.csv (CBD, CBD Adjacent, Greater NYC)
#
# Zones are groups of NYC Taxi and Limousine Commission (TLC) taxi zones:
# - CBD: the 38 taxi zones in the MTA's "Central Business District Taxi Zones"
#   dataset (data.ny.gov yfdc-w5jh)
# - CBD Adjacent: the MTA does not publish this list. These 42 zones were read
#   off Figure 1 of the MTA's documentation for the speeds dataset (6p29-6xqn,
#   "MTA_CBDTaxiFHVSpeeds_Overview.pdf"): the figure was aligned to the taxi
#   zone map (it reproduces all 38 CBD zones), and each zone was classified by
#   the color at 60 random points inside it.
# - Greater NYC: every other taxi zone in the five boroughs (Newark Airport,
#   which is a TLC taxi zone, is left out)
# =============================================================================

library(tidyverse)
library(sf)

# TLC taxi zone boundaries
tmp <- tempfile(fileext = ".zip")
download.file("https://d37ci6vzurychx.cloudfront.net/misc/taxi_zones.zip", tmp, mode = "wb")
unzip(tmp, exdir = tempdir())
zones <- st_read(file.path(tempdir(), "taxi_zones", "taxi_zones.shp"), quiet = TRUE) |>
  st_make_valid()

# CBD taxi zones, from the MTA
cbd_ids <- read_csv("https://data.ny.gov/resource/yfdc-w5jh.csv?$select=taxi_zone&$limit=100",
                    show_col_types = FALSE)$taxi_zone
stopifnot(length(cbd_ids) == 38)

adjacent_ids <- c(7, 8, 24, 25, 33, 34, 40, 41, 43, 49, 52, 54, 65, 66, 74, 75,
                  97, 112, 140, 141, 142, 143, 145, 146, 151, 166, 179, 193, 194,
                  195, 202, 217, 223, 226, 236, 237, 238, 239, 255, 256, 262, 263)

zone_labels <- c("CBD (the toll zone): treated", "CBD Adjacent", "Greater NYC: control")

map_data <- zones |>
  filter(borough != "EWR") |>
  mutate(group = case_when(
    LocationID %in% cbd_ids      ~ zone_labels[1],
    LocationID %in% adjacent_ids ~ zone_labels[2],
    TRUE                         ~ zone_labels[3]
  ),
  group = factor(group, levels = zone_labels)) |>
  group_by(group) |>
  summarize(geometry = st_union(geometry), .groups = "drop")

# Close the hairline gaps between neighboring taxi zones (the shapefile is in
# feet): grow each shape by 25 feet, then shrink it back
close_gaps <- function(x) st_buffer(st_buffer(x, 25), -25)
map_data <- close_gaps(map_data)

boroughs <- zones |>
  filter(borough != "EWR") |>
  group_by(borough) |>
  summarize(geometry = st_union(geometry), .groups = "drop") |>
  close_gaps()

# Label positions (longitude, latitude)
labels <- tribble(
  ~label,          ~lon,     ~lat,
  "Manhattan",     -74.040,  40.805,
  "Bronx",         -73.865,  40.850,
  "Queens",        -73.800,  40.705,
  "Brooklyn",      -73.945,  40.630,
  "Staten Island", -74.150,  40.580
) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

p <- ggplot() +
  geom_sf(data = map_data, aes(fill = group), color = NA) +
  geom_sf(data = boroughs, fill = NA, color = "white", linewidth = 0.4) +
  geom_sf_text(data = labels, aes(label = label), size = 3.6, fontface = "bold",
               color = "gray20") +
  annotate("text", x = -74.115, y = 40.715, label = "Toll zone:\nManhattan at and\nbelow 60th Street",
           size = 3.2, hjust = 0.5, color = "gray20") +
  annotate("segment", x = -74.080, xend = -74.003, y = 40.722, yend = 40.735,
           linewidth = 0.4, color = "gray20",
           arrow = arrow(length = unit(0.15, "cm"), type = "closed")) +
  scale_fill_manual(values = c("#E8913A", "#5D6270", "#D9D9D9"), name = NULL) +
  coord_sf(crs = 2263, default_crs = 4326,
           xlim = c(-74.26, -73.69), ylim = c(40.49, 40.92)) +
  theme_void(base_size = 12) +
  theme(legend.position = c(0.80, 0.18),
        legend.key.size = unit(0.5, "cm"),
        legend.text = element_text(size = 10),
        plot.margin = margin(4, 4, 4, 4))

ggsave("data/congestion_pricing/nyc_zones_map.png", p, width = 7, height = 6.5, dpi = 200, bg = "white")
