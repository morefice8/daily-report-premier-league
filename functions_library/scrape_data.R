# Cargar el paquete necesario para web scraping
library(rvest)

# URL de la página web con los datos de la Premier League
url <- "https://fbref.com/en/comps/9/Premier-League-Stats"

# Función para extraer datos desde la web
scrape_overall_data <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#results2024-202591_overall") %>%
    html_table()
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}

scrape_standard_stats <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_standard_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}

scrape_squad_shooting <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_shooting_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_standard_stats)
}

scrape_squad_passing <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_passing_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}

scrape_squad_pass_type <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_passing_types_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}

scrape_squad_sca <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_gca_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}

scrape_squad_possession <- function() {
  
  # Leer el contenido de la página web
  page <- read_html(url)
  
  # Extraer la tabla de la clasificación con estadísticas básicas de los equipos
  team_stats <- page %>%
    html_node("table#stats_squads_possession_for") %>%
    html_table()
  
  # Convertir la segunda fila en el encabezado de las columnas
  colnames(team_stats) <- team_stats[1, ]
  team_stats <- team_stats[-1, ]
  
  # Devolver la tabla de la clasificación
  return(team_stats)
}




