class Array

  def my_each(&prc)
    i = 0
    while i < self.count
      prc.call(self[i])
      i += 1
    end
    self
  end

  def my_select(&prc)
    return_array = []
    self.my_each do |element|
      return_array << element if prc.call(element)
    end
    return_array
  end

  def my_reject(&prc)
    return_array = []
    self.my_each do |element|
      return_array << element if !prc.call(element)
    end
    return_array
  end

  def my_any?(&prc)
    self.my_each { |element| return true if prc.call(element) }

    false
  end

  def my_all?(&prc)
    self.my_each { |element| return false if !prc.call(element) }

    true
  end

  def my_flatten
    return_array = []
    self.my_each do |element|
      if element.class == Array
        return_array.concat(element.my_flatten)
      else
        return_array << element
      end
    end
    return_array
  end

  def my_zip(*args)
    return_array = []
    self.each_with_index do |element, idx|
      zip_array = []
      zip_array << element
      args.my_each do |el|
        zip_array << el[idx]
      end
      return_array << zip_array
    end
    return_array
  end

  def my_rotate(degree = 1)
    return_array = self.dup
    new_degree = degree % self.length
    new_degree = new_degree + self.length if new_degree < 0
    new_degree.times do
      first_val = return_array.shift
      return_array.push(first_val)
    end
    return_array
  end

  def my_join(separator = "")
    return_string = ""
    self.each_with_index do |char,idx|
      if idx != self.length - 1
        return_string = "#{return_string}#{char}#{separator}"
      else
        return_string = "#{return_string}#{char}"
      end
    end
    return_string
  end

  def my_reverse
    return_array = []
    self.my_each { |char| return_array.unshift(char) }
    return_array
  end

end

def factors(num)
  return_array = []
  (1..num).times do |number|
    return_array << number if num % number == 0
  end

  return_array
end
