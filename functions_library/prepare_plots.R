### Función para crear el campo de fútbol en blanco con estilo OptaMAP
OptaMAPcampofutbolblanco <- function(){
  # Definimos un tema sin elementos visuales adicionales
  theme_blankPitch = function(size=12) {
    theme(
      axis.text.x=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.length=unit(0, "lines"),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),
      legend.background=element_rect(fill="#FFFFFF", colour=NA),
      legend.key=element_rect(colour="#FFFFFF",fill="#FFFFFF"),
      legend.key.size=unit(1.2, "lines"),
      legend.text=element_text(size=size),
      legend.title=element_text(size=size, face="bold",hjust=0),
      strip.background = element_rect(colour = "#FFFFFF", fill = "#FFFFFF", linewidth = .5),
      panel.background=element_rect(fill="#FFFFFF",colour="#FFFFFF"),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      panel.spacing=element_blank(),
      plot.background=element_blank(),
      plot.margin=unit(c(0, 0, 0, 0), "lines"),
      plot.title=element_text(size=size*1.2),
      strip.text.y=element_text(colour="#FFFFFF",size=size,angle=270),
      strip.text.x=element_text(size=size*1))}
  
  ymin <- 0
  xmin <- 0
  
  # Definición de dimensiones del campo de fútbol
  GoalWidth <- 732  # Ancho de la portería
  penspot <- 1100  # Punto de penalti
  boxedgeW <- 4032  # Ancho del área grande
  boxedgeL <- 1650  # Largo del área grande
  box6yardW <- 1832  # Ancho del área pequeña
  box6yardL <- 550  # Largo del área pequeña
  
  # Cálculos para dibujar el campo
  TheBoxWidth <- c(((7040 / 2) + (boxedgeW / 2)),((7040 / 2) - (boxedgeW / 2)))
  TheBoxHeight <- c(boxedgeL,10600-boxedgeL)
  GoalPosts <- c(((7040 / 2) + (GoalWidth / 2)),((7040 / 2) - (GoalWidth / 2)))
  box6yardWidth <- c(((7040 / 2) + (box6yardW / 2)),((7040 / 2) - (box6yardW / 2)))
  box6yardHeight <- c(box6yardL,10600-box6yardL)
  
  # Dimensiones del círculo central
  centreCirle_d <- 1830
  
  # Función para generar círculos
  circleFun <- function(center = c(0,0),diameter = 1, npoints = 100){
    r = diameter / 2
    tt <- seq(0,2*pi,length.out = npoints)
    xx <- center[1] + r * cos(tt)
    yy <- center[2] + r * sin(tt)
    return(data.frame(x = xx, y = yy))
  }
  
  # Crear los arcos del área de penalti
  Dleft <- circleFun(c((penspot),(7040/2)),centreCirle_d,npoints = 1000)
  Dleft <- Dleft[which(Dleft$x >= (boxedgeL)),]
  
  Dright <- circleFun(c((10600-(penspot)),(7040/2)),centreCirle_d,npoints = 1000)
  Dright <- Dright[which(Dright$x <= (10600-(boxedgeL))),]
  
  # Crear el círculo central
  center_circle <- circleFun(c((10600/2),(7040/2)),centreCirle_d,npoints = 100)
  
  # Crear las esquinas del campo
  TopLeftCorner <- circleFun(c(xmin,7040),200,npoints = 1000)
  TopRightCorner <- circleFun(c(10600,7040),200,npoints = 1000)
  BottomLeftCorner <- circleFun(c(xmin,ymin),200,npoints = 1000)
  BottomRightCorner <- circleFun(c(10600,ymin),200,npoints = 1000)
  
  # Generar el gráfico del campo de fútbol
  p <- ggplot() +
    xlim(c(-10,10600+10)) + ylim(c(-10,7040+10)) +
    theme_blankPitch() +
    geom_rect(aes(xmin=0, xmax=10600, ymin=0, ymax=7040), fill = "#ffffff", colour = "#000000") +
    geom_rect(aes(xmin=0, xmax=TheBoxHeight[1], ymin=TheBoxWidth[1], ymax=TheBoxWidth[2]), fill = "#ffffff", colour = "#000000") +
    geom_rect(aes(xmin=TheBoxHeight[2], xmax=10600, ymin=TheBoxWidth[1], ymax=TheBoxWidth[2]), fill = "#ffffff", colour = "#000000") +
    geom_rect(aes(xmin=0, xmax=box6yardHeight[1], ymin=box6yardWidth[1], ymax=box6yardWidth[2]), fill = "#ffffff", colour = "#000000")  +
    geom_rect(aes(xmin=box6yardHeight[2], xmax=10600, ymin=box6yardWidth[1], ymax=box6yardWidth[2]), fill = "#ffffff", colour = "#000000")  +
    geom_segment(aes(x = 10600/2, y = ymin, xend = 10600/2, yend = 7040),colour = "#000000") +
    geom_path(data=Dleft, aes(x=x,y=y), colour = "#000000") +
    geom_path(data=Dright, aes(x=x,y=y), colour = "#000000") +
    geom_path(data=center_circle, aes(x=x,y=y), colour = "#000000") +
    geom_point(aes(x = penspot , y = 7040/2), colour = "#000000") +
    geom_point(aes(x = (10600-(penspot)) , y = 7040/2), colour = "#000000") +
    geom_point(aes(x = (10600/2) , y = 7040/2), colour = "#000000") +
    geom_segment(aes(x = xmin, y = GoalPosts[1], xend = xmin, yend = GoalPosts[2]),colour = "#000000", linewidth = 1) +
    geom_segment(aes(x = 10600, y = GoalPosts[1], xend = 10600, yend = GoalPosts[2]),colour = "#000000", linewidth = 1)+
    theme(legend.position="bottom")
  
  return(p)
}

# Llamada a la función para visualizar el campo de fútbol
# OptaMAPcampofutbolblanco()


### Función para graficar la posesión y la desviación de la presión respecto de la presión media en cada tercio del campo 
plot_possession_data <- function(teams, teams_press_pc_offset, teams_press_zone) {
  teams_plot <- list()
  j <- 0
  
  for (i in teams$squad) {
    j <- j + 1
    
    # Filtramos los datos de presión y posesión para el equipo actual
    team_press_pc_offset <- dplyr::filter(teams_press_pc_offset, squad == i)
    teams_poss_zone <- dplyr::filter(teams_press_zone, squad == i)
    team_badge <- dplyr::filter(teams, squad == i)
    
    # Generamos el campo de fútbol como fondo del gráfico
    h <- OptaMAPcampofutbolblanco()
    
    # Creamos el gráfico con las zonas de presión y posesión
    p <- h +
      geom_image(data = team_badge, aes(x = 5300, y = 3520, image = badge_image), size = 0.5, alpha = 0.6) +
      geom_bar(data = team_press_pc_offset, aes(x = zona * 106, y = 7040, fill = as.factor(rango)), width = 3500, stat = "identity", alpha = 0.5) +
      scale_fill_manual(values = c("Red" = "red", "Green" = "green", "Yellow" = "yellow")) +
      annotate("text", x = team_press_pc_offset$zona * 106, y = 1000, label = paste(team_press_pc_offset$value, "%"), size = 4, fontface = 2, parse = FALSE) +
      annotate("text", x = teams_poss_zone$zona * 106, y = 6500, label = paste(teams_poss_zone$value, "%"), size = 4, fontface = 2, parse = FALSE) +
      theme(legend.position = "none")
    
    teams_plot[[j]] <- p
  }
  
  # Mostramos todos los gráficos en una única figura
  grid_plots <- grid.arrange(grobs = teams_plot, ncol = 4, as.table = FALSE)
  
}
