defmodule Datos do

  def confeccionistas do
    [
      %{codigo: "C01", nombre: "Emmanuel Murillo", alquiler: true},
      %{codigo: "C02", nombre: "Sebastián Salinas", alquiler: false},
      %{codigo: "C03", nombre: "Miguel Carabalí", alquiler: false},
      %{codigo: "C04", nombre: "Pedro Mosquera", alquiler: true},
      %{codigo: "C05", nombre: "Marco Asensio", alquiler: false},
      %{codigo: "C06", nombre: "Luna Jaramillo", alquiler: true},
      %{codigo: "C07", nombre: "Maria Sinisterra", alquiler: true},
      %{codigo: "C08", nombre: "Nora Montañez", alquiler: true},
      %{codigo: "C09", nombre: "Gabriela Castaño", alquiler: false},
      %{codigo: "C10", nombre: "Juan Torres", alquiler: false}
    ]
  end

  def lineas do
    [
      %{id: "L1", nombre: "Línea Norte", puestos: 6},
      %{id: "L2", nombre: "Línea Central", puestos: 4},
      %{id: "L3", nombre: "Línea Este", puestos: 3},
      %{id: "L4", nombre: "Línea Oeste", puestos: 5}
    ]
  end

  def lotes do
    [
      # Día 1
      %{confeccionista: "C01", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "C01", linea: "L2", dia: 1, prendas: 55, defectos: 7.0},
      %{confeccionista: "C02", linea: "L1", dia: 1, prendas: 130, defectos: 1.8},
      %{confeccionista: "C03", linea: "L3", dia: 1, prendas: 90, defectos: 4.5},
      %{confeccionista: "C04", linea: "L4", dia: 1, prendas: 45, defectos: 0.5},
      %{confeccionista: "C05", linea: "L2", dia: 1, prendas: 110, defectos: 2.1},
      %{confeccionista: "C06", linea: "L3", dia: 1, prendas: 60, defectos: 8.0},
      %{confeccionista: "C07", linea: "L4", dia: 1, prendas: 75, defectos: 12.5},
      %{confeccionista: "C08", linea: "L1", dia: 1, prendas: 100, defectos: 1.0},
      %{confeccionista: "C09", linea: "L2", dia: 1, prendas: 50, defectos: 3.5},
      %{confeccionista: "C10", linea: "L3", dia: 1, prendas: 85, defectos: 6.0},
      %{confeccionista: "C03", linea: "L1", dia: 1, prendas: 40, defectos: 1.0},
      %{confeccionista: "C05", linea: "L1", dia: 1, prendas: 20, defectos: 0.0},
      %{confeccionista: "C07", linea: "L2", dia: 1, prendas: 60, defectos: 4.2},
      %{confeccionista: "C09", linea: "L3", dia: 1, prendas: 80, defectos: 2.5},

      # Día 2
      %{confeccionista: "C01", linea: "L1", dia: 2, prendas: 90, defectos: 12.0},
      %{confeccionista: "C02", linea: "L2", dia: 2, prendas: 65, defectos: 1.0},
      %{confeccionista: "C02", linea: "L3", dia: 2, prendas: 60, defectos: 1.5},
      %{confeccionista: "C03", linea: "L4", dia: 2, prendas: 150, defectos: 3.0},
      %{confeccionista: "C04", linea: "L1", dia: 2, prendas: 80, defectos: 5.5},
      %{confeccionista: "C05", linea: "L2", dia: 2, prendas: 45, defectos: 2.0},
      %{confeccionista: "C06", linea: "L3", dia: 2, prendas: 95, defectos: 1.2},
      %{confeccionista: "C07", linea: "L4", dia: 2, prendas: 50, defectos: 6.5},
      %{confeccionista: "C08", linea: "L1", dia: 2, prendas: 120, defectos: 0.5},
      %{confeccionista: "C09", linea: "L2", dia: 2, prendas: 70, defectos: 8.5},
      %{confeccionista: "C10", linea: "L3", dia: 2, prendas: 100, defectos: 4.0},
      %{confeccionista: "C01", linea: "L4", dia: 2, prendas: 40, defectos: 1.5},
      %{confeccionista: "C04", linea: "L3", dia: 2, prendas: 50, defectos: 2.5},
      %{confeccionista: "C06", linea: "L1", dia: 2, prendas: 30, defectos: 0.0},
      %{confeccionista: "C10", linea: "L2", dia: 2, prendas: 25, defectos: 1.5},

      # Día 3
      %{confeccionista: "C01", linea: "L2", dia: 3, prendas: 110, defectos: 4.5},
      %{confeccionista: "C02", linea: "L3", dia: 3, prendas: 70, defectos: 1.0},
      %{confeccionista: "C03", linea: "L4", dia: 3, prendas: 85, defectos: 5.0},
      %{confeccionista: "C04", linea: "L1", dia: 3, prendas: 90, defectos: 3.5},
      %{confeccionista: "C05", linea: "L2", dia: 3, prendas: 130, defectos: 0.8},
      %{confeccionista: "C06", linea: "L3", dia: 3, prendas: 55, defectos: 11.0},
      %{confeccionista: "C07", linea: "L4", dia: 3, prendas: 75, defectos: 2.2},
      %{confeccionista: "C08", linea: "L1", dia: 3, prendas: 60, defectos: 1.5},
      %{confeccionista: "C09", linea: "L2", dia: 3, prendas: 140, defectos: 6.0},
      %{confeccionista: "C10", linea: "L3", dia: 3, prendas: 50, defectos: 3.0},
      %{confeccionista: "C02", linea: "L4", dia: 3, prendas: 60, defectos: 1.2},
      %{confeccionista: "C04", linea: "L2", dia: 3, prendas: 40, defectos: 4.0},
      %{confeccionista: "C07", linea: "L1", dia: 3, prendas: 50, defectos: 1.0},
      %{confeccionista: "C08", linea: "L3", dia: 3, prendas: 65, defectos: 2.5},
      %{confeccionista: "C10", linea: "L4", dia: 3, prendas: 80, defectos: 0.5},

      # Día 4
      %{confeccionista: "C01", linea: "L3", dia: 4, prendas: 80, defectos: 1.8},
      %{confeccionista: "C02", linea: "L4", dia: 4, prendas: 95, defectos: 2.5},
      %{confeccionista: "C03", linea: "L1", dia: 4, prendas: 60, defectos: 7.5},
      %{confeccionista: "C04", linea: "L2", dia: 4, prendas: 125, defectos: 1.0},
      %{confeccionista: "C05", linea: "L3", dia: 4, prendas: 70, defectos: 4.2},
      %{confeccionista: "C06", linea: "L4", dia: 4, prendas: 85, defectos: 3.0},
      %{confeccionista: "C07", linea: "L1", dia: 4, prendas: 105, defectos: 0.5},
      %{confeccionista: "C08", linea: "L2", dia: 4, prendas: 55, defectos: 9.0},
      %{confeccionista: "C09", linea: "L3", dia: 4, prendas: 65, defectos: 2.0},
      %{confeccionista: "C10", linea: "L4", dia: 4, prendas: 110, defectos: 1.5},
      %{confeccionista: "C01", linea: "L1", dia: 4, prendas: 45, defectos: 0.5},
      %{confeccionista: "C03", linea: "L2", dia: 4, prendas: 65, defectos: 2.5},
      %{confeccionista: "C05", linea: "L4", dia: 4, prendas: 55, defectos: 1.5},
      %{confeccionista: "C08", linea: "L3", dia: 4, prendas: 70, defectos: 1.0},
      %{confeccionista: "C09", linea: "L1", dia: 4, prendas: 60, defectos: 3.5},

      # Día 5
      %{confeccionista: "C01", linea: "L4", dia: 5, prendas: 140, defectos: 2.0},
      %{confeccionista: "C02", linea: "L1", dia: 5, prendas: 80, defectos: 5.0},
      %{confeccionista: "C03", linea: "L2", dia: 5, prendas: 95, defectos: 1.5},
      %{confeccionista: "C04", linea: "L3", dia: 5, prendas: 60, defectos: 8.5},
      %{confeccionista: "C05", linea: "L4", dia: 5, prendas: 115, defectos: 1.2},
      %{confeccionista: "C06", linea: "L1", dia: 5, prendas: 75, defectos: 3.8},
      %{confeccionista: "C07", linea: "L2", dia: 5, prendas: 100, defectos: 0.0},
      %{confeccionista: "C08", linea: "L3", dia: 5, prendas: 50, defectos: 14.0},
      %{confeccionista: "C09", linea: "L4", dia: 5, prendas: 85, defectos: 4.5},
      %{confeccionista: "C10", linea: "L1", dia: 5, prendas: 130, defectos: 2.5},
      %{confeccionista: "C02", linea: "L3", dia: 5, prendas: 45, defectos: 1.0},
      %{confeccionista: "C04", linea: "L4", dia: 5, prendas: 65, defectos: 2.0},
      %{confeccionista: "C06", linea: "L2", dia: 5, prendas: 50, defectos: 1.5},
      %{confeccionista: "C08", linea: "L1", dia: 5, prendas: 80, defectos: 0.5},
      %{confeccionista: "C09", linea: "L2", dia: 5, prendas: 40, defectos: 2.5},

      # Día 6
      %{confeccionista: "C01", linea: "L1", dia: 6, prendas: 60, defectos: 4.0},
      %{confeccionista: "C02", linea: "L2", dia: 6, prendas: 75, defectos: 1.5},
      %{confeccionista: "C03", linea: "L3", dia: 6, prendas: 100, defectos: 2.5},
      %{confeccionista: "C04", linea: "L4", dia: 6, prendas: 55, defectos: 6.0},
      %{confeccionista: "C05", linea: "L1", dia: 6, prendas: 140, defectos: 1.0},

      # Lotes inválidos (2 por cada motivo)

      # 1. :confeccionista_desconocido
      %{confeccionista: "C99", linea: "L1", dia: 1, prendas: 70, defectos: 1.5},
      %{confeccionista: "X01", linea: "L2", dia: 2, prendas: 50, defectos: 2.0},

      # 2. :linea_desconocida
      %{confeccionista: "C01", linea: "L9", dia: 3, prendas: 60, defectos: 1.0},
      %{confeccionista: "C02", linea: "L5", dia: 4, prendas: 80, defectos: 4.5},

      # 3. :dia_invalido
      %{confeccionista: "C03", linea: "L1", dia: 7, prendas: 90, defectos: 2.5},
      %{confeccionista: "C04", linea: "L2", dia: 0, prendas: 55, defectos: 1.2},

      # 4. :prendas_fuera_de_rango
      %{confeccionista: "C05", linea: "L3", dia: 5, prendas: 0, defectos: 3.0},
      %{confeccionista: "C06", linea: "L4", dia: 6, prendas: 185, defectos: 1.5},

      # 5. :porcentaje_invalido
      %{confeccionista: "C07", linea: "L1", dia: 1, prendas: 50, defectos: -1.5},
      %{confeccionista: "C08", linea: "L2", dia: 2, prendas: 70, defectos: 105.0}
    ]
  end

end
