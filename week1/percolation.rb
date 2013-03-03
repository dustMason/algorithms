# coding: utf-8
require "rubygems"
require "bundler/setup"
require "rainbow"
require 'pry'

require './quick_find.rb'
require './weighted_union.rb'

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
