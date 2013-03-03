# coding: utf-8
require "rubygems"
require "bundler/setup"
require "rainbow"
require 'pry'

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

class Percolation

  # create N-by-N grid, with all sites blocked
  def initialize(n,qf)
    @grid = qf.new (n*n)+2 # account for 2 virtual sites
    @width = n
    @open_sites = []
    @last = (@width*@width)-1
    connect_virtual_sites
  end

  # open site (row i, column j) if it is not already
  def open(x,y)
    n = get_index(x,y)
    @open_sites[n] = true

    top = get_index(x, y-1);
    bot = get_index(x, y+1);
    left = get_index(x-1, y);
    right = get_index(x+1, y);

    #// Union to all open sites around site
    union(n, top) if (y != 0 && is_open?(x, y-1))
    union(n, bot) if (y != @width-1 && is_open?(x, y+1))
    union(n, left) if (x != 0 && is_open?(x-1, y))
    union(n, right) if (x != @width-1 && is_open?(x+1, y))
    # union(n, 0) if (x == 1)

  end

  # is site (row i, column j) open?
  def is_open?(x,y)
    @open_sites[get_index(x,y)]
  end

  # is site (row i, column j) full?
  def is_full?(i,j)
    @grid.connected? 0,get_index(i,j)+1 # offest by 1 for the virtual sites
  end

  def percolates?
    @grid.connected? 0,@last+1
  end

  def print
    @width.times do |j|
      @width.times do |i|
        Kernel.print pb(site_state(i,j))
      end
      puts ""
    end
  end

  private

  def site_state(x,y)
    is_open?(x,y) ? is_full?(x,y) ? :active : :open : :blocked
  end

  def connect_virtual_sites
    (1..@width-1).each { |n| @grid.union 0,n } # top one
    ((@last-@width)..@last).each { |n| @grid.union n,@last+1 } # bottom one
  end

  def get_index(x,y)
    (y * @width) + x
  end

  # account for the virtual site on top
  def union(a,b)
    @grid.union(a+1, b+1)
  end

  def pb(state)
    case state
    when :open
      "  ".color :white
    when :blocked
      "▩ ".color :white
    when :active
      "▩ ".color :red
    end
  end

end

#t = Time.now
#1000.times do
  #perco = Percolation.new(20,WeightedUnion)
  ##perco = Percolation.new(20,QuickFind)
  #300.times do |n|
    #perco.open((0..19).to_a.sample, (0..19).to_a.sample)
  #end
  #perco.print
  #puts "-"*40
  ##puts perco.percolates?
#end
#puts t - Time.now

class PercolationStats
  def initialize(n,t,uf=WeightedUnion)
    #// perform T independent computational experiments on an N-by-N grid
    sites = (0..(n*n)-1).to_a
    @size = n
    @times = t
    @results = []
    t.times do
      sites_to_try = sites.sample(sites.size)
      counter = 0
      p = Percolation.new(n,uf)
      until p.percolates?
        site = sites_to_try.at(counter)
        x = (site) % n
        y = (site) / n # implied floor since we're using ints
        counter += 1
        p.open(x, y)
      end
      @results << counter
    end
  end
  def mean
    #// sample mean of percolation threshold
    avg = @results.reduce(&:+)/(@results.size * 1.0)
    avg / (@size*@size)
  end
  def stddev
    #// sample standard deviation of percolation threshold
  end
  def confidenceLo
    #// returns lower bound of the 95% confidence interval
  end
  def confidenceHi
    #// returns upper bound of the 95% confidence interval
  end
end

#stats = PercolationStats.new(20,1000)
#puts stats.mean
