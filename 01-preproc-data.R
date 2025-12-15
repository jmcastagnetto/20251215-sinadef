library(tidyverse)

sinadef_raw <- read_csv("orig/SINADEF_DATOS_ABIERTOS.csv.xz")

sinadef_clean <- sinadef_raw %>% 
  janitor::clean_names() %>% 
  mutate(
    across(departamento_fallecimiento:tiempo_edad, factor),
    across(estado_civil:distrito_domicilio, factor),
    across(pais_domicilio:distrito_domicilio, factor),
    across(tipo_lugar:causa_f_ciex, factor),
    edad_años = case_when(
      tiempo_edad == "SEGUNDOS" ~ edad / (365.25 * 24 * 3600),
      tiempo_edad == "MINUTOS" ~ edad / (365.25 * 24 * 60),
      tiempo_edad == "HORAS" ~ edad / (365.25 * 24),
      tiempo_edad == "DIAS" ~ edad / 365.25,
      tiempo_edad == "MESES" ~ edad / 12,
      tiempo_edad == "AÑOS" ~ edad,
      TRUE ~ NA  # 'IGNORADO' y 'SIN REGISTRO'
    )
  )

saveRDS(sinadef_clean, "proc/SINADEF_DATOS_ABIERTOS_clean.rds")

table(sinadef_clean$muerte_violenta, useNA = "ifany")

debido_causa <- bind_rows(
  sinadef_clean %>% 
    select(debido = debido_causa_a, causa = causa_a_ciex),
  sinadef_clean %>% 
    select(debido = debido_causa_b, causa = causa_b_ciex),
  sinadef_clean %>% 
    select(debido = debido_causa_c, causa = causa_c_ciex),
  sinadef_clean %>% 
    select(debido = debido_causa_d, causa = causa_d_ciex),
  sinadef_clean %>% 
    select(debido = debido_causa_e, causa = causa_e_ciex),
  sinadef_clean %>% 
    select(debido = debido_causa_f, causa = causa_f_ciex)
) %>% 
  arrange(debido = causa) %>% 
  distinct()


saveRDS(debido_causa, "proc/sinadef_debido_causa.rds")
write_csv(debido_causa, "proc/sinadef_debido_causa.csv")

violenta <- debido_causa %>% 
  filter(str_detect(debido, "(HOMICI|VIOLEN| PAF| BALA)")) %>% 
  filter(!str_detect(debido, "NO VIOLENTA")) %>% 
  filter(!str_detect(debido, "BALANCE"))

write_csv(violenta, "proc/posible-codigos-muerte-violenta.csv")
