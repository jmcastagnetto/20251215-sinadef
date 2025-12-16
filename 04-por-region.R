library(tidyverse)

sinadef_violentas <- readRDS("proc/SINADEF_DATOS_ABIERTOS_violentas.rds")
dptos_poblacion <- readRDS("proc/pob_departamentos_2023-2025.rds")

por_dpto <- sinadef_violentas %>% 
  filter(anio >= 2023) %>%   # 2023, 2024, 2025
  group_by(anio, departamento = departamento_fallecimiento) %>% 
  tally() %>% 
  ungroup() %>% 
  left_join(
    dptos_poblacion %>% 
      select(
        anio = year,
        departamento = DEPARTAMENTO,
        poblacion = Total
      ),
    by = c("anio", "departamento")
  ) %>% 
  mutate(
    tasa_100K = n * 100000 / poblacion
  ) %>% 
  rename(
    año = anio
  )

# Conteo y tasa por 100K personas
write_csv(
  por_dpto,
  "proc/SINADEF_violentas_por_departamento_2023-2025.csv"
)

plot_rate <- ggplot(
  por_dpto %>% filter(!is.na(tasa_100K)),
  aes(y = as.factor(año), x = tasa_100K)
) +
  geom_point() +
  geom_linerange(aes(xmin = 0, xmax = tasa_100K)) +
  facet_wrap(~departamento) +
  theme_bw() +
  labs(
    y = "Año",
    x = "Muertes violentas x 100,000 personas",
    title = "SINADEF: Muertes violentas anuales (2023 - 2025)",
    subtitle = "Fuente: SINADEF (muertes), REUNIS/INEI (población)"
  )

ggsave(
  plot = plot_rate,
  filename = "plots/muertes_violentas_por_departamento_sinadef_2023-2025.png",
  width = 10,
  height = 10
)
