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
  # Configuración general del gráfico
  par(bg = "white", mar = c(5, 5, 4, 2))
  
  # Crear el gráfico base:
  # Se invierte el eje X con xlim = rev(range(...)) para que los valores de z
  # (y por tanto los porcentajes excedidos) vayan de 0 a 100 en el sentido correcto
  plot(df$z, df$Q, type = "b", pch = 21, lwd = 2,
       col = "#2c7bb6", bg = "#abd9e9", cex = 1.2,
       xlab = "Z(x)",        # Etiqueta del eje X (cuantil de la normal)
       ylab = "Caudal (m³/s)",  # Etiqueta del eje Y (caudales)
       main = "Curva de Duración de Caudales",
       xaxt = "n", yaxt = "n",
       cex.lab = 1.3, cex.main = 1.5,
       xlim = rev(range(df$z)))  # ← Esta línea invierte el eje X
  
  # Eje X personalizado
  axis(1, at = pretty(df$z), labels = pretty(df$z), cex.axis = 1.1)
  
  # Eje Y personalizado
  axis(2, at = pretty(df$Q), labels = pretty(df$Q), las = 1, cex.axis = 1.1)
  
  # Cuadrícula ligera
  grid(col = "gray80", lty = "dotted", lwd = 1)
  
  # Líneas guía horizontales y verticales
  abline(h = pretty(df$Q), col = "gray90", lty = "dotted")
  abline(v = pretty(df$z), col = "gray90", lty = "dotted")
}




# Ejemplo de uso
caudales <- c(12.3, 8.9, 14.2, 10.1, 9.7)
df <- curva_duracion_caudales(caudales)
print(df)
graficar_curva(df)


