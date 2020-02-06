module Enumerable
  def my_each
    i = 0
    while i < self.size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    (self.size - 1).times do |i|
      yield(self[i], i)
    end
    self
  end

  def my_select
    item = []
    self.my_each do |i|
      item << i if yield(i)
    end
    item
  end

  def my_all?
    result = true
    self.my_each { |item| result = false unless yield(item) }
    return result
  end

  def my_any?
    result = false
    self.my_each { |item| result = true if yield(item) }
    return result
  end

  def my_none?
    result = true
    self.my_each { |item| result = false if yield(item) }
    return result
  end

  def my_count(*args, &block)
    count = 0

    self.my_each do |i|
      if args.empty? && !block_given?
        count += 1
      elsif block_given?
        count += 1 if yield(i)
      else
        count += 1 if i.include? args
      end
    end

    return count
  end

  def my_map
    arr = []

    self.my_each do |i|
      arr << yield(i)
    end

    arr
  end

  def my_inject(initial = nil?)
    if initial == nil?
      total = self.first
    else
      total = initial
    end

    self.my_each do |element|
      total = yield(total, element)
    end
    return total
  end

  def multiply_els(items)
    return items.my_inject(1) { |a, b| a * b }
  end

  def my_map_proc(proc)
    arr = []

    self.my_each do |i|
      if proc && block_given?
        arr << proc.call(yield(i))
      else
        arr << proc.call(i)
      end
    end
    arr
  end
end
