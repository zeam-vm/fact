defmodule Fact.FactRecursive1 do
  def factorization(n) do
    factorization1(n) |> compress
  end

  def compress([1,l|ls]) do compress1(ls,l,1,[]) end
  def compress([l|ls]) do compress1(ls,l,1,[]) end

  def compress1([],p,n,mult) do [[p,n]|mult] end
  def compress1([p|ls],p,n,mult) do compress1(ls,p,n+1,mult) end
  def compress1([l|ls],p,n,mult) do compress1(ls,l,1,[[p,n]|mult]) end

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
  	"#{__MODULE__}: factorization using recursive calls in compress and factor"
  end

  def benchmark() do
  	factorization(11_111)
  end
end