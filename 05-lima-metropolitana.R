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

lima_metro_poblacion <- readRDS("proc/pob_distritos_2023-2025.rds") %>% 
  filter(
    PROVINCIA %in% c("LIMA", "CALLAO")  # Lima Metropolitana
  ) %>% 
  janitor::clean_names() %>% 
  select(
    anio = year,
    provincia,
    distrito,
    poblacion = total
  )

sinadef_violentas_lima_metropolitana_anual <- sinadef_violentas_lima_metro %>% 
  group_by(anio, provincia, distrito) %>% 
  tally() %>% 
  ungroup() %>% 
  left_join(
    lima_metro_poblacion,
    by = c("anio", "provincia", "distrito")
  ) %>% 
  mutate(
    tasa_100K = n * 100000 / poblacion
  ) %>% 
  rename(año = anio)

write_csv(
  sinadef_violentas_lima_metropolitana_anual,
  "proc/SINADEF_violentas_por_distrito_limametropolitana_2023-2025.csv"
)

plot_rates_limametro <- ggplot(
  sinadef_violentas_lima_metropolitana_anual %>% 
    mutate(prov_dist = glue::glue("{provincia}\n{distrito}")),
  aes(y = as.factor(año), x = tasa_100K)
) +
  geom_point() +
  geom_linerange(aes(xmin = 0, xmax = tasa_100K)) +
  facet_wrap(~prov_dist) +
  theme_bw() +
  labs(
    y = "Año",
    x = "Muertes violentas x 100,000 personas",
    title = "SINADEF: Muertes violentas anuales (2023 - 2025)",
    subtitle = "Fuente: SINADEF (muertes), REUNIS/INEI (población)"
  )

ggsave(
  plot = plot_rates_limametro,
  filename = "plots/muertes_violentas_lima_metropolitana_sinadef_2023-2025.png",
  width = 14,
  height = 10
)

