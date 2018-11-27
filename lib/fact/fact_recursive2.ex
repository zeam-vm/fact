defmodule Fact.FactRecursive2 do
  def factorization(n) do
    factorization1(n) |> compress
  end

  def compress(ls) do
    Enum.chunk_by(ls,fn(n) -> n end)
    |> Enum.map(fn(x) -> [hd(x),length(x)] end)
    |> Enum.reverse
  end

  def factorization1(n) do
    factor([],n,2,trunc(:math.sqrt(n)))
  end

  def factor(p,n,x,limit) do
    cond do
      n == 1 -> p
      x > limit -> [n|p]
      rem(n,x) == 0 -> factor([x|p],div(n,x),x,limit)
      x == 2 -> factor(p,n,3,limit)
      true -> factor(p,n,x+2,limit)
    end
  end

  def info() do
  	"#{__MODULE__}: factorization using recursive calls in factor and Enum in compress"
  end

  def benchmark() do
  	factorization(11_111)
  end
end