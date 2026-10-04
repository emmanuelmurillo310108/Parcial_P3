defmodule Liquidacion do

  @moduledoc """
  Módulo que calcula los valores económicos, bonificaciones, alquiler, etc.
  """

  @doc """
  Parámetros establecidos
  """
  @tarifa_prenda 3200
  @umbral_bono 120
  @bono_diario 18000
  @alquiler_diario 15000

  @doc """
  Método para calcular el valor económico del lote.
  """
  defp calcular_valor_lote(lote) do
    valor_base = lote.prendas * @tarifa_prenda
    cond do
      lote.defectos <= 2 -> valor_base + (valor_base * 0.07)
      lote.defectos <= 5 -> valor_base
      lote.defectos <= 10 -> valor_base - (valor_base * 0.12)
      true -> valor_base - (valor_base * 0.25)
    end
  end

  @doc """
  Método para calcular el bono por prendas diario.
  """
  defp calcular_bono_diario(prendas) do
    if prendas >= @umbral_bono do
      @bono_diario
    else
      0
    end
  end

  @doc """
  Método para calcular el descuento por alquiler.
  """
  defp calcular_alquiler(confeccionista, dias_trabajados) do
    if confeccionista.alquiler do
      length(dias_trabajados) * @alquiler_diario
    else
      0
    end
  end

  @doc """
  Método para acumular las prendas hechas por día mediante el confeccionista y el lote.
  """
  defp acumular_prendas_por_dia(lotes) do
    Enum.reduce(lotes, %{}, fn lote, acumulador ->
      clave = {lote.confeccionista, lote.dia}
      Map.update(acumulador, clave, lote.prendas, fn prendas_actuales -> prendas_actuales + lote.prendas end) end)
  end

  @doc """
  Método para calcular la liquidación de cada confeccionista.
  """
  defp liquidar_confeccionista(confeccionista, lotes) do
    prendas_por_dia = acumular_prendas_por_dia(lotes)
    prendas = Enum.reduce(lotes, 0, fn lote, acumulador -> acumulador + lote.prendas end)
    valor_total_lotes = Enum.reduce(lotes, 0, fn lote, acumulador -> acumulador + calcular_valor_lote(lote) end)
    bonificaciones = Enum.reduce(prendas_por_dia, 0, fn {_clave, prendas_dia}, acumulador -> acumulador + calcular_bono_diario(prendas_dia) end)
    dias_trabajados = Enum.map(prendas_por_dia, fn {{_codigo, dia}, _prendas} -> dia end)
    alquiler = calcular_alquiler(confeccionista, dias_trabajados)
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
