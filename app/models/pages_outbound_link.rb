class PagesOutboundLink < ApplicationRecord
  belongs_to :page,
    class_name: 'Page',
    foreign_key: :page_id,
    primary_key: :id

  belongs_to :outbound_link,
    class_name: 'Page',
    foreign_key: :outbound_link_id,
    primary_key: :id
end
