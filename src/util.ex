defmodule Util do
  @moduledoc """
  Módulo para las funciones de apoyo para entrada, salida y formato de valores
  """

  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error, mensaje)
  end

  def ingresar(mensaje, :texto) do
    mensaje
    |> IO.gets()
    |> texto_seguro()
  end

  def ingresar(mensaje, :entero) do
    case Integer.parse(ingresar(mensaje, :texto)) do
      {valor, ""} ->
        valor

      _ ->
        mostrar_error("Error, se espera que ingrese un numero entero")
        ingresar(mensaje, :entero)
    end
  end

  def ingresar(mensaje, :real) do
    case Float.parse(ingresar(mensaje, :texto)) do
      {valor, ""} ->
        valor

      _ ->
        mostrar_error("Error, se espera que ingrese un numero real")
        ingresar(mensaje, :real)
    end
  end

  @doc """
  Método para imprimir un encabezado
  """
  def titulo(texto) do
    IO.puts("\n#{texto}")
    IO.puts(String.duplicate("=", String.length(texto)))
  end

  @doc """
  Método para leer un lote adicional y lo convierte en mapa si su formato es correcto
  """
  def leer_lote_adicional do
    entrada = IO.gets("Ingrese un lote adicional (confeccionista;linea;dia;prendas;defectos)\no Enter para omitir: ")
    texto = texto_seguro(entrada)
    if texto == "" do
      :omitido
    else
      partes = String.split(texto, ";")
      if length(partes) != 5 do
        {:error, :formato_invalido}
      else
        [confeccionista, linea, dia_texto, prendas_texto, defectos_texto] = partes
        convertir_lote(confeccionista, linea, dia_texto, prendas_texto, defectos_texto)
      end
    end
  end

  @doc """
  Método para solicitar el codigo del confeccionista para el comprobante
  """
  def leer_codigo do
    entrada = IO.gets("\nIngrese el codigo del confeccionista para el comprobante: ")
    texto_seguro(entrada)
  end

  @doc """
  Método que formatea una cantidad monetaria con dos decimales
  """
  def dinero(valor) do
    :io_lib.format("$~.2f", [valor * 1.0]) |> IO.iodata_to_binary()
  end

  defp texto_seguro(nil), do: ""
  defp texto_seguro(texto), do: String.trim(texto)

  @doc """
  Método para convertir el lote en un formato legible en consola
  """
  defp convertir_lote(confeccionista, linea, dia_texto, prendas_texto, defectos_texto) do
    with {dia, ""} <- Integer.parse(String.trim(dia_texto)),
         {prendas, ""} <- Integer.parse(String.trim(prendas_texto)),
         {defectos, ""} <- Float.parse(String.trim(defectos_texto)) do
      {:ok,
       %{
         confeccionista: String.trim(confeccionista),
         linea: String.trim(linea),
         dia: dia,
         prendas: prendas,
         defectos: defectos
       }}
    else
      _ -> {:error, :formato_invalido}
    end
  end
end
