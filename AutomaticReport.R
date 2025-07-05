# Cargar los paquetes necesarios
library(dplyr)        # Paquete para manipulación de datos
library(rvest)        # Paquete para web scraping
library(tidyr)        # Paquete para manipulación de datos
library(ggplot2)      # Paquete para visualización de datos
library(rmarkdown)    # Paquete para generación de reportes
library(taskscheduleR) # Paquete para creación de tareas programadas
library(stringr)      # Paquete para manipulación de cadenas de texto
library(here)         # Paquete para gestionar rutas de archivos dinámicas
library(ggimage)      # Paquete para agregar imágenes
library(gridExtra)    # Paquete para agregar graficos 

### Establecer la ruta de trabajo de manera dinámica
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  # Si estamos en RStudio, obtenemos la ruta del archivo actual
  script_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
} else {
  # Si no estamos en RStudio, usamos commandArgs como alternativa
  args <- commandArgs(trailingOnly = FALSE) # Obtiene los argumentos de la línea de comandos
  match <- grep("--file=", args) # Busca el argumento que contiene la ruta del script
  if (length(match) > 0) {
    # Si encontramos el argumento "--file=", extraemos la ruta absoluta del script
    script_path <- normalizePath(sub("--file=", "", args[match]))  
    script_dir <- dirname(script_path)  # Obtenemos la carpeta donde está el scrip
  } else {
    # Si no se encuentra la ruta del script, usamos el directorio de trabajo actual
    script_dir <- getwd()  # Se non è stato trovato, usiamo la cartella di lavoro corrente
  }
}

# Establecer la carpeta del script como directorio de trabajo
setwd(script_dir)

# Depuración: Verificar la ruta de trabajo actual
print(paste("Directorio de trabajo:", getwd()))

### Cargar las funciones desde los archivos auxiliares -> Usar file.path() para evitar problemas con las rutas relativas
source(file.path(script_dir, "functions_library", "scrape_data.R"))     # Funciónes para extraer datos
source(file.path(script_dir, "functions_library", "clean_data.R"))      # Funciónes para limpiar datos
source(file.path(script_dir, "functions_library", "generate_report.R")) # Funciónes para generar reporte
source(file.path(script_dir, "functions_library", "prepare_data.R"))    # Funciónes para manpular datos
source(file.path(script_dir, "functions_library", "prepare_plots.R"))   # Funciónes para generar graficos

### Ejecutar las funciónes de scraping para obtener las estadísticas del equipo
team_overall_data <- scrape_overall_data()
team_standard_stats <- scrape_standard_stats()
team_shooting <- scrape_squad_shooting()
team_passing <- scrape_squad_passing()
team_pass_type <- scrape_squad_pass_type()
team_sca <- scrape_squad_sca()
team_possession <- scrape_squad_possession()

### Aplicar la función de limpieza a los datos extraídos
cleaned_team_overall_data <- clean_data(team_overall_data)
cleaned_team_standard_stats <- clean_data(team_standard_stats)
cleaned_team_shooting <- clean_data(team_shooting)
cleaned_team_passing <- clean_data(team_passing)
cleaned_team_pass_type <- clean_data(team_pass_type)
cleaned_team_sca <- clean_data(team_sca)
cleaned_team_possession <- clean_data(team_possession)

### Guardar los datos limpios en un archivo CSV
write.csv(cleaned_team_overall_data, "cleaned_team_overall_data.csv", row.names = FALSE)
write.csv(cleaned_team_standard_stats, "cleaned_team_standard_stats.csv", row.names = FALSE)
write.csv(cleaned_team_shooting, "cleaned_team_shooting.csv", row.names = FALSE)
write.csv(cleaned_team_passing, "cleaned_team_passing.csv", row.names = FALSE)
write.csv(cleaned_team_pass_type, "cleaned_team_pass_type.csv", row.names = FALSE)
write.csv(cleaned_team_sca, "cleaned_team_sca.csv", row.names = FALSE)
write.csv(cleaned_team_possession, "cleaned_team_possession.csv", row.names = FALSE)

### Ejecutar la función para generar el reporte
generate_report()

### Creación de una tarea programada para realizar scraping y generar el reporte con frecuencia diaria
# Nombre de la tarea
taskname <- "Generate_PL_Report"

# Sección de código para debug: Eliminar la tarea existente si ya existe
# taskscheduler_delete(taskname)

# Verificar si la tarea ya existe
existing_tasks <- taskscheduler_ls()
task_exists <- any(existing_tasks$TaskName == taskname)

# Crear la tarea programada solo si no existe
if (!task_exists) {
  # Si la tarea no existe, crear una nueva tarea programada
  taskscheduler_create(
    taskname = taskname,  # Nombre de la tarea
    rscript = file.path(script_dir, "AutomaticReport.R"),  # Ruta absoluta correcta
    schedule = "DAILY",  # Frecuencia diaria
    starttime = "07:00",  # Hora de inicio de la tarea
    startdate = format(Sys.Date(), "%d/%m/%Y")  # Fecha de inicio
  )
} else {
  # Si la tarea ya existe, mostrar un mensaje informativo
  message("La tarea ya existe, no se crea una nueva.")
}

