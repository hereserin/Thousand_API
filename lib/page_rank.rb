require 'matrix_operators'

def pagerank(matrix, eps, d)
  n_size = matrix[0].length

  vect = []
  n_size.times do
    random_num = rand 0..1.0
    vect << [ random_num ]
  end

  l1_norm = vect.reduce(0) {|a, el| a + el[0]}
  unit_vect = vect.map {|row| [ row[0] / l1_norm ] }

  last_vect = []
  n_size.times do
    last_vect << [ 100.0 ]
  end

  i = 0
  while Math.sqrt(subtract_matrices(unit_vect,last_vect).reduce(0) {|a, el| a + el[0] ** 2}) > eps
    last_vect = dup_matrix(unit_vect)
    unit_vect = product_of_matrices(matrix, unit_vect).map {|row| row.map {|el| el * d + (1 - d) / n_size }}
    i += 1
  end
  puts "Input took " + i.to_s + " to converge."
  unit_vect
end
def dup_matrix(m1)
  new_m = []
  m1.each {|sub_arr| new_m << sub_arr.clone }
  new_m
end
