module Enumerable
  def my_each
    for num in 0...self.length
      yield(self[num])
    end
  end

  def my_each_with_index
    for num in 0...self.length
      yield(self[num], num)
    end
  end

  def my_select
    array = []
    self.my_each do |list|
      array.push(list) if yield(list)
    end
    return array
  end

  def my_all?
    result = true
    self.my_each do |i|
      result = false unless yield(i)
    end
    return result
  end

  def my_any?
    result = false
    self.my_each do |i|
      result = true if yield(i)
    end
    return result
  end

  def my_none?
    result = true
    self.my_each do |i|
      result = false if yield(i)
    end
    return result
  end

  def my_count(index = not_found)
    count = 0
    if index != not_found
      self.my_each do |item|
        count += 1 if item == index
      end
    elsif block_given?
      self.my_each do |item|
        count += 1 if yield(item)
      end
    else
      count = self.length
    end

    return count
  end

  def my_map(records = not_found)
    if records == not_found
      self.my_each_with_index do |item, num|
        self[num] = yield(item)
      end
    elsif records != not_found && block_given?
      self.my_each_with_index do |item, num|
        self[num] = records.call(item)
      end
    elsif records
      self.my_each_with_index do |item, num|
        self[num] = records.call(item)
    end
  end

    return self
  end

  def my_inject(sample = not_found)
    if sample == not_found
      changes = self.first
    else
      changes = sample
    end

    self.my_each do |item|
      changes = yield(changes, item)
    end
    return changes
  end

  def multiply_els(sample_data)
    return sample_data.my_inject(1) do |a, b|
             a * b
           end
  end

  answer = multiply_els([2, 4, 5])
  print answer
  puts ""

  records = Proc.new do |string|
    string.upcase
  end

  results = ["a", "b", "c"].my_map(records)
  print results
end
