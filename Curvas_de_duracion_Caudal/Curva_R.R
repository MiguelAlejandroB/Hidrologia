curva_duracion_caudales <- function(caudales) {
  caudales_ordenados <- sort(caudales, decreasing = TRUE)
  N <- length(caudales_ordenados)
  i <- 1:N
  F <- (i - 0.375) / (N + 0.25)
  s <- F * 100
  
  # Aprox. de la inversa de la distribución normal acumulada
  p_inv <- function(x) {
    x <- sqrt(-2 * log(x))
    poly <- (1 + 0.196854 * x + 0.115194 * x^2 + 0.000344 * x^3 + 0.019527 * x^4)
    return(1 - 0.5 * poly^(-4))
  }
  
  # Asegura que el resultado sea vector numérico del mismo tamaño
  z <- numeric(length(F))
  for (j in seq_along(F)) {
    z[j] <- p_inv(1 - F[j])
  }
  
  df <- data.frame(Q = caudales_ordenados, i = i, F = F, s = s, z = z)
  return(df)
}

graficar_curva <- function(df) {
  # Configuración gráfica
  par(bg = "white", mar = c(5, 5, 4, 2))  # Márgenes
  
  # Crear el gráfico
  plot(df$s, df$Q, type = "b", pch = 21, lwd = 2,
       col = "#2c7bb6", bg = "#abd9e9", cex = 1.2,
       xlab = "Tiempo excedido (%)", ylab = "Caudal (m³/s)",
       main = "Curva de Duración de Caudales",
       xaxt = "n", yaxt = "n", cex.lab = 1.3, cex.main = 1.5)
  
  # Ejes personalizados
  axis(1, at = pretty(df$s), labels = pretty(df$s), cex.axis = 1.1)
  axis(2, at = pretty(df$Q), labels = pretty(df$Q), las = 1, cex.axis = 1.1)
  
  # Cuadrícula
  grid(col = "gray80", lty = "dotted", lwd = 1)
  
  # Líneas adicionales (opcional)
  abline(h = pretty(df$Q), col = "gray90", lty = "dotted")
  abline(v = pretty(df$s), col = "gray90", lty = "dotted")
}


# Ejemplo de uso
caudales <- c(12.3, 8.9, 14.2, 10.1, 9.7)
df <- curva_duracion_caudales(caudales)
print(df)
graficar_curva(df)

