#Carlos A. González M. Profesor
# Departamento de Ingeniería Civil y Agrícola
#Facultad de Ingeniería 
#Universidad Nacional de Colombia
#Que es un DATAFRAME (df):
#Es una tabla ó un arreglo en donde las columnas contienen valores Y
# cada hilera contiene los valores de cada columna
# la primera columna puede contener valores alfanuméricos
# Características 1. Debe contener el nombre de las columnas
# 2. Los nombres o datos de las hileras deben ser únicas
# 3. Lo almacenado en el df puede ser numérico, caracter ó factor
# 4. Cada columna debe contener el mismo número de datos
# Como se construye?
# Create the data frame.
nuevo.dat <- data.frame(est_hydrol = c(1:5), 
                        nombre_est= c("Kevin","Juan","Pedro","Reynel","Gustavo"),
                        notas_est = c(0,1,1.3,1.5,2), 
                        fecha_cla = as.Date(c("2022-06-25", "2021-06-25", "2020-06-25", "2019-06-25",
                                              "2018-06-25")), stringsAsFactors = FALSE)
# Print the data frame.			
print(nuevo.dat)
#obtener la estructura de los datos
# Get the structure of the data frame.
str(nuevo.dat)
#En Hidrología se tiene información: 
#Caudales Quebrada la mona_ puerto brasil.xlsx 
# Una de las formas es cargar la libreria tydverse
install.packages("tidyverse")
#La siguiente libreria hace parte del tidyverse
library(readxl)
MisCaudales <- read_excel(
  "MisCaudales.xlsx",sheet="hoja1",na="NA")
View(MisCaudales)
#obtener la estructura de los datos
# Get the structure of the data frame.
str(MisCaudales)
#Para leer la otra hoja y escribir otro df 
#se puede poner el numero de hoja así: 
MisCaudales2 <- read_excel(
  "MisCaudales.xlsx",sheet=2,na="NA")
View(MisCaudales2)
#obtener la estructura de los datos
# Get the structure of the data frame.
str(MisCaudales2)
#Se pueden identificar cuantos datos faltantes (NA) por columna 
#existen # Entrega Resumen Estadístico de cada una de las columnas
#Entrega por columna:Minimo, Primer Cuartil,Mediana, Promedio
#Tercer quartil y Valor  Máximo (Esta información aparece en la consola)
#Observe que le aparecen 266 caudales
#promedios diarios faltantes
#Print the statistics summary .
print(summary(MisCaudales2)) 

#En el data frame (df) se hacen operaciones 
#con los valores de las columnas Una primera Aproximación
#consiste en obtener los estadisticos de cada columna del df
#sin tener en cuenta los valores faltantes.
#Identifiquemos donde están los valores faltantes del conjunto de datos.
#en este caso solo vamos a coger el MisCaudales2 
#(Lo puede abrir desde el Global environment)
# Crear una sentencia lógica con valores TRUE and FALSE 
# Indicando valores faltantes y observados
posicion<-c(which(is.na(MisCaudales2$`Caudal(m3/s)`)))
#apply(is.na(MisCaudales2), 2, which) 
# Para saber en que posiciones están los datos faltantes de cada columna en
# información se usa la función apply()
print(posicion)
Nuevovector <- data.frame(Lugar = c(numero=seq(1, 266, 1)), 
                          caudal= c(posicion), stringsAsFactors = FALSE)
# Get the structure of the data frame.
str(MisCaudales2)
str(posicion)
str(Nuevovector)
print(Nuevovector)

# -------------------------------
# FUNCIÓN: Curva de Duración de Caudales
# -------------------------------
# Esta función tiene como propósito calcular la curva de duración de caudales a partir de una serie
# de datos de caudales observados (normalmente registrados diariamente o con otra frecuencia regular).
# 
# La curva de duración de caudales es una herramienta hidrológica que permite analizar
# la disponibilidad de caudal a lo largo del tiempo, ordenando los valores de mayor a menor
# y calculando la frecuencia con que dichos caudales son igualados o excedidos.
#
# Esta curva se utiliza, por ejemplo, para evaluar la disponibilidad de agua para abastecimiento
# o generación hidroeléctrica, y para caracterizar cuencas.

curva_duracion_caudales <- function(caudales) {
  # Paso 1: Ordenar los caudales de mayor a menor
  # Esto es necesario porque la curva de duración muestra la probabilidad de excedencia,
  # es decir, qué porcentaje del tiempo un caudal determinado es igualado o superado.
  caudales_ordenados <- sort(caudales, decreasing = TRUE)
  
  # Paso 2: Contar el número total de observaciones (N)
  N <- length(caudales_ordenados)
  
  # Paso 3: Asignar un índice a cada observación ordenada (de 1 a N)
  i <- 1:N
  
  # Paso 4: Calcular la Probabilidad. Se utiliza la fórmula (Modelo) de probabilidad en función de la Distribución de donde provienen los datos,  
  # de acuerdo con Cunnane, C. (1978) Unbiased Plotting Positions: A Review. Journal of Hydrology, 37, 205-222.https://doi.org/10.1016/0022-1694(78)90017-3 
  # Como los Caudales diarios se asumen N(0,1);Se utiliza la fórmula de probabilidad de Bloom: F = (i - 0.375) / (N + 0.25)
  # i= rango  N=tamaño de la muestra.
  # Esta fórmula salió de simulaciones de Montecarlo; es una aproximación que mejora la estimación de la probabilidad.
  # acumulada en muestras pequeñas o medianas.
  F <- (i - 0.375) / (N + 0.25)
  # Cuando la muestra se ordena de mayor a menor corresponde a probalidad de excedencia. 
  #Si se ordenan los  datos de Menor a mayor correspondería una asignación de probabilidad de no-excedencia 
  # Paso 5: Convertir la frecuencia a porcentaje para la curva
  # s es la probabilidad de no excedencia, expresada en porcentaje (0% a 100%).
  s <- F * 100
  # Abramowitz M. and I. Stegun (1964) Handbook of mathematical Functions. Ninth Edition. 1046 Pag. Dover Publications  
  # Paso 6: Función auxiliarobtenida de Abramowitz and Stegun(1970) para calcular el valor z (normal estándar)
  # NUEVA FUNCIÓN: Aproximación de Z(x) usando P(x)
  # Esta función se basa en una fórmula racional que aproxima
  # el valor z (cuantil de la distribución normal estándar)
  # a partir de una probabilidad P(x).
  z_aprox <- function(x, P_x) {
    # Constantes del modelo
    p <- 0.33267
    a1 <- 0.4361836
    a2 <- -0.1201676
    a3 <- 0.9372980
    
    # Cálculo del término auxiliar t
    t <- 1 / (1 + p * x)
    
    # Evaluación del polinomio aproximado
    poly_val <- a1 * t + a2 * t^2 + a3 * t^3
    
    # Resultado final de la aproximación
    Z_x <- (1 - P_x) / poly_val
    
    return(Z_x)
  }
  
  # Calcular los valores z para cada frecuencia acumulada
  # Se evalúa z_aprox en x = sqrt(-2 ln(1 - P)), que es una transformación común
  z <- numeric(length(F))
  for (j in seq_along(F)) {
    x_val <- sqrt(-2 * log(1 - F[j]))  # Transformación para entrada x
    z[j] <- z_aprox(x_val, F[j])       # Aproximación de z
  }
  
  # Crear y devolver un dataframe con resultados
  df <- data.frame(Q = caudales_ordenados, i = i, F = F, s = s, z = z)
  return(df)
}
# -------------------------------
# FUNCIÓN: Graficar la curva de duración
# -------------------------------
# Esta función genera un gráfico de la curva de duración de caudales a partir del dataframe
# generado por la función anterior. El gráfico representa los caudales en el eje Y y el 
# porcentaje de tiempo excedido en el eje X.
#
# Es una visualización útil para tomar decisiones técnicas sobre el uso del recurso hídrico.
graficar_curva <- function(df) {
  # Validación de datos
  if (!all(c("s", "Q") %in% names(df))) {
    stop("El dataframe debe contener columnas 's' y 'Q'")
  }
  
  # Filtrar valores no válidos
  df <- df[!is.na(df$Q) & df$Q > 0, ]
  if (nrow(df) == 0) stop("No hay datos válidos para graficar (Q > 0)")
  
  # Configuración gráfica profesional
  op <- par(no.readonly = TRUE)
  on.exit(par(op))
  
  par(bg = "gray95", mar = c(5, 5, 4, 2) + 0.1, mgp = c(3.5, 1, 0), las = 1)
  
  # Rango extendido para el eje Y logarítmico
  y_lim <- range(df$Q)
  y_lim[1] <- max(y_lim[1], 10^floor(log10(min(df$Q))))
  y_lim[2] <- 10^ceiling(log10(max(df$Q)))
  
  # Crear gráfico base vacío
  plot(NA, 
       xlim = c(0, 100), 
       ylim = y_lim,
       log = "y",
       xlab = "Porcentaje del tiempo excedido (%)", 
       ylab = "",
       main = "Curva de Duración de Caudales",
       cex.lab = 1.4, 
       cex.main = 1.6,
       font.main = 2,
       family = "sans",
       xaxt = "n", yaxt = "n",
       panel.first = {
         grid(ny = NA, lty = "solid", col = "gray85")
         abline(h = axTicks(2), col = "gray75", lty = "dotted")
       })
  
  # Eje Y con formato mejorado
  y_ticks <- axTicks(2)
  axis(2, at = y_ticks, 
       labels = format(y_ticks, scientific = FALSE, drop0trailing = TRUE),
       las = 1, cex.axis = 1.1, col.axis = "black")
  title(ylab = expression(Caudal~(m^3/s)), line = 4, cex.lab = 1.3, col.lab = "black")
  
  # Eje X mejorado
  x_ticks <- seq(0, 100, by = 20)
  axis(1, at = x_ticks, labels = x_ticks, cex.axis = 1.1, col.axis = "black")
  
  # Puntos estilizados
  points(df$s, df$Q, 
         pch = 21, 
         bg = "#FFAB00", 
         col = "#D32F2F",
         cex = 1.5, 
         lwd = 1.2)
  
  # Línea suavizada mejorada con loess (dibujada después de los puntos)
  smooth_curve <- loess(log10(Q) ~ s, data = df, span = 0.5)  # span ajustado
  smooth_values <- 10^(predict(smooth_curve, newdata = seq(0, 100, length.out = 200)))
  lines(seq(0, 100, length.out = 200), smooth_values, col = "#1E88E5", lwd = 2.5)
  
  # Leyenda ajustada hacia la derecha
  legend("topright", 
         legend = c("Datos observados", "Tendencia suavizada"),
         pch = c(21, NA),
         lty = c(NA, 1),
         col = c("#D32F2F", "#1E88E5"),
         pt.bg = c("#FFAB00", NA),
         pt.cex = 1.5,
         lwd = c(NA, 2.5),
         bty = "n",
         cex = 1.1,
         inset = c(0.05, 0.1),  # Ajusta horizontalmente y verticalmente
         x.intersp = 0.8)       # Reduce espacio horizontal entre símbolo y texto
}
# Cálculo
df_caudales <- curva_duracion_caudales(MisCaudales2$`Caudal(m3/s)`)

# Gráfico
graficar_curva(df_caudales)
