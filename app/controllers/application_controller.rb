class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_time_zone

  def set_time_zone
    Time.zone = 'Beijing'
  end

  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  # This method will do the following:
  # 1. Retrieves all the @accounts that belongs to the user, order isn't important for now
  # 2. Categorizes the accounts to @accounts_by_category
  # 3. Calculates the @subtotal_by_category
  # 4. Calculates the @total
  def prepare_accounts
    if current_user
      @accounts = current_user.accounts
      @accounts_by_category = {}
      @subtotal_by_category = {}
      @total = 0.0

      @accounts.each do |account|
        accounts = @accounts_by_category[account.category]
        accounts = [] if !accounts
        accounts << account
        @accounts_by_category[account.category] = accounts 
             
        @subtotal_by_category[account.category] = (@subtotal_by_category[account.category] ? @subtotal_by_category[account.category] : 0) + account.currency.to_default_currency(account.balance)
        @total += account.currency.to_default_currency(account.balance)
      end
    end
  end


end
