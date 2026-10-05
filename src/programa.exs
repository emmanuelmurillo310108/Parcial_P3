defmodule Programa do
  @moduledoc """
  Módulo que agrupa las funciones de los demás archivos de código para el funcionamiento del código
  """

  @doc """
  Función main del programa
  """
  def main do
    confeccionistas = Datos.confeccionistas()
    lineas = Datos.lineas()
    lotes = Datos.lotes()
    {validos, rechazados} = validar_lotes(lotes, confeccionistas, lineas)
    Util.titulo("TALLER DE CONFECCIÓN")
    IO.puts("Lotes válidos: #{length(validos)}")
    IO.puts("Lotes rechazados: #{length(rechazados)}")
    {validos, rechazados} = procesar_lote_adicional(validos, rechazados, confeccionistas, lineas)
    Util.titulo("REPORTES")
    Reportes.r1(rechazados)
    Reportes.r2(lineas, validos)
    produccion = Reportes.r3(validos)
    liquidaciones = Liquidacion.liquidar(confeccionistas, validos)
    Reportes.r4(liquidaciones)
    Reportes.r5(confeccionistas, validos)
    Reportes.r6(confeccionistas, validos)
    Reportes.r7(liquidaciones, validos)
    Reportes.r8(confeccionistas, lineas, validos)
    ejecutar_investigacion(liquidaciones, produccion)
    ejecutar_comprobante(confeccionistas, validos)
  end

  @doc """
  Método para validar los lotes mediante las funciones del módulo Validacion
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
  Método para revertir la lista del método validar_lotes para que estén en su orden original
  """
  defp ordenar_resultados({validos, rechazados}) do
    {Enum.reverse(validos), Enum.reverse(rechazados)}
  end

  @doc """
  Método para generar el nuevo lote adicional ingresado por el usuario
  """
  defp procesar_lote_adicional(validos, rechazados, confeccionistas, lineas) do
    case Util.leer_lote_adicional() do
      :omitido -> IO.puts("Lote adicional omitido.")
        {validos, rechazados}
      {:error, :formato_invalido} -> IO.puts("Lote adicional rechazado: formato inválido.")
        {validos, rechazados}
      {:ok, lote} ->
        case Validacion.validar_lote(lote, confeccionistas, lineas) do
          {:ok, lote_valido} -> IO.puts("Lote adicional agregado correctamente.")
            {validos ++ [lote_valido], rechazados}
          {:error, motivo} -> IO.puts("Lote adicional rechazado: #{motivo}.")
            {validos, rechazados ++ [{lote, motivo}]}
        end
    end
  end

  @doc """
  Métodos para ejecutar la investigacion de ranking, mediciones, timer, etc (PUNTO C)
  """
  defp ejecutar_investigacion(liquidaciones, produccion) do
    IO.puts("\nRANKING")
    IO.inspect(Reportes.ranking(liquidaciones, []))
    IO.inspect(Reportes.ranking(liquidaciones, campo: :prendas, limite: 3))
    IO.inspect(Reportes.ranking(liquidaciones, orden: :asc, campo: :bruto))
    IO.puts("\nCOMBINACIÓN CON TALLER ALIADO")
    taller_aliado = %{1 => 550, 2 => 620, 3 => 480, 5 => 710, 7 => 200}
    IO.inspect(Reportes.combinar_talleres(produccion, taller_aliado))
    IO.puts("\nMEDICIONES")
    medir_busqueda()
    medir_construccion()
  end

  defp medir_busqueda do
    confeccionistas = Enum.map(1..100_000, fn n -> %{codigo: "C#{n}", nombre: "Persona #{n}"} end)
    mapa = Enum.into(confeccionistas, %{}, fn c -> {c.codigo, c} end)
    codigos = Enum.map(1..1_000, fn n -> "C#{rem(n * 97, 100_000) + 1}" end)
    tiempos_lista = Enum.map(1..3, fn _ -> {microsegundos, _} = :timer.tc(fn -> Enum.each(codigos, fn codigo -> Enum.find(confeccionistas, fn c -> c.codigo == codigo end) end) end)
      microsegundos
    end)
    tiempos_mapa = Enum.map(1..3, fn _ -> {microsegundos, _} = :timer.tc(fn -> Enum.each(codigos, fn codigo -> Map.get(mapa, codigo) end) end)
      microsegundos
    end)
    IO.puts("Búsqueda en lista (µs): #{inspect(tiempos_lista)}")
    IO.puts("Búsqueda en mapa (µs): #{inspect(tiempos_mapa)}")
  end

  defp medir_construccion do
    tiempos_final = Enum.map(1..3, fn _ ->
      {microsegundos, _} = :timer.tc(fn -> Enum.reduce(1..20_000, [], fn elemento, lista -> lista ++ [elemento] end) end)
      microsegundos
    end)
    tiempos_inicio = Enum.map(1..3, fn _ ->
      {microsegundos, _} = :timer.tc(fn -> Enum.reduce(1..20_000, [], fn elemento, lista -> [elemento | lista] end) end)
      microsegundos
    end)
    IO.puts("Construcción al final con ++ (µs): #{inspect(tiempos_final)}")
    IO.puts("Construcción al inicio con | (µs): #{inspect(tiempos_inicio)}")
  end

  @doc """
  Método para estructurar el comprobante mediante lo ingresado por el usuario
  """
  defp ejecutar_comprobante(confeccionistas, lotes_validos) do
    codigo = Util.leer_codigo()
    case Enum.find(confeccionistas, fn c -> c.codigo == codigo end) do
      nil -> IO.puts("El código no existe.")
      confeccionista -> Reportes.comprobante(confeccionista, lotes_validos)
    end
  end
end

Programa.main()
