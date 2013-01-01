module AccountsHelper
  def render_sidebar_item_for(account)
    render :partial=>"account_sidebar_item", :locals => {:account => account }
  end
end
