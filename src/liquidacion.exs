defmodule Liquidacion do
  @moduledoc """
  Módulo encargado de calcular valores de lotes, bonificaciones, alquileres y liquidaciones semanales
  """

  @doc """
  Parámetros establecidos
  """
  @tarifa_prenda 3200
  @umbral_bono 120
  @bono_diario 18000
  @alquiler_diario 15000

  @doc """
  Método para calcular el valor economico de un lote valido segun su porcentaje de defectos
  """
  def valor_lote(lote) do
    valor_base = lote.prendas * @tarifa_prenda
    cond do
      lote.defectos <= 2 -> valor_base * 1.07
      lote.defectos <= 5 -> valor_base
      lote.defectos <= 10 -> valor_base * 0.88
      true -> valor_base * 0.75
    end
  end

  @doc """
  Método para calcular la bonificacion diaria a partir de las prendas validas de un dia
  """
  def bonificacion_diaria(prendas) do
    if prendas >= @umbral_bono do
      @bono_diario
    else
      0
    end
  end

  @doc """
  Método para calcular el descuento por alquiler segun los dias trabajados
  """
  def descuento_alquiler(confeccionista, dias_trabajados) do
    if confeccionista.alquiler do
      length(Enum.uniq(dias_trabajados)) * @alquiler_diario
    else
      0
    end
  end

  @doc """
  Método para generar la liquidacion de todos los confeccionistas
  """
  def liquidar(confeccionistas, lotes_validos) do
    Enum.map(confeccionistas, fn confeccionista ->
      lotes =
        Enum.filter(lotes_validos, fn lote ->
          lote.confeccionista == confeccionista.codigo
        end)
      liquidar_confeccionista(confeccionista, lotes)
    end)
  end

  @doc """
  Método para acumular las prendas de los lotes por dia
  """
  defp acumular_prendas_por_dia(lotes) do
    Enum.reduce(lotes, %{}, fn lote, acumulador ->
      Map.update(acumulador, lote.dia, lote.prendas, fn prendas_actuales ->
        prendas_actuales + lote.prendas
      end)
    end)
  end

  @doc """
  Método para generar la liquidación de los confeccionistas agrupando valor base, bonificaciones, descuentos, etc
  """
  defp liquidar_confeccionista(confeccionista, lotes) do
    prendas_por_dia = acumular_prendas_por_dia(lotes)
    prendas = Enum.reduce(lotes, 0, fn lote, acumulador -> acumulador + lote.prendas end)
    valor_total_lotes =
      Enum.reduce(lotes, 0.0, fn lote, acumulador ->
        acumulador + valor_lote(lote)
      end)
    bonificaciones =
      Enum.reduce(prendas_por_dia, 0, fn {_dia, prendas_dia}, acumulador ->
        acumulador + bonificacion_diaria(prendas_dia)
      end)
    dias_trabajados = Map.keys(prendas_por_dia)
    alquiler = descuento_alquiler(confeccionista, dias_trabajados)
    neto = valor_total_lotes + bonificaciones - alquiler
    %{
      codigo: confeccionista.codigo,
      nombre: confeccionista.nombre,
      prendas: prendas,
      bruto: valor_total_lotes,
      bonificaciones: bonificaciones,
      alquiler: alquiler,
      neto: neto,
      dias: dias_trabajados,
      lotes: lotes
    }
  end
end
