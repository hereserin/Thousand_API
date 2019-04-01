def adjacency_matrix(all_pages, all_pages_ids_arr, lookup_hsh)

  # all_pages = Page.all
  # all_pages_ids_arr = all_pages.map {|page| page.id}.sort
  # lookup_hsh = create_coordinate_lookup_hash(all_pages_ids_arr)

  new_adjacency_matrix = []


  all_pages_ids_arr.each do |page_id|
    page = all_pages.find_by(id: page_id)

    new_row = page.create_own_row(all_pages, lookup_hsh)
    new_adjacency_matrix[lookup_hsh[page_id]] = new_row
  end

  # all_pages.each do |page|
  #   new_row = page.create_own_row(all_pages, lookup_hsh)
  #   new_adjacency_matrix << new_row
  # end

  return new_adjacency_matrix

end

def create_coordinate_lookup_hash(ids_arr)
  lookup_hsh = {}
  i = 0
  ids_arr.each do |id|
    lookup_hsh[id] = i
    i += 1
  end
  return lookup_hsh
end

def sorted_page_ids_array(all_pages)
  all_pages.map {|page| page.id}.sort
end

def assign_pageranks(all_pages, lookup_hsh, pageranks)

  all_pages.each do |page|
    rank_location = lookup_hsh[page.id]
    rank = pageranks[rank_location]
    page.page_rank = rank[0]
    page.save
  end
  return true
end
