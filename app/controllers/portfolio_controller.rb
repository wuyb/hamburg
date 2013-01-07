class PortfolioController < ApplicationController

  before_filter :authenticate_user!

  def get_day_line
    days = params[:days] ? params[:days].to_i : 30

    respond_to do |format|
      format.json { render :json => day_line(days).to_json }
    end
  end

  def get_month_line
    months = params[:months] ? params[:months].to_i : 12
    respond_to do |format|
      format.json { render :json => month_line(months).to_json }
    end
  end

  def get_portfolio
    account = Account.find_by_id(params[:account_id].to_i) if params[:account_id]

    min_transaction_date = account ? account.transactions.minimum(:created_at) : current_user.transactions.minimum(:created_at)
    days = Date.today - min_transaction_date.to_date
    if days > 30
      @portfolio = month_line 12
    else
      @portfolio = day_line 30
    end

    respond_to do |format|
      format.json { render :json => @portfolio.to_json }
    end

  end

  private

  def month_line months
    # FIXME - calculate precisely
    days = months * 30
    account = Account.find_by_id(params[:account_id].to_i) if params[:account_id]

    transactions_by_month = account ? account.transactions.where("transactions.created_at >= ?", Date.today - days).group_by {|t| t.created_at.beginning_of_month.to_s} \
                          : current_user.transactions.where("transactions.created_at >= ?", Date.today - days).group_by {|t| t.created_at.beginning_of_month.to_s};

    # get the current total
    current_total = current_total_balance account
    @current_total = current_total

    # calculate month line, the portfolio of the month X, is the total of the month X + 1 minus sum of all transactions of X + 1
    month_line = []
    dates = []
    current_month = Time.now.beginning_of_month

    (0..months).each do |month|
      month_line.unshift current_total.round
      current_total -= transactions_by_month[current_month.to_s].inject(0) {|sum, x| sum + x.amount_in_default_currency * x.transaction_type } if transactions_by_month[current_month.to_s]
      dates.unshift current_month.to_date
      current_month = (current_month - 1).beginning_of_month
    end

    portfolio = { :line=>month_line, :dates=>dates, :type=>"month"  }
  end

  def day_line days
    account = Account.find_by_id(params[:account_id].to_i) if params[:account_id]

    # get all the transactions from now to the start date backwards
    transactions = account ? account.transactions.where("transactions.created_at >= ?", Date.today - days).order("transactions.created_at DESC") \
                  : current_user.transactions.where("transactions.created_at >= ?", Date.today - days).order("transactions.created_at DESC")

    # get the current total
    current_total = current_total_balance account

    # calculate day line, the portfolio of the day X, is the total of the day X + 1 minus sum of all transactions of X + 1
    sum_of_day = {}
    transactions.each do |transaction|
      distance = Date.today.mjd - transaction.created_at.to_date.mjd
      sum_of_day[distance] = sum_of_day[distance] ? (sum_of_day[distance] + transaction.amount_in_default_currency * transaction.transaction_type) : transaction.amount_in_default_currency * transaction.transaction_type
    end

    day_line = []
    (0..days).each do |day|
      day_line.unshift current_total.round
      current_total -= sum_of_day[day] ? sum_of_day[day] : 0
    end

    portfolio = { :line=>day_line, :dates=>dates_back(days), :type=>"day" }
  end

  def current_total_balance account = nil
    account ? account.balance_in_default_currency : current_user.accounts.inject(0) {|sum, t| sum += t.balance_in_default_currency }
  end

  def dates_back days
    dates = []
    (0..days).each do |day|
      dates.unshift (Date.today - day)
    end
    dates
  end

end

