prepare_possession_data <- function(cleaned_team_possession) {
  possession_data <- cleaned_team_possession
  
  # Convertimos las columnas a formato numérico para evitar problemas de tipo de datos
  possession_data$def_pen <- as.numeric(as.character(possession_data$def_pen))
  possession_data$def_3rd <- as.numeric(as.character(possession_data$def_3rd))
  possession_data$mid_3rd <- as.numeric(as.character(possession_data$mid_3rd))
  possession_data$att_3rd <- as.numeric(as.character(possession_data$att_3rd))
  possession_data$att_pen <- as.numeric(as.character(possession_data$att_pen))
  possession_data$x90s <- as.numeric(as.character(possession_data$x90s))
  possession_data$poss <- as.numeric(as.character(possession_data$poss))
  
  # Calculamos los porcentajes de posesión en cada tercio del campo
  possession_data$pc_def3rd <- round((possession_data$def_3rd / (possession_data$def_3rd + possession_data$mid_3rd + possession_data$att_3rd)) * 100, 2)
  possession_data$pc_mid3rd <- round((possession_data$mid_3rd / (possession_data$def_3rd + possession_data$mid_3rd + possession_data$att_3rd)) * 100, 2)
  possession_data$pc_att3rd <- round((possession_data$att_3rd / (possession_data$def_3rd + possession_data$mid_3rd + possession_data$att_3rd)) * 100, 2)
  
  # Normalizamos la presión en cada tercio del campo
  possession_data$press_def3rd <- round((possession_data$def_3rd / possession_data$x90s) / (100 - possession_data$poss), 2)
  possession_data$press_mid3rd <- round((possession_data$mid_3rd / possession_data$x90s) / (100 - possession_data$poss), 2)
  possession_data$press_att3rd <- round((possession_data$att_3rd / possession_data$x90s) / (100 - possession_data$poss), 2)
  
  # Calculamos la presión promedio en cada zona del campo
  prom_press_def3rd <- mean(possession_data$press_def3rd)
  prom_press_mid3rd <- mean(possession_data$press_mid3rd)
  prom_press_att3rd <- mean(possession_data$press_att3rd)
  
  # Calculamos la desviación de la presión respecto al promedio
  possession_data$pc_press_offset_def3rd <- round(((possession_data$press_def3rd / prom_press_def3rd) * 100) - 100, 2)
  possession_data$pc_press_offset_mid3rd <- round(((possession_data$press_mid3rd / prom_press_mid3rd) * 100) - 100, 2)
  possession_data$pc_press_offset_att3rd <- round(((possession_data$press_att3rd / prom_press_att3rd) * 100) - 100, 2)
  
  # Creamos un dataframe con los valores de presión por zona
  teams_press_pc_offset <- possession_data %>%
    select(squad, pc_press_offset_def3rd, pc_press_offset_mid3rd, pc_press_offset_att3rd) %>%
    reshape2::melt(id.vars = "squad") %>%
    mutate(zona = case_when(
      variable == 'pc_press_offset_def3rd' ~ 16.6,
      variable == 'pc_press_offset_mid3rd' ~ 50,
      variable == 'pc_press_offset_att3rd' ~ 83.4
    ),
    rango = case_when(
      value < -5 ~ 'Red',
      value < 5 ~ 'Yellow',
      value >= 5 ~ 'Green'
    ))
  
  # Creamos otro dataframe con los valores de posesión en cada tercio del campo
  teams_poss_zone <- possession_data %>%
    select(squad, pc_def3rd, pc_mid3rd, pc_att3rd) %>%
    reshape2::melt(id.vars = "squad") %>%
    mutate(zona = case_when(
      variable == 'pc_def3rd' ~ 16.6,
      variable == 'pc_mid3rd' ~ 50,
      variable == 'pc_att3rd' ~ 83.4
    ))
  
  return(list(possession_data = possession_data, teams_press_pc_offset = teams_press_pc_offset, teams_poss_zone = teams_poss_zone))
}
