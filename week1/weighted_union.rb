# see https://github.com/xajler/algorithms-rb/blob/master/lib/union-find/weighted_union.rb
class WeightedUnion
  attr_reader :ids, :sz
  def initialize(range)
    @ids = *(0..range)
    @sz = Array.new(range + 1, 1)
  end
  def connected?(first_node, second_node)
    root(first_node) == root(second_node)
  end
  def union(first_node, second_node)
    i = root(first_node)
    j = root(second_node)
    if sz[i] < sz[j]
      ids[i] = j
      sz[j] += sz[i]
    else
      ids[j] = i
      sz[i] += sz[j]
    end
  end
  private
  def root(index)
    while index != ids[index]
      index = ids[index]
    end
    index
  end
end

