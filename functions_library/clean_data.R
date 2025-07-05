# Cargar los paquetes necesarios para la manipulación de datos
library(dplyr)
library(tidyr)
library(stringr)
library(janitor)

# Función para limpiar los datos extraídos
clean_data <- function(data) {
  data <- data %>%
    # Limpiar los nombres de las columnas
    janitor::clean_names() %>%
    
    # Eliminar espacios en blanco de los datos de tipo carácter
    mutate(across(where(is.character), str_trim)) %>%
    
    # Convertir los factores en caracteres
    mutate(across(where(is.factor), as.character)) %>%
    
    # Sustituir los valores NA en columnas numéricas por 0
    mutate(across(where(is.numeric), ~replace_na(., 0))) %>%
    
    # Sustituir los valores NA en columnas de carácter por "N/A"
    mutate(across(where(is.character), ~replace_na(., "N/A")))
  
  # Devolver los datos limpios
  return(data)
}

# Función para assegnare badges
assign_badge_code <- function(df, league) {
  # Dizionario dei codici badge per ogni squadra, diviso per lega
  badge_dict <- list(
      "Premier League" = list(
      "Liverpool" = "ENG_LIV",
      "Arsenal" = "ENG_ARS",
      "Nott'ham Forest" = "ENG_NFO",
      "Manchester City" = "ENG_MCI",
      "Bournemouth" = "ENG_BOU",
      "Chelsea" = "ENG_CHE",
      "Newcastle Utd" = "ENG_NEW",
      "Fulham" = "ENG_FUL",
      "Aston Villa" = "ENG_AVL",
      "Brighton" = "ENG_BHA",
      "Brentford" = "ENG_BRE",
      "Tottenham" = "ENG_TOT",
      "Crystal Palace" = "ENG_CRY",
      "Everton" = "ENG_EVE",
      "Manchester Utd" = "ENG_MUN",
      "West Ham" = "ENG_WHU",
      "Wolves" = "ENG_WOL",
      "Ipswich Town" = "ENG_IPS",
      "Leicester City" = "ENG_LEI",
      "Southampton" = "ENG_SOU"
    )
  )
  
  # Verifica che la lega sia nel dizionario
  if (!(league %in% names(badge_dict))) {
    stop("Lega non trovata nel dizionario dei badge.")
  }
  
  # Ottiene il dizionario delle squadre per la lega selezionata
  league_teams <- badge_dict[[league]]
  
  # Aggiunge una colonna con il codice badge, assegnando NA se la squadra non è trovata
  df$badge_code <- sapply(df$squad, function(team) league_teams[[team]] %||% NA)
  
  return(df)
}

