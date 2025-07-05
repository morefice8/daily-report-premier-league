# Cargar el paquete necesario para generar reportes
library(rmarkdown)
library(here)

# Función para generar el reporte
generate_report <- function() {
  # Obtener la fecha y la hora actual en un formato legible
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  
  # Generar el nombre del archivo de salida con el timestamp
  output_file <- paste0("Daily_Report_Premier_League_", timestamp, ".html")
  
  # Definir el directorio de salida de manera dinámica
  output_dir <- file.path(getwd(), "reports")  # Definir la carpeta de salida como "reports"
  
  # Crear la carpeta de salida si no existe
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }
  
  # Renderizar el archivo R Markdown en un documento HTML
  rmarkdown::render(input = file.path(script_dir, "Report_Generic_Stats_PL.Rmd"),
                    output_format = "html_document",
                    output_file = file.path(output_dir, output_file))
}
