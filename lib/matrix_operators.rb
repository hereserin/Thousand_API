# TODO: create my own matrix class

def product_of_matrices(m1, m2)
  # matrix multiplication for two matrices represented as 2D arrays
  m1_width = m1[0].length
  m2_width = m2[0].length
  m1_height = m1.length
  m2_height = m2.length

  raise ArgumentError, "Invalid matrix sizes" unless m1_width == m2_height

  product = Array.new(m1_height) { Array.new }

  product.each_with_index do |row, idx1|
    (0...m2_width).each do |col_idx|
      product[idx1] << m1[idx1].each_with_index.reduce(0) do |a, (num, i)|
        num * m2[i][col_idx] + a
      end
    end
  end
  return product
end


def dup_matrix(m1)
  new_m = []
  m1.each {|sub_arr| new_m << sub_arr.clone }
  new_m
end


def subtract_matrices(m1, m2)
  # subtracts m2 from m1:

  m1_width = m1[0].length
  m2_width = m2[0].length
  m1_height = m1.length
  m2_height = m2.length
  if m1_width != m2_width || m1_height != m2_height

    raise ArgumentError, "Matrices must have the same dimensions"
  end

  result = Array.new(m1_height) { Array.new(m1_width) {} }

  (0...result.length).each do |row_idx|
    (0...m1_width).each do |el_idx|
      result[row_idx][el_idx] = m1[row_idx][el_idx] - m2[row_idx][el_idx]
    end
  end
  result
end
