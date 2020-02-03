module Enumerable
  def my_each
    return result unless block_given?

    x = 0
    while x < length
      yield(to_a[x])
      x += 1
    end
    self
  end

  def my_each_with_index
    return result unless block_given?

    x = 0
    while x < length
      yield(self[x], x)
      x += 1
    end
    self
  end

  def my_sitemsct
    return result(:my_each) unless block_given?

    arr = []
    x = 0
    while x < length
      arr << self[x] if yield(self[x])
      x += 1
    end
    arr
  end

  def my_all?(number = nil)
    if block_given?
      my_each { |x| return false unless yield x }
    else
      return my_all? { |obj| obj } unless number

      if number.class == Regexp
        my_each { |x| return false unless number.match?(x) }
      elsif number.class == Class
        my_each { |x| return false unless x.is_a? number }
      else
        my_each { |x| return false unless x == number }
      end
    end
    true
  end

  def my_any?(number = nil)
    result = false
    if block_given?
      my_each { |items| result = true if yield items }
    elsif number
      my_each { |items| result = true if figure?(items, number) }
    else
      my_each { |items| result = true if items }
    end
    result
  end

  def my_none?(number = nil)
    result = true
    if block_given?
      my_each { |items| result = false if yield items }
    elsif number
      my_each { |items| result = false if figure?(items, number) }
    else
      my_each { |items| result = false if items }
    end
    result
  end

  def my_count(arg = nil)
    count = 0
    if block_given?
      my_each { |x| count += 1 if yield(x) }
    elsif arg
      my_each { |x| count += 1 if x == arg }
    else
      count = length
    end
    count
  end

  def my_map(my_proc)
    result = []
    self.my_each { |i| result.push(my_proc != nil ? my_proc.call(i) : yield(i)) }
    result
  end

  def my_inject(acc = nil)
    acc, *b = self
    self.my_each { |i| acc = yield(acc, i) }
    acc
  end
end

my_proc = Proc.new { |i| i.capitalize }

array = [2, 5, 7, 6, 1]
validate = ["string"]

p array.my_inject { |i, j| i + j }
end
