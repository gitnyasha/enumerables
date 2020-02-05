module Enumerable
  def my_each
    if block_given?
      i = 0
      while i < results.length
        yield(results[i])
        i += 1
      end
      results
    end
  end

  def my_each_with_index
    if block_given?
        for i in 0..results.length - 1 do
            yield(results[i], i)
        end 
    else
        results
    end
  end


  def my_select
    choice = []
    if block_given?
        results.my_each do |x| 
          choice << x if yield(x)
        end
        choice
    else
        results
    end
  end

  def my_all?
    if block_given?
       results.my_each do |x|
            return false unless yield(x)
        end
        true
    else
       results
    end  
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
    numbers = []
    if block_given?
      results.my_each do |x|
        numbers << yield(x)
      end
    else
      numbers
    end
    numbers
  end

  def my_map_proc(&multiply_num)
    if block_given?
      numbers = []
      results.my_each do |x|
        numbers << multiply_num.call(x)
      end
      numbers
    else
      results.to_enum
    end
  end

  def my_inject(*args)
    result, sample = inj_param(*args)
    choice = result ? to_a : to_a[1..-1]
    result ||= to_a[0]
    if block_given?
      choice.my_each { |x| result = yield(result, x) }
    elsif sample
      choice.my_each { |x| result = result.public_send(sample, x) }
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
