require './percolation.rb' # <-- does bundler setup
require 'googlecharts'

#stats = PercolationStats.new(20,1000,QuickFind)
#puts stats.mean

# for QuickFind:
# line chart indicating running times as N increases
# line chart indicating running times as T increases
# for WeightedUnion:
# line chart indicating running times as N increases
# line chart indicating running times as T increases


class PercolationTester

  def initialize(algo)
    @algo = algo
  end

  def perf_test_n(times)
    res = []
    times.times do |e|
      t = Time.now
      PercolationStats.new(2**e,100,@algo)
      res << Time.new - t
    end
    res
  end

  def perf_test_t(times)
    res = []
    times.times do |e|
      t = Time.now
      PercolationStats.new(20,2**e,@algo)
      res << Time.new - t
    end
    res
  end

end

#qf_tester = PercolationTester.new(QuickFind)
#puts qf_tester.perf_test_n(7).inspect
#puts qf_tester.perf_test_t(10).inspect
#wu_tester = PercolationTester.new(WeightedUnion)
#puts wu_tester.perf_test_n(9).inspect
#puts wu_tester.perf_test_t(10).inspect

inputs = (1..7).to_a.map { |n| 2**n }

ptn_qf = [0.000379, 0.000649, 0.004889, 0.036519, 0.426412, 5.908406, 91.107423] # perf_test_n w/ QuickFind
#ptt_qf = [0.008672, 0.019565, 0.041194, 0.074397, 0.161241, 0.322445, 0.633292] # perf_test_t w/ QuickFind
ptt_qf = [0.009804, 0.018587, 0.040857, 0.080615, 0.157072, 0.324166, 0.621847, 1.249026, 2.462411, 4.906471]
ptn_wu = [0.000629, 0.000799, 0.004305, 0.02219, 0.05807, 0.235989, 0.952221, 3.85831, 15.518828] # perf_test_n w/ WeightedUnion
#ptt_wu = [0.001199, 0.002014, 0.003655, 0.006975, 0.01432, 0.029328, 0.058931, 0.117929, 0.238232] # perf_test_t w/ WeightedUnion
ptt_wu = [0.001154, 0.001809, 0.003414, 0.007034, 0.014344, 0.027241, 0.057131, 0.112243, 0.226761, 0.451679]


#url = Gchart.line(
  #:size => '500x300',
  #:title => "QuickFind vs. WeightedUnion Running Time as N doubles",
  #:bar_colors => ['FF0000', '00FF00'],
  #:axis_with_labels => 'x,y',
  #:legend => ["QuickFind", "WeightedUnion"],
  #:axis_labels => [inputs,(1..3).to_a],
  #:data => [ptn_qf, ptn_wu.take(7)], max_value: 3
#)
#`open "#{url}"`
# http://chart.apis.google.com/chart?chxl=0:%7C2%7C4%7C8%7C16%7C32%7C64%7C128%7C1:%7C1%7C2%7C3&chxt=x,y&chco=FF0000,00FF00&chd=s:AAAAI99,AAAABET&chdl=QuickFind%7CWeightedUnion&chtt=QuickFind+vs.+WeightedUnion+Running+Time+as+N+doubles&cht=lc&chs=500x300&chxr=0,0.000379,3%7C1,0.000629,3

#url = Gchart.line(
  #:size => '500x300',
  #:title => "QuickFind vs. WeightedUnion Running Time as T doubles",
  #:bar_colors => ['FF0000', '00FF00'],
  #:axis_with_labels => 'x,y',
  #:legend => ["QuickFind", "WeightedUnion"],
  #:axis_labels => [inputs,(1..5).to_a],
  #:data => [ptt_qf, ptt_wu], max_value: 5
#)
#`open "#{url}"`
#http://chart.apis.google.com/chart?chxl=0:%7C2%7C4%7C8%7C16%7C32%7C64%7C128%7C1:%7C1%7C2%7C3%7C4%7C5&chxt=x,y&chco=FF0000,00FF00&chd=s:AAAABEHPe8,AAAAAAABCF&chdl=QuickFind%7CWeightedUnion&chtt=QuickFind+vs.+WeightedUnion+Running+Time+as+T+doubles&cht=lc&chs=500x300&chxr=0,0.009804,5%7C1,0.001154,5
