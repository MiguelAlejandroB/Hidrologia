import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

class CurvaDuracionCaudales:
    def __init__(self, caudales):
        self.caudales = np.sort(caudales)[::-1]
        self.N = len(caudales)
        self.df = pd.DataFrame({'Q': self.caudales})
        self._calcular_probabilidad()
        self._calcular_z()

    def _calcular_probabilidad(self):
        self.df['i'] = np.arange(1, self.N + 1)
        self.df['F'] = (self.df['i'] - 0.375) / (self.N + 0.25)
        self.df['s (%)'] = self.df['F'] * 100

    def _calcular_z(self):
        # Inversa aproximada de la distribución normal estándar
        def p_inv(x):
            x = np.sqrt(-2 * np.log(x))
            t = 1 / (1 + 0.3275911 * x)
            poly = (1 + 0.196854*x + 0.115194*x**2 + 0.000344*x**3 + 0.019527*x**4)
            return 1 - 0.5 * (poly**-4)

        self.df['z'] = self.df['F'].apply(lambda f: p_inv(1 - f))



    def graficar(self):
        fig, ax = plt.subplots(figsize=(8, 5))
        
        ax.plot(
            self.df['s (%)'], self.df['Q'],
            marker='o', linestyle='-', color='#2c7bb6', linewidth=2,
            markerfacecolor='#abd9e9', markeredgecolor='#2c7bb6', markersize=6
        )

        ax.set_xlabel('Tiempo excedido (%)', fontsize=12)
        ax.set_ylabel('Caudal (m³/s)', fontsize=12)
        ax.set_title('Curva de Duración de Caudales', fontsize=14, weight='bold')

        ax.grid(True, linestyle='--', color='gray', alpha=0.7)
        ax.set_xlim(left=0, right=100)  # eje X inicia en 0 (izquierda) y termina en 100 (derecha)

        plt.xticks(fontsize=10)
        plt.yticks(fontsize=10)
        plt.tight_layout()
        plt.show()


    def exportar(self, nombre='curva_duracion.csv'):
        self.df.to_csv(nombre, index=False)

# Ejemplo de uso
caudales = [12.3, 8.9, 14.2, 10.1, 9.7]
cdc = CurvaDuracionCaudales(caudales)
cdc.graficar()
cdc.exportar()