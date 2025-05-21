# 🌊 Curva de Duración de Caudales – Método de Distribución de Probabilidad

Este repositorio documenta el proceso para construir una **curva de duración de caudales**, una herramienta fundamental en hidrología que permite analizar la variabilidad y disponibilidad del caudal en un cuerpo de agua durante un periodo de tiempo determinado.

---

## 📌 Objetivo

El objetivo es obtener una curva que muestre el caudal (Q) en función del **porcentaje del tiempo en que dicho caudal es igualado o superado**. Esto se logra aplicando el **método de distribución de probabilidad empírica**, específicamente una fórmula basada en frecuencia acumulada.

---

## 📈 Etapas del Proceso

### 1. Recolección de datos

Se parte de una serie de datos de caudal registrados a intervalos regulares (diarios, mensuales, etc.):

```plaintext
Ejemplo:
Q (m³/s): 12.3, 8.9, 14.2, 10.1, 9.7, ...
```

---

### 2. Ordenamiento de caudales

Los datos se ordenan en **orden descendente**, del mayor al menor:

```plaintext
Q ordenados (m³/s): 14.2, 12.3, 10.1, 9.7, 8.9, ...
```

---

### 3. Asignación de rango (i)

A cada caudal ordenado se le asigna un rango correspondiente a su posición en el ordenamiento:

```plaintext
| i | Q (m³/s) |
|---|----------|
| 1 | 14.2     |
| 2 | 12.3     |
| 3 | 10.1     |
| 4 | 9.7      |
| 5 | 8.9      |
```

---

### 4. Cálculo de la probabilidad de excedencia (F)

Se aplica la siguiente fórmula para calcular la frecuencia acumulada (probabilidad de excedencia):

$$
F = \frac{i - 0.375}{N + 0.25}
$$

Donde:

* $F$: frecuencia acumulada o probabilidad de excedencia
* $i$: rango del caudal (posición en la lista ordenada)
* $N$: número total de datos

> Ejemplo para i = 2 y N = 5:
>
> $$
> F = \frac{2 - 0.375}{5 + 0.25} = \frac{1.625}{5.25} \approx 0.3095
> $$

---

### 5. Conversión a porcentaje de tiempo excedido (s)

Se convierte la probabilidad en porcentaje:

$$
s = F \times 100
$$

> En el ejemplo anterior:
>
> $$
> s = 0.3095 \times 100 = 30.95\%
> $$

Esto indica que el caudal de 12.3 m³/s fue igualado o superado el 30.95% del tiempo.

---

### 6. Graficar la curva de duración

Con los valores obtenidos de **Q** y **s**, se construye la curva:

* Eje **X**: porcentaje del tiempo excedido (**s**)
* Eje **Y**: caudal (**Q**)

La curva resultante tiene una forma descendente, indicando que los caudales mayores ocurren con menor frecuencia.

---

## 📐 Ajuste con regresión (opcional)

Para suavizar la curva o realizar un análisis matemático, puede aplicarse una **regresión polinomial**, generalmente de segundo o tercer grado, ajustando una función de la forma:

$$
Q = a(s)^2 + b(s) + c
$$

Este modelo puede facilitar simulaciones, interpolaciones o uso en software de análisis hidráulico.

---

## 📦 Estructura esperada del archivo de entrada

El proceso puede automatizarse usando una hoja de cálculo o script que contenga una columna con los valores de caudal.

```plaintext
| Q (m³/s) |
|----------|
| 12.3     |
| 8.9      |
| 14.2     |
| 10.1     |
| 9.7      |
```

El script o archivo puede generar automáticamente las columnas: `Q ordenado`, `i`, `F`, `s (%)` y la gráfica final.

---

## 📊 Resultado final

La curva de duración de caudales permite:

* Visualizar la disponibilidad del recurso hídrico.
* Evaluar el comportamiento del caudal en condiciones normales, medias y de sequía.
* Tomar decisiones en proyectos de riego, abastecimiento, generación hidroeléctrica, etc.

---

## 🛠️ Herramientas recomendadas

* Microsoft Excel o Google Sheets
* Python (con pandas, matplotlib, numpy)
* R (con ggplot2)
* QGIS con complementos hidrológicos

---

## 📚 Referencias

* Chow, V.T. (1988). *Applied Hydrology*.
* Instituto Mexicano de Tecnología del Agua. *Hidrología Básica*.
* Hidrología superficial – materiales de cursos universitarios.

---

## 📄 Licencia

Este proyecto se publica bajo la licencia MIT. Puedes usarlo, modificarlo y distribuirlo libremente con fines académicos y profesionales.
