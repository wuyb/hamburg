module ApplicationHelper
  def sortable(column, title=nil)
    title ||= column.titlized
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"

    if column == sort_column
      if sort_direction == 'asc'
        link_to (title + '<i class="icon-arrow-up"></i>').html_safe, {:sort => column, :direction => direction}
      else
        link_to (title + '<i class="icon-arrow-down"></i>').html_safe, {:sort => column, :direction => direction}
      end
    else 
      link_to title, {:sort => column, :direction => direction}
    end
  end

  def render_sidebar_item_for(account)
    render :partial=>"accounts/account_sidebar_item", :locals => {:account => account }
  end

end
