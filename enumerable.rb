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

  def my_map(num = nil)
    return result unless block_given?

    new_arr = []
    if block_given?
      my_each { |x| new_arr << yield(x) }
    else
      my_each { |x| new_arr << num.call(x) }
    end
    new_arr
  end

  def my_inject(*args)
    result, item = inj_num(*args)
    arr = result ? to_a : to_a[1..-1]
    result ||= to_a[0]
    if block_given?
      arr.my_each { |x| result = yield(result, x) }
    elsif item
      arr.my_each { |x| result = result.public_send item, x) }
    end
    result
  end

  def multiply_els
    my_inject { |x, y| x * y }
  end

  def figure?(obj, number)
    (obj.respond_to?(:eql?) && obj.eql?(number)) ||
      (number.is_a?(Class) && obj.is_a?(number)) ||
      (number.is_a?(Regexp) && number.match(obj))
  end

  def inj_num(*args)
    result, item = nil
    args.my_each do |arg|
      result = arg if arg.is_a? Numeric
     item = arg unless arg.is_a? Numeric
    end
    [result, item]
  end
end
