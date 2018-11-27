defmodule Fact.FactStream1 do
  def factorization(n) do
    result = Stream.unfold(2, fn
      2 -> {2, 3}
      m -> {m, m + 2}
    end)
    |> sieve()
    |> Stream.take_while(& (&1 <= div(n, 2) ))
    |> Stream.filter(& (rem(n, &1) == 0))
    |> Stream.map(& [&1, count_div(n, &1)])
    |> Enum.to_list()

    if length(result) == 0 do
      [[n, 1]]
    else
      result
    end
  end

  def sieve(seq) do
    Stream.unfold(seq, fn s ->
      p    = s |> Enum.at(0)
      next = s |> Stream.filter(fn x -> rem(x, p) != 0 end)
      {p, next}
    end)
  end

  def count_div(n, x) do
    Stream.unfold(n, fn
      1 -> nil
      n -> {n, div(n, x)}
    end)
    |> Stream.take_while(& (rem(&1, x) == 0))
    |> Enum.count
  end

  def info() do
  	"#{__MODULE__}: factorization using Stream that generates every prime numbers while half of the target number without dividing the target number"
  end

  def benchmark() do
  	factorization(11_111)
  end
end