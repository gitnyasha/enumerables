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

    it "reverse order of the array" do
      rev = []
      array.my_each do |i|
        rev << i
      end
      expect(array.reverse).to eql(rev.reverse)
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

    it "adds an item with index and show the result into an array " do
      sums = []
      array.my_each_with_index do |value, index|
        sums << value + index
      end
      expect(sums).to eql([1, 3, 5, 7, 9, 11, 13, 15, 17, 19])
    end
  end

  # my_all?

  describe "#my_all?" do
    it "expects type of items in an array if they are strings" do
      check_array = %w[ruby java python php]
      a = check_array.my_all? do |word|
        word.is_a? String
      end
      expect(a).to eql(true)
    end

    it "expects type of items in an array if they are integers" do
      a = array.my_all? do |int|
        int.is_a? Integer
      end
      expect(a).to eql(true)
    end
  end

  describe "#my_any?" do
    it "expects if 7 appears in an array" do
      a = array.my_any? do |int|
        int == 7
      end
      expect(a).to eql(true)
    end

    it "expects type of items in an array if they are more than 1" do
      a = array.my_any? do |int|
        int.size > 1
      end
      expect(a).to eql(true)
    end
  end

  describe "#my_none?" do
    it "expects if there is no string in the array" do
      a = array.my_none? do |int|
        int.is_a? String
      end
      expect(a).to eql(true)
    end

    it "expects if there is no item with one digit" do
      a = array.my_none? do |int|
        int.size > 1
      end
      expect(a).to eql(false)
    end
  end

  describe "#my_count" do
    it "counts number of integers in an array" do
      expect = array.my_count do |int|
        int.is_a? Integer
      end
      expect(expect).to eql(10)
    end

    it "counts if there are integers in the array" do
      expect = array.my_count do |int|
        int.is_a? String
      end
      expect(expect).to eql(0)
    end
  end
end
