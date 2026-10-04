defmodule Programa do
  @moduledoc """
  Módulo que agrupa las funciones de los demás archivos de código para el funcionamiento del código
  """
  @doc """
  Función main del programa
  """
  def main() do

  end

  @doc """
  Método que hace las validaciones usando el módulo Validacion y los separa en 2 listas: válidos y rechazados
  """
  defp validar_lotes(lotes, confeccionistas, lineas) do
    Enum.reduce(lotes, {[], []}, fn lote, {validos, rechazados} ->
      case Validacion.validar_lote(lote, confeccionistas, lineas) do
        {:ok, lote_valido} -> {[lote_valido | validos], rechazados}
        {:error, motivo} -> {validos, [{lote, motivo} | rechazados]}
      end
    end)
    |> ordenar_resultados()
  end

  @doc """
  Método que invierte las listas para que tengan su orden original
  """
  defp ordenar_resultados({validos, rechazados}) do
    {Enum.reverse(validos), Enum.reverse(rechazados)}
  end

end
