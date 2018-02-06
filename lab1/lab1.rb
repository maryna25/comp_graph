#!/usr/bin/env ruby
require 'matrix'

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Solver
  def initialize
    @points = [Point.new(0,0), Point.new(1,4), Point.new(4.5,4), Point.new(7,0), Point.new(5,-4), Point.new(2,-4)]
    # @z_point = Point.new(3.0, -10) #false
    # @z_point = Point.new(5.0, -1) #true
    # @z_point = Point.new(3.0, 4) #false
    @z_point = Point.new(1.8, 2.6) #true center of figure
  end

  def find_center
    x = (@points[0].x + @points[1].x + @points[2].x) / 3.0
    y = (@points[0].y + @points[1].y + @points[2].y) / 3.0

    Point.new(x, y)
  end

  def determ(arr)
    Matrix.rows(arr).determinant
  end

  def find_pi
    @q_point = find_center
    (0...(@points.size - 1)).each do |i|
      return i if determ([[@z_point.x,@z_point.y,1],[@q_point.x,@q_point.y,1],[@points[i+1].x,@points[i+1].y,1]]) > 0 &&
                  determ([[@z_point.x,@z_point.y,1],[@q_point.x,@q_point.y,1],[@points[i].x,@points[i].y,1]]) < 0
    end
    return @points.size - 1
  end

  def inside?
    i = find_pi
    i == @points.size - 1 ? j = 0 : j = i + 1
    determ([[@points[i].x,@points[i].y,1],[@points[j].x,@points[j].y,1],[@z_point.x,@z_point.y,1]]) < 0
  end
end

s = Solver.new
p s.inside?
