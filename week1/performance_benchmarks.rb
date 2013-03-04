require './percolation.rb' # <-- does bundler setup
require 'fruity'

compare do
  quick_find       { PercolationStats.new(20,100,QuickFind) }
  weighted_union   { PercolationStats.new(20,100,WeightedUnion) }
end
