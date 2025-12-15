library(tidyverse)
library(readxl)

# 2023
dptos_2023 <- read_excel(
  "orig/Poblacion Peru 2023 Dpto Prov Dist sexo-15.03.23.xlsx",
  sheet = "DEPARTAMENTAL",
  range = "A7:C33"
) %>% 
  add_column(year = 2023)

provs_2023 <- read_excel(
  "orig/Poblacion Peru 2023 Dpto Prov Dist sexo-15.03.23.xlsx",
  sheet = "PROVINCIAL",
  range = "A7:E204"
) %>% 
  add_column(year = 2023)

dists_2023 <- read_excel(
  "orig/Poblacion Peru 2023 Dpto Prov Dist sexo-15.03.23.xlsx",
  sheet = "DISTRITAL",
  range = "A7:F1898"
) %>% 
  add_column(year = 2023)

# 2024
dptos_2024 <- read_excel(
  "orig/Poblacion Peru 2024 Dpto Prov Dist sexo-08.01.24.xlsx",
  sheet = "DEPARTAMENTAL",
  range = "A7:C33"
) %>% 
  add_column(year = 2024)

provs_2024 <- read_excel(
  "orig/Poblacion Peru 2024 Dpto Prov Dist sexo-08.01.24.xlsx",
  sheet = "PROVINCIAL",
  range = "A7:E204"
) %>% 
  add_column(year = 2024)

dists_2024 <- read_excel(
  "orig/Poblacion Peru 2024 Dpto Prov Dist sexo-08.01.24.xlsx",
  sheet = "DISTRITAL",
  range = "A7:F1899"
) %>% 
  add_column(year = 2024)


# 2025
dptos_2025 <- read_excel(
  "orig/Poblacion Peru 2025 Dpto Prov Dist sexo-20-01-25.xlsx",
  sheet = "DEPARTAMENTAL",
  range = "A7:C33"
) %>% 
  add_column(year = 2025)

provs_2025 <- read_excel(
  "orig/Poblacion Peru 2025 Dpto Prov Dist sexo-20-01-25.xlsx",
  sheet = "PROVINCIAL",
  range = "A7:E204"
) %>% 
  add_column(year = 2025)

dists_2025 <- read_excel(
  "orig/Poblacion Peru 2025 Dpto Prov Dist sexo-20-01-25.xlsx",
  sheet = "DISTRITAL",
  range = "A7:F1899"
) %>% 
  add_column(year = 2025)

# 2023 - 2025

departamentos <- bind_rows(
  dptos_2023,
  dptos_2024,
  dptos_2025
) %>% 
  relocate(
    year,
    .before = 1
  )
saveRDS(
  departamentos,
  "proc/pob_departamentos_2023-2025.rds"
)

provincias <- bind_rows(
  provs_2023,
  provs_2024,
  provs_2025
) %>% 
  relocate(
    year,
    .before = 1
  )
saveRDS(
  provincias,
  "proc/pob_provincias_2023-2025.rds"
)

distritos <- bind_rows(
  dists_2023,
  dists_2024,
  dists_2025
) %>% 
  relocate(
    year,
    .before = 1
  )
saveRDS(
  distritos,
  "proc/pob_distritos_2023-2025.rds"
)
