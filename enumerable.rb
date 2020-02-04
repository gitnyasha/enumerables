module Enumerable
  def my_each
    if block_given?
      i = 0
      while i < self.length
        yield(self[i])
        i += 1
      end
      self
    else
      self.to_enum
    end
  end

  def my_each_with_index
    if block_given?
      i = 0
      while (i < self.length)
        yield(self[i], i)
        i += 1
      end
      self
    else
      self.to_enum
    end
  end

  def my_select
    if block_given?
      choice = []
      self.my_each do |x|
        if yield(x)
          choice.push(x)
        end
      end
      choice
    else
      self.to_enum
    end
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

  def my_map
    if block_given?
      numbers = []
      self.my_each do |x|
        numbers << yield(x)
      end
      numbers
    else
      self.to_enum
    end
  end

  def my_map_proc(&multiply_num)
    if block_given?
      numbers = []
      self.my_each do |x|
        numbers << multiply_num.call(x)
      end
      numbers
    else
      self.to_enum
    end
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
