module Enumerable
  def my_each
    return numer unless block_given?

    x = 0
    while x < length
      yield(to_a[x])
      x += 1
    end
    self
  end

  def my_each_with_index
    return numer unless block_given?

    x = 0
    while x < length
      yield(self[x], x)
      x += 1
    end
    self
  end

  def my_select
    return numer(:my_each) unless block_given?

    my_array = []
    x = 0
    while x < length
      my_array << self[x] if yield(self[x])
      x += 1
    end
    my_array
  end

  def my_all?(n = nil)
    if block_given?
      my_each { |x| return false unless yield x }
    else
      return my_all? { |obj| obj } unless n

      if n.class == Regexp
        my_each { |x| return false unless n.match?(x) }
      elsif n.class == Class
        my_each { |x| return false unless x.is_a? n }
      else
        my_each { |x| return false unless x == n }
      end
    end
    true
  end

  def my_any?(n = nil)
    result = false
    if block_given?
      my_each { |items| result = true if yield items }
    elsif n
      my_each { |items| result = true if pattern?(items, n) }
    else
      my_each { |items| result = true if items }
    end
    result
  end

  def my_none?(n = nil)
    result = true
    if block_given?
      my_each { |items| result = false if yield items }
    elsif n
      my_each { |items| result = false if pattern?(items, n) }
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

  def my_map(param = nil)
    return numer unless block_given?

    new_my_array = []
    if block_given?
      my_each { |x| new_my_array << yield(x) }
    else
      my_each { |x| new_my_array << param.call(x) }
    end
    new_my_array
  end

  def my_inject(*args)
    result, sym = inj_param(*args)
    my_array = result ? to_a : to_a[1..-1]
    result ||= to_a[0]
    if block_given?
      my_array.my_each { |x| result = yield(result, x) }
    elsif sym
      my_array.my_each { |x| result = result.public_send(sym, x) }
    end
    result
  end
end

def multiply_els(something)
  something.inject { |x, y| x * y }
end

def pattern?(obj, n)
  (obj.respond_to?(:eql?) && obj.eql?(n)) ||
    (n.is_a?(Class) && obj.is_a?(n)) ||
    (n.is_a?(Regexp) && n.match(obj))
end

def inj_param(*args)
  result, sym = nil
  args.my_each do |arg|
    result = arg if arg.is_a? Numeric
    sym = arg unless arg.is_a? Numeric
  end
  [result, sym]
end
