# In app/helpers/application_helper.rb
module ApplicationHelper
  def next_page_url(paginated_items, client)
    paginated_items.next_page ? timeline_items_client_path(client, page: paginated_items.next_page) : ''
  end
end
