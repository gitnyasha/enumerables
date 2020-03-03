require_relative "../enumerable"

RSpec.describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

  describe "#my_each" do
    it "Place items in the same order" do
      sort = []
      array.my_each do |i|
        sort << i
      end
      expect(array).to eql(sort)
    end

    it "Place items in the same order and sorts their length" do
      sort = []
      array.my_each do |i|
        sort << i
      end
      expect(array.length).to eql(sort.length)
    end
  end

  describe "#my_each_with_index" do
    it "adds each index of an array into a new array" do
      adds = []
      array.my_each_with_index do |_value, index|
        adds << index
      end
      expect(adds).to eql([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    end

    it "adds an item with index and show the result into an array" do
      sums = []
      array.my_each_with_index do |value, index|
        sums << value + index
      end
      expect(sums).to eql([1, 3, 5, 7, 9, 11, 13, 15, 17, 19])
    end
  end

  describe "#my_select" do
    it "creates an array with the odd elements of another" do
      odds = array.my_select do |num|
        num.odd? && num <= 10
      end
      expect(odds).to eql([1, 3, 5, 7, 9])
    end

    it "creates an array with the even elements of another" do
      evens = array.my_select do |num|
        num.even? && num <= 10
      end
      expect(evens).to eql([2, 4, 6, 8, 10])
    end
  end

  describe "#my_all?" do
    it "expects type of items in an array if they are strings" do
      string_array = %w[taco sandwich pizza cake]
      my_array = string_array.my_all? do |word|
        word.is_a? String
      end
      expect(my_array).to eql(true)
    end

    it "expects type of items in an array if they are integers" do
      my_array = array.my_all? do |int|
        int.is_a? Integer
      end
      expect(my_array).to eql(true)
    end
  end

  describe "#my_any?" do
    it "expects if 7 appears in an array" do
      my_array = array.my_any? do |int|
        int == 7
      end
      expect(my_array).to eql(true)
    end

    it "expects type of items in an array if they are more than 1" do
      my_array = array.my_any? do |int|
        int.size > 1
      end
      expect(my_array).to eql(true)
    end
  end

  describe "#my_none?" do
    it "expects if there is no string in the array" do
      my_array = array.my_none? do |int|
        int.is_a? String
      end
      expect(my_array).to eql(true)
    end

    it "expects if there is no item with one digit" do
      my_array = array.my_none? do |int|
        int.size > 1
      end
      expect(my_array).to eql(false)
    end
  end

  describe "#my_count" do
    it "counts number of integers in an array" do
      counting = array.my_count do |int|
        int.is_a? Integer
      end
      expect(counting).to eql(10)
    end

    it "counts if there are integers in the array" do
      counting = array.my_count do |int|
        int.is_a? Integer
      end
      expect(counting).not_to eql(0)
    end
  end

  describe "#my_map" do
    it "adds a fullstop on each word" do
      language = %w[ruby java php]
      fullstop = language.my_map do |word|
        word + "."
      end
      expect(fullstop).to eql(%w[ruby. java. php.])
    end

    it "test to see if there is a fullstop on each word" do
      language = %w[ruby java php]
      fullstop = language.my_map do |word|
        word + ""
      end
      expect(fullstop).not_to eql(%w[ruby. java. php.])
    end
  end

  describe "#my_inject" do
    it "add the values of the array" do
      inject_array = array.my_inject(:+)
      expect(inject_array).to eql(55)
    end

    it "expect array not to equal 55" do
      inject_array = array.my_inject(:+)
      expect(inject_array).not_to eql(56)
    end
  end

  describe "#multiply_els" do
    it "multiplies all the values of the array" do
      arr = [1, 2, 3]
      times = multiply_els(arr)
      expect(times).to eql(6)
    end

    it "multiplies all the values of the array" do
      arr = [1, 2, 3, 4]
      times = multiply_els(arr)
      expect(times).not_to eql(6)
    end
  end

  describe "#pattern?" do
    it "checks if both elements are integers" do
      my_array = pattern?(1, 1)
      expect(my_array).to eql(true)
    end

    it "checks if both elements are not integers" do
      my_array = pattern?(1, "1")
      expect(my_array).not_to eql(true)
    end
  end

  describe "#inj_param" do
    it "tests for an integer and return nil for a symbol" do
      inj = inj_param(1)
      expect(inj).to eql([1, nil])
    end

    it "tests for a symbol and returns nil for an integer" do
      symbol = inj_param(:type)
      expect(symbol).to eql([nil, :type])
    end
  end
end
