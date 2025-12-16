library(tidyverse)

sinadef_violentas_lima_metro <- readRDS(
  "proc/SINADEF_DATOS_ABIERTOS_violentas.rds"
) %>% 
  filter(
    provincia_fallecimiento %in% c("LIMA", "CALLAO") &
      anio >= 2023  # 2023 - 2025
  ) %>% 
  rename(
    departamento = departamento_fallecimiento,
    provincia = provincia_fallecimiento,
    distrito = distrito_fallecimiento
  ) %>% 
  mutate(
    distrito = str_replace(distrito, "-", " ")
  )

lima_metro_epiyear_epiweek <- sinadef_violentas_lima_metro %>% 
  mutate(
    epi_year = epiyear(fecha),
    epi_week = epiweek(fecha)
  ) %>% 
  group_by(
    epi_year,
    provincia,
    distrito,
    epi_week
  ) %>% 
  tally() %>% 
  ungroup() 

write_csv(
  lima_metro_epiyear_epiweek,
  "proc/SINADEF_violentas_limametro_epiyear_epiweek_2023-2025.csv"
)


lima_metro_year_month <- sinadef_violentas_lima_metro %>% 
  group_by(
    provincia,
    distrito,
    anio,
    mes
  ) %>% 
  tally() %>% 
  ungroup()

write_csv(
  lima_metro_year_month,
  "proc/SINADEF_violentas_limametro_year_month_2023-2025.csv"
)


lima_metro_year_month_wide <- lima_metro_year_month %>% 
  mutate(
    yrmn = sprintf("%4d/%02d", anio, mes)
  ) %>% 
  arrange(yrmn) %>% 
  select(
    provincia,
    distrito,
    n,
    anio,
    yrmn
  ) %>% 
  pivot_wider(
    names_from = yrmn,
    values_from = n
  )

write_csv(
  lima_metro_year_month_wide,
  "proc/SINADEF_violentas_limametro_year_month_wide_2023-2025.csv"
)


# quick cummulative trend
cummulative_data <- lima_metro_year_month %>% 
  group_by(anio, distrito) %>% 
  mutate(
    first_day = as.Date(sprintf("%4d/%02d/01", anio, mes)),
    n_cumulative = cumsum(n)
  )

cumulative_plot <- ggplot(
  cummulative_data,
  aes(x = first_day, y = n_cumulative, group = anio)
) +
  geom_line() +
  facet_wrap(~provincia + distrito) +
  theme_bw() +
  labs(
    title = "Muertes violentas acumuladas por distrito de Lima Metropolitana (2023-2025)"
  )

ggsave(
  plot = cumulative_plot,
  filename = "plots/muertes_violentas_lima_metropolitana_cumulative_año_mes_2023-2025.png",
  width = 14,
  height = 12
)
