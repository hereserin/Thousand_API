require 'page_rank'
require 'adjacency_matrix'

desc 'Calculate pagerank for all pages indexed'
task :rank_page_index => :environment do

  puts "Starting adjacency matrix..."
  start_time = Time.now

  all_pages = Page.all
  ids_array = sorted_page_ids_array(all_pages)
  coord_lookup_hash = create_coordinate_lookup_hash(ids_array)
  adj_matrix = adjacency_matrix(all_pages, ids_array, coord_lookup_hash)

  puts "Matrix created: "
  # print adj_matrix
  puts
  mid_time = Time.now
  puts "Time elapsed: #{(mid_time - start_time)} seconds"

  pageranks = pagerank(adj_matrix, 0.001, 0.85)
  success = assign_pageranks(all_pages, coord_lookup_hash, pageranks)
  if success
    puts "Assigned pageranks!!!!!!!!!!!!"
  else
    puts "did not assign pageranks T.T "
  end
  # print pageranks
  puts
  end_time = Time.now
  puts "Total time elapsed: #{(end_time - start_time)} seconds"




  File.open("pagerank_array_#{end_time}.txt", "w+") do |page|
      page.write(pageranks)
      puts "===="
  end


end
