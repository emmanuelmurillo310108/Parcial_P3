defmodule Reportes do
  @moduledoc """
  Módulo para generar los reportes
  """

  @meta 600

  @doc """
  Método para generar R1: Lotes rechazados
  """
  def r1(lotes_rechazados) do
    motivos = [
      :confeccionista_desconocido,
      :linea_desconocida,
      :dia_invalido,
      :prendas_fuera_de_rango,
      :porcentaje_invalido
    ]
    IO.puts("R1: LOTES RECHAZADOS")
    Enum.each(lotes_rechazados, fn {lote, motivo} -> IO.puts("#{inspect(lote)} -> #{motivo}") end)
    IO.puts("Cantidad de rechazos por motivo:")
    Enum.each(motivos, fn motivo -> cantidad = Enum.count(lotes_rechazados, fn {_lote, m} -> m == motivo end)
      IO.puts("#{motivo}: #{cantidad}")
    end)
  end

  @doc """
  Método para generar R2: prendas elaboradas y productividad por línea
  """
  def r2(lineas, lotes_validos) do
    datos =
      Enum.map(lineas, fn linea -> prendas = Enum.reduce(lotes_validos, 0, fn lote, acc ->
          if lote.linea == linea.id, do: acc + lote.prendas, else: acc
        end)
        %{id: linea.id, nombre: linea.nombre, puestos: linea.puestos, prendas: prendas,
          productividad: prendas / linea.puestos}
      end)
      |> Enum.sort_by(fn linea -> linea.productividad end, :desc)
    IO.puts("R2: PRODUCCIÓN POR LÍNEA Y PRODUCTIVIDAD")
    Enum.each(datos, fn dato -> IO.puts("#{dato.nombre} (#{dato.id}) - Prendas: #{dato.prendas} - Productividad: #{Float.round(dato.productividad, 2)}") end)
    datos
  end

  @doc """
  Método para generar R3: producción diaria y cumplimiento de meta
  """
  def r3(lotes_validos) do
    produccion =
      Enum.reduce(1..6, %{}, fn dia, acc -> total = Enum.reduce(lotes_validos, 0, fn lote, suma ->
          if lote.dia == dia, do: suma + lote.prendas, else: suma
        end)
        Map.put(acc, dia, total)
      end)
    IO.puts("R3: PRODUCCIÓN DIARIA")
    Enum.each(1..6, fn dia ->
      total = Map.get(produccion, dia)
      estado = if total >= @meta, do: "Sí", else: "No"
      IO.puts("Día #{dia}: #{total} prendas || Meta alcanzada: #{estado}")
    end)
    valores = Map.values(produccion)
    todos = Enum.all?(valores, fn total -> total >= @meta end)
    alguno = Enum.any?(valores, fn total -> total >= @meta end)
    IO.puts("¿Se alcanzó la meta todos los días?: #{todos}")
    IO.puts("¿Se alcanzó la meta al menos un día?: #{alguno}")
    produccion
  end

  @doc """
  Método para generar R4: liquidación ordenada por neto descendente
  """
  def r4(liquidaciones) do
    liquidaciones_ordenadas = Enum.sort_by(liquidaciones, fn l -> l.neto end, :desc)
    IO.puts("R4: LIQUIDACIÓN")
    Enum.with_index(liquidaciones_ordenadas, 1)
    |> Enum.each(fn {l, i} ->
      IO.puts("#{i}. #{l.nombre} (#{l.codigo})")
      IO.puts("   Prendas: #{l.prendas} | Valor lotes: #{Util.dinero(l.bruto)}")
      IO.puts("   Bonificaciones: #{Util.dinero(l.bonificaciones)} | Alquiler: #{Util.dinero(l.alquiler)}")
      IO.puts("   Neto: #{Util.dinero(l.neto)}")
    end)
    liquidaciones_ordenadas
  end

  @doc """
  Método para generar R5: líder de producción de cada día y ganador semanal
  """
  def r5(confeccionistas, lotes_validos) do
    IO.puts("R5: MAYOR PRODUCCIÓN POR DÍA")
    ganadores =
      Enum.reduce(1..6, %{}, fn dia, acc ->
        cantidades =
          Enum.map(confeccionistas, fn c -> prendas = Enum.reduce(lotes_validos, 0, fn lote, suma ->
              if lote.confeccionista == c.codigo and lote.dia == dia, do: suma + lote.prendas, else: suma
            end)
            {c, prendas}
          end)
          |> Enum.filter(fn {_c, prendas} -> prendas > 0 end)
        if cantidades == [] do
          IO.puts("Día #{dia}: sin lotes válidos")
          acc
        else
          maximo = Enum.max_by(cantidades, fn {_c, prendas} -> prendas end) |> elem(1)
          mejores = Enum.filter(cantidades, fn {_c, prendas} -> prendas == maximo end)
          nombres = Enum.map(mejores, fn {c, _} -> c.nombre end)
          IO.puts("Día #{dia}: #{Enum.join(nombres, ", ")} - #{maximo} prendas")
          Enum.reduce(mejores, acc, fn {c, _}, mapa ->
            Map.update(mapa, c.codigo, 1, fn n -> n + 1 end)
          end)
        end
      end)
    if ganadores == %{} do
      IO.puts("No hubo días con producción válida")
    else
      maximo = Map.values(ganadores) |> Enum.max()
      codigos = Enum.filter(ganadores, fn {_codigo, veces} -> veces == maximo end) |> Enum.map(fn {codigo, _} -> codigo end)
      nombres = Enum.map(codigos, fn codigo -> Enum.find(confeccionistas, fn c -> c.codigo == codigo end).nombre end)
      IO.puts("Primer lugar más días: #{Enum.join(nombres, ", ")} - #{maximo} día(s)")
    end
    ganadores
  end

  @doc """
  Método para generar R6: confeccionista con menor porcentaje de defectos ponderado
  """
  def r6(confeccionistas, lotes_validos) do
    candidatos =
      Enum.map(confeccionistas, fn c ->
        lotes = Enum.filter(lotes_validos, fn lote -> lote.confeccionista == c.codigo end)
        prendas = Enum.reduce(lotes, 0, fn lote, acc -> acc + lote.prendas end)
        ponderado =
          if prendas == 0 do
            nil
          else
            suma = Enum.reduce(lotes, 0.0, fn lote, acc -> acc + lote.defectos * lote.prendas end)
            suma / prendas
          end
        {c, length(lotes), ponderado}
      end)
      |> Enum.filter(fn {_c, cantidad, _p} -> cantidad >= 3 end)
    IO.puts("R6: MEJOR CALIDAD")
    if candidatos == [] do
      IO.puts("Ningún confeccionista cumple el mínimo de 3 lotes válidos")
      []
    else
      minimo = Enum.min_by(candidatos, fn {_c, _cantidad, porcentaje} -> porcentaje end) |> elem(2)
      mejores = Enum.filter(candidatos, fn {_c, _cantidad, porcentaje} -> porcentaje == minimo end)
      Enum.each(mejores, fn {c, cantidad, porcentaje} ->
        IO.puts("#{c.nombre} (#{c.codigo}) - #{cantidad} lotes - Defectos ponderados: #{Float.round(porcentaje, 2)}%")
      end)
      mejores
    end
  end

  @doc """
  Método para generar R7: total pagado y costo promedio por prenda válida
  """
  def r7(liquidaciones, lotes_validos) do
    total_pagado = Enum.reduce(liquidaciones, 0.0, fn l, acc -> acc + l.neto end)
    total_prendas = Enum.reduce(lotes_validos, 0, fn lote, acc -> acc + lote.prendas end)
    IO.puts("R7. TOTAL Y COSTO PROMEDIO")
    IO.puts("Total que debe pagar el taller: #{Util.dinero(total_pagado)}")
    if total_prendas == 0 do
      IO.puts("El promedio no puede calcularse.")
      %{total: total_pagado, prendas: total_prendas, promedio: nil}
    else
      promedio = total_pagado / total_prendas
      IO.puts("Costo promedio por prenda válida: #{Util.dinero(promedio)}")
      %{total: total_pagado, prendas: total_prendas, promedio: promedio}
    end
  end

  @doc """
  Método para generar R8: confeccionistas que trabajaron en todas las líneas
  """
  def r8(confeccionistas, lineas, lotes_validos) do
    ids_lineas = Enum.map(lineas, fn linea -> linea.id end)
    resultado =
      Enum.filter(confeccionistas, fn c ->
        ids_trabajadas =
          lotes_validos
          |> Enum.filter(fn lote -> lote.confeccionista == c.codigo end)
          |> Enum.map(fn lote -> lote.linea end)
          |> Enum.uniq()
        Enum.all?(ids_lineas, fn id -> id in ids_trabajadas end)
      end)
    IO.puts("R8. TODAS LAS LÍNEAS")
    if resultado == [] do
      IO.puts("No hay confeccionistas que hayan trabajado en todas las líneas.")
    else
      Enum.each(resultado, fn c -> IO.puts("#{c.nombre} (#{c.codigo})") end)
    end
    resultado
  end

  @doc """
  Método para ordenar liquidaciones según opciones de KEYWORD LIST
  """
  def ranking(liquidaciones, opciones) do
    campo = Keyword.get(opciones, :campo, :neto)
    orden = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite, nil)
    ordenadas = Enum.sort_by(liquidaciones, fn l -> Map.get(l, campo) end, orden)
    case limite do
      nil -> ordenadas
      n when is_integer(n) and n > 0 -> Enum.take(ordenadas, n)
      _ -> ordenadas
    end
  end

  @doc """
  Método para combinar la producción propia y la de un taller aliado usando Map.merge
  """
  def combinar_talleres(produccion, taller_aliado) do
    Map.merge(produccion, taller_aliado, fn _dia, propia, aliada -> propia + aliada end)
  end

  @doc """
  Método para mostrar el comprobante individual de un confeccionista
  """
  def comprobante(confeccionista, lotes_validos) do
    lotes = Enum.filter(lotes_validos, fn lote -> lote.confeccionista == confeccionista.codigo end)
    IO.puts("\nCOMPROBANTE INDIVIDUAL")
    IO.puts("#{confeccionista.nombre} - #{confeccionista.codigo}")
    Enum.each(1..6, fn dia ->
      lotes_dia = Enum.filter(lotes, fn lote -> lote.dia == dia end)
      if lotes_dia != [] do
        prendas = Enum.reduce(lotes_dia, 0, fn lote, acc -> acc + lote.prendas end)
        valor = Enum.reduce(lotes_dia, 0.0, fn lote, acc -> acc + Liquidacion.valor_lote(lote) end)
        bonificacion = Liquidacion.bonificacion_diaria(prendas)
        IO.puts("Día #{dia}: prendas=#{prendas}, valor=#{Util.dinero(valor)}, bonificación=#{Util.dinero(bonificacion)}")
      end
    end)
    bruto = Enum.reduce(lotes, 0.0, fn lote, acc -> acc + Liquidacion.valor_lote(lote) end)
    bonificaciones =
      Enum.reduce(1..6, 0.0, fn dia, acc ->
        prendas = Enum.reduce(lotes, 0, fn lote, suma -> if lote.dia == dia, do: suma + lote.prendas, else: suma end)
        acc + Liquidacion.bonificacion_diaria(prendas)
      end)
    dias = Enum.map(lotes, fn lote -> lote.dia end) |> Enum.uniq()
    alquiler = Liquidacion.descuento_alquiler(confeccionista, dias)
    neto = bruto + bonificaciones - alquiler
    IO.puts("Suma de lotes: #{Util.dinero(bruto)}")
    IO.puts("Suma de bonificaciones: #{Util.dinero(bonificaciones)}")
    IO.puts("Descuento por alquiler: #{Util.dinero(alquiler)}")
    IO.puts("Neto: #{Util.dinero(neto)}")
  end
end
