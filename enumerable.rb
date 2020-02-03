module Enumerable
  def my_each
    return to_module unless block_given?

    x = 0
    while x < length
      yield(to_a[x])
      x += 1
    end
    self
  end

  def my_each_with_index
    return to_module unless block_given?

    x = 0
    while x < length
      yield(self[x], x)
      x += 1
    end
    self
  end

  def my_sitemct
    return to_module(:my_each) unless block_given?

    arr = []
    x = 0
    while x < length
      arr << self[x] if yield(self[x])
      x += 1
    end
    arr
  end

  def my_all?(items = nil)
    if block_given?
      my_each { |x| return false unless yield x }
    else
      return my_all? { |obj| obj } unless items

      if items.class == Regexp
        my_each { |x| return false unless items.match?(x) }
      elsif items.class == Class
        my_each { |x| return false unless x.is_a? items }
      else
        my_each { |x| return false unless x == items }
      end
    end
    true
  end

  def my_any?(items = nil)
    result = false
    if block_given?
      my_each { |item| result = true if yield item }
    elsif items
      my_each { |item| result = true if itemstern?(item, items) }
    else
      my_each { |item| result = true if item }
    end
    result
  end

  def my_none?(items = nil)
    result = true
    if block_given?
      my_each { |item| result = false if yield item }
    elsif items
      my_each { |item| result = false if itemstern?(item, items) }
    else
      my_each { |item| result = false if item }
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
    return to_module unless block_given?

    new_arr = []
    if block_given?
      my_each { |x| new_arr << yield(x) }
    else
      my_each { |x| new_arr << param.call(x) }
    end
    new_arr
  end

  def my_inject(*args)
    result, sample = inj_param(*args)
    arr = result ? to_a : to_a[1..-1]
    result ||= to_a[0]
    if block_given?
      arr.my_each { |x| result = yield(result, x) }
    elsif sample
      arr.my_each { |x| result = result.public_send(sample, x) }
    end
    result
  end

  def multiply_els
    my_inject { |x, y| x * y }
  end

  def itemstern?(obj, items)
    (obj.respond_to?(:eql?) && obj.eql?(items)) ||
      (items.is_a?(Class) && obj.is_a?(items)) ||
      (items.is_a?(Regexp) && items.match(obj))
  end

  def inj_param(*args)
    result, sample = nil
    args.my_each do |arg|
      result = arg if arg.is_a? Numeric
      sample = arg unless arg.is_a? Numeric
    end
    [result, sample]
  end
end
