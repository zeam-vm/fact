defmodule Fact do

  @on_load :on_load
  
  @benchmarks [
      {&Fact.FactRecursive1.info/0, &Fact.FactRecursive1.benchmark/0},
      {&Fact.FactRecursive2.info/0, &Fact.FactRecursive2.benchmark/0},
      {&Fact.FactStream1.info/0,    &Fact.FactStream1.benchmark/0},
      {&Fact.FactStream2.info/0,    &Fact.FactStream2.benchmark/0},
      {&Fact.FactStream3.info/0,    &Fact.FactStream3.benchmark/0},
  ]

  def on_load() do
    case :mnesia.start do
      :ok -> case :mnesia.create_table( :verify, [ attributes: [ :id, :fact] ] ) do
        {:atomic, :ok} -> :ok
        _ -> :err
      end
      _ -> :err
    end
  end

  def all_benchmarks() do
    @benchmarks
    |> Enum.map(fn {info, benchmark} ->
      IO.puts info.()

      {time, result} = :timer.tc(benchmark)

      case :mnesia.dirty_read(:verify, self()) do
      [] -> :mnesia.dirty_write({:verify, self(), result})
      [{:verify, _pid, verify}] -> if verify != result do
          IO.puts "verify error."
        end
      end

      IO.puts "#{:erlang.float_to_binary(time / 1_000_000, [decimals: 6])} sec."
    end)
  end
end
