library(tidyverse)

causas_violentas <- read_csv("proc/posible-codigos-muerte-violenta.csv") %>% 
  pull(debido)

sinadef_violentas <- readRDS("proc/SINADEF_DATOS_ABIERTOS_clean.rds") %>% 
  filter(
    (debido_causa_a %in% causas_violentas) |
      (debido_causa_b %in% causas_violentas) |
      (debido_causa_c %in% causas_violentas) |
      (debido_causa_d %in% causas_violentas) |
      (debido_causa_e %in% causas_violentas) |
      (debido_causa_f %in% causas_violentas)
  )

saveRDS(sinadef_violentas, "proc/SINADEF_DATOS_ABIERTOS_violentas.rds")

# Nacionales
table(sinadef_violentas$anio)

# Por año y semana epi
sinadef_violentas %>% 
  mutate(
    epiweek = epiweek(fecha),
    epiyear = epiyear(fecha)
  ) %>% 
  group_by(
    epiyear, epiweek
  ) %>% 
  tally() %>% 
  ggplot(
    aes(x = epiweek,
        y = n)
  ) +
  geom_line() +
  theme_minimal() +
  facet_wrap(
    ~epiyear
  )

# Para el 2025, por departamento
sinadef_violentas %>% 
  filter(anio == 2025) %>% 
  mutate(
    epiweek = epiweek(fecha),
    epiyear = epiyear(fecha)
  ) %>% 
  group_by(
    departamento_fallecimiento, epiweek
  ) %>% 
  tally() %>% 
  ggplot(
    aes(x = epiweek,
        y = n)
  ) +
  geom_col() +
  theme_bw() +
  facet_wrap(
    ~departamento_fallecimiento
  )

# Para el 2024, por departamento
sinadef_violentas %>% 
  filter(anio == 2024) %>% 
  mutate(
    epiweek = epiweek(fecha),
    epiyear = epiyear(fecha)
  ) %>% 
  group_by(
    departamento_fallecimiento, epiweek
  ) %>% 
  tally() %>% 
  ggplot(
    aes(x = epiweek,
        y = n)
  ) +
  geom_col() +
  theme_bw() +
  facet_wrap(
    ~departamento_fallecimiento
  )

# Para el 2023-2025, por provincia en Lima
sinadef_violentas %>% 
  filter(anio >= 2023 & departamento_fallecimiento == "LIMA") %>% 
  mutate(
    epiweek = epiweek(fecha),
    epiyear = epiyear(fecha)
  ) %>% 
  group_by(
    anio, provincia_fallecimiento, epiweek
  ) %>% 
  tally() %>% 
  ggplot(
    aes(x = epiweek,
        y = n)
  ) +
  geom_col() +
  theme_bw() +
  facet_grid(
    anio~provincia_fallecimiento
  )
