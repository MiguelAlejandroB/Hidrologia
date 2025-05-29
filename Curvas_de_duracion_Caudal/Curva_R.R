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
  
  # Paso 4: Calcular la frecuencia no excedida acumulada (F)
  # Se utiliza la fórmula de probabilidad de Bloom: F = (i - 0.375) / (N + 0.25)
  # Esta fórmula es una aproximación que mejora la estimación de la probabilidad
  # acumulada en muestras pequeñas o medianas.
  F <- (i - 0.375) / (N + 0.25)
  
  # Paso 5: Convertir la frecuencia a porcentaje para la curva
  # s es la probabilidad de no excedencia, expresada en porcentaje (0% a 100%).
  s <- F * 100
  
  # Paso 6: Función auxiliar para calcular el valor z (normal estándar)
  # Esta función es una aproximación rápida a la inversa de la función de distribución
  # normal acumulada (también conocida como función cuantil o p-norm inversa).
  # Se basa en una fórmula empírica útil cuando no se dispone de funciones estadísticas avanzadas.
  p_inv <- function(x) {
    x <- sqrt(-2 * log(x))  # Transformación basada en la inversa de la función de error
    poly <- (1 + 0.196854 * x + 0.115194 * x^2 + 0.000344 * x^3 + 0.019527 * x^4)
    return(1 - 0.5 * poly^(-4))  # Resultado de la aproximación
  }
  
  # Paso 7: Calcular los valores z para cada probabilidad acumulada
  # Este paso convierte cada valor F en su equivalente z (valor típico de la distribución normal)
  # Se utiliza 1 - F porque buscamos el cuantil superior.
  z <- numeric(length(F))  # Se crea un vector vacío para almacenar los valores z
  for (j in seq_along(F)) {
    z[j] <- p_inv(1 - F[j])  # Se aplica la función p_inv para cada F
  }
  
  # Paso 8: Construir y devolver un dataframe con los resultados
  # Q: caudal ordenado
  # i: posición del caudal ordenado
  # F: frecuencia acumulada (no excedencia)
  # s: porcentaje de tiempo excedido
  # z: valor equivalente de la distribución normal estándar
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
  # Configuración general del gráfico
  # Se establece un fondo blanco y márgenes amplios para los ejes
  par(bg = "white", mar = c(5, 5, 4, 2))
  
  # Crear el gráfico base:
  # type = "b" indica que se grafican tanto los puntos como las líneas.
  # pch = 21: tipo de punto (círculo con borde).
  # lwd = grosor de la línea; col = color del borde; bg = color del relleno.
  # cex = tamaño de los puntos.
  plot(df$s, df$Q, type = "b", pch = 21, lwd = 2,
       col = "#2c7bb6", bg = "#abd9e9", cex = 1.2,
       xlab = "Tiempo excedido (%)",  # Etiqueta del eje X
       ylab = "Caudal (m³/s)",        # Etiqueta del eje Y
       main = "Curva de Duración de Caudales",  # Título del gráfico
       xaxt = "n", yaxt = "n",        # Suprime ejes para personalizarlos
       cex.lab = 1.3, cex.main = 1.5) # Tamaño de etiquetas
  
  # Agregar eje X con marcas "bonitas" (función pretty sugiere marcas limpias)
  axis(1, at = pretty(df$s), labels = pretty(df$s), cex.axis = 1.1)
  
  # Agregar eje Y (rotación vertical de etiquetas: las = 1)
  axis(2, at = pretty(df$Q), labels = pretty(df$Q), las = 1, cex.axis = 1.1)
  
  # Agregar una cuadrícula ligera para mejorar la lectura del gráfico
  grid(col = "gray80", lty = "dotted", lwd = 1)
  
  # Agregar líneas horizontales y verticales en las marcas principales
  abline(h = pretty(df$Q), col = "gray90", lty = "dotted")
  abline(v = pretty(df$s), col = "gray90", lty = "dotted")
}



# Ejemplo de uso
caudales <- c(12.3, 8.9, 14.2, 10.1, 9.7)
df <- curva_duracion_caudales(caudales)
print(df)
graficar_curva(df)

