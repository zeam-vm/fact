defmodule Fact.FactStream3 do
  @on_load :on_load

  def on_load() do
    case :mnesia.start do
      :ok -> case :mnesia.create_table( :factor, [ attributes: [ :id, :n, :limit] ] ) do
        {:atomic, :ok} -> :ok
        _ -> :err
      end
      _ -> :err
    end
  end

  def factorization(n) do
    :mnesia.dirty_write({:factor, self(), n, div(n, 2)})
    result = Stream.unfold(2, fn
      2 -> {2, 3}
      m -> {m, m + 2}
    end)
    |> Stream.take_while(& reach_limit?(&1))
    |> Stream.filter(& rem0?(&1))
    |> Stream.map(& [&1, count_div(n, &1)])
    |> Enum.to_list()

    if length(result) == 0 do
      [[n, 1]]
    else
      result
    end
  end

  defp reach_limit?(x) do
    [{:factor, _pid, _n, limit}] = :mnesia.dirty_read({:factor, self()})
    x <= limit
  end

  defp rem0?(x) do
    [{:factor, _pid, n, _limit}] = :mnesia.dirty_read({:factor, self()})
    result = (rem(n, x) == 0)
    if result do 
      n = div_all(n, x)     
      :mnesia.dirty_write({:factor, self(), n, n})
    end
    result
  end

  defp loop_div(n, x) do
    Stream.unfold(n, fn
      1 -> nil
      n -> {n, div(n, x)}
    end)
    |> Stream.take_while(& (rem(&1, x) == 0))
  end

  defp div_all(n, x) do
    loop_div(n, x) |> Enum.at(-1) |> div(x)
  end

  defp count_div(n, x) do
    loop_div(n, x) |> Enum.count
  end
  
  def info() do
  	"#{__MODULE__}: factorization using Stream that generates numbers while half of the target number or that divided by founded factor"
  end

  def benchmark() do
  	factorization(11_111)
  end
end