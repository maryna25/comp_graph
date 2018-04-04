#!/usr/bin/env ruby

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Solver
  def initialize
    @points = [{ number: 1, point: Point.new(1,7) },
               { number: 2, point: Point.new(10,5) },
               { number: 3, point: Point.new(7,2) },
               { number: 4, point: Point.new(5,-1) },
               { number: 5, point: Point.new(0,0) },
               { number: 6, point: Point.new(6,-5) }]
    @lines = [[1, 5], [1, 2], [2, 5], [2, 3], [2, 6], [3, 5], [3, 4], [4, 5], [4, 6], [5, 6]]
    @z_point = Point.new(1.8, 2.6)
  end

  def prepare
    @points = @points.sort_by { |k| k[:point].y }
    @l = Array.new(@points.size)
    @points.each_with_index do |point, i|
      i > 0 ? @l[i] = @l[i-1].dup : @l[i] = Array.new
      downstream_edges(point).each { |e| @l[i].delete(e) }
      upstream_edges(point).each { |e| @l[i].push(e) }
      @l[i] = @l[i].sort_by{ |l| cross_x(l, point) }
    end
  end

  def find_pos
    line_index = line_search(@points.map { |p| p[:point].y }, @z_point.y)
    if line_index < 0 || line_index >= @points.size
      p 'out of the lines'
      return
    end
    p "line: #{@points[line_index][:number]}"

    edge = edge_search(@l[line_index], @z_point)
    if edge.nil?
      p "right to last edge at this line"
    else
      p "left to #{edge}"
    end
  end

  def line_search(arr, item)
    i = arr.size / 2
    while true do
      return -1 if i == 0 && arr[i] > item
      return arr.size if i >= arr.size - 1 && arr.last < item
      return i if arr[i] < item && arr[i+1] > item
      item < arr[i] ? i /= 2 : i = (arr.size + i) / 2
    end
  end

  def edge_search(arr, item)
    arr.each do |line|
      d = (item.x - point_x(line[0])) * (point_y(line[1]) - point_y(line[0])) -
          (item.y - point_y(line[0])) * (point_x(line[1]) - point_x(line[0]))
      return line if d > 0
    end
    nil
  end

  def downstream_edges(point)
    res = []
    @lines.each do |line|
      res << line if point[:number] == line[0] && @points.select { |p| p[:number] == line[1] }.first[:point].y < point[:point].y
      res << line if point[:number] == line[1] && @points.select { |p| p[:number] == line[0] }.first[:point].y < point[:point].y
    end
    res
  end

  def upstream_edges(point)
    res = []
    @lines.each do |line|
      res << line if point[:number] == line[0] && @points.select { |p| p[:number] == line[1] }.first[:point].y > point[:point].y
      res << line if point[:number] == line[1] && @points.select { |p| p[:number] == line[0] }.first[:point].y > point[:point].y
    end
    res
  end

  def point_x(index)
    @points.select { |p| p[:number] == index }.first[:point].x
  end

  def point_y(index)
    @points.select { |p| p[:number] == index }.first[:point].y
  end

  def cross_x(line, point)
    a = @points.select { |p| p[:number] == line[0] }.first[:point]
    b = @points.select { |p| p[:number] == line[1] }.first[:point]
    c = Point.new(point[:point].x - 100, point[:point].y)
    d = Point.new(point[:point].x + 100, point[:point].y)
    -((a.x*b.y-b.x*a.y)*(d.x-c.x)-(c.x*d.y-d.x*c.y)*(b.x-a.x))/((a.y-b.y)*(d.x-c.x)-(c.y-d.y)*(b.x-a.x))
  end
end

s = Solver.new
s.prepare
s.find_pos
