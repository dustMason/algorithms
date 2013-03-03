# see https://github.com/mluckeneder/Union-Find-Ruby/blob/master/quick-union.rb
class QuickFind
  def initialize(n)
    @ids = (0..n-1).to_a
  end
  def connected?(id1,id2)
    @ids[id1] == @ids[id2]
  end
  def union(id1,id2)
    id_1, id_2 = @ids[id1], @ids[id2]
    @ids.map! {|i| (i == id_1) ? id_2 : i }
  end
end

