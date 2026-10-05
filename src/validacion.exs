defmodule Validacion do
  @moduledoc """
  Módulo que se encarga de validar los lotes de producción según las reglas del negocio
  """
  
  @doc """
  Método para validar si existe el confeccionista mediante su código
  """
  defp validar_confeccionista(codigo, confeccionistas) do
    if Enum.any?(confeccionistas, fn c -> c.codigo == codigo end) do
      {:ok, codigo}
    else
      {:error, :confeccionista_desconocido}
    end
  end

  @doc """
  Método para validar si existe la línea mediante su número de id
  """
  defp validar_linea(id, lineas) do
    if Enum.any?(lineas, fn l -> l.id == id end) do
      {:ok, id}
    else
      {:error, :linea_desconocida}
    end
  end

  @doc """
  Método para validar si el día está dentro de los parámetros establecidos
  """
  defp validar_dia(dia) do
    cond do
      not is_integer(dia) -> {:error, :dia_invalido}
      dia < 1 -> {:error, :dia_invalido}
      dia > 6 -> {:error, :dia_invalido}
      true -> {:ok, dia}
    end
  end

  @doc """
  Método para validar si el número de prendas está dentro del rango
  """
  defp validar_prendas(prendas) do
    cond do
      not is_integer(prendas) -> {:error, :prendas_fuera_de_rango}
      prendas < 1 -> {:error, :prendas_fuera_de_rango}
      prendas > 180 -> {:error, :prendas_fuera_de_rango}
      true -> {:ok, prendas}
    end
  end

  @doc """
  Método para validar si el porcentaje de defectos está dentro del rango
  """
  defp validar_porcentaje_defectos(defectos) do
    cond do
      not is_number(defectos) -> {:error, :porcentaje_invalido}
      defectos < 0 -> {:error, :porcentaje_invalido}
      defectos > 100 -> {:error, :porcentaje_invalido}
      true -> {:ok, defectos}
    end
  end

  @doc """
  Método para validar el lote aplicando las 5 reglas establecidas
  """
  def validar_lote(lote, confeccionistas, lineas) do
    with {:ok, _} <- validar_confeccionista(lote.confeccionista, confeccionistas),
         {:ok, _} <- validar_linea(lote.linea, lineas),
         {:ok, _} <- validar_dia(lote.dia),
         {:ok, _} <- validar_prendas(lote.prendas),
         {:ok, _} <- validar_porcentaje_defectos(lote.defectos) do
      {:ok, lote}
    else
      {:error, motivo} -> {:error, motivo}
    end
  end
end
