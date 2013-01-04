# encoding: utf-8
class TransactionsController < ApplicationController

  layout  "accounts"

  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!

  def index
    prepare_data
    respond_to do |format|
      format.html
    end
  end

  def new
    @accounts = current_user.accounts
    @account = Account.find_by_id(params[:account_id].to_i)
    @transaction = Transaction.new(:account=>@account);

    respond_to do |format|
      format.js
    end
  end

  def create
    @transaction = Transaction.new(params[:transaction].except(:account_id).except(:transaction_category))

    if params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end

    @transaction.account = Account.find_by_id(params[:transaction][:account_id])

    respond_to do |format|
      if @transaction.save!
        format.js { render :js => "window.location.href = '#{account_path(@transaction.account)}'" }
      else
        format.js
      end
    end
  end

  def edit
    @transaction = Transaction.find_by_id(params[:id])
    @accounts = current_user.accounts

    respond_to do |format|
      format.js
    end
  end

  def update
    @transaction = Transaction.find_by_id(params[:id])

    if params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end

    @transaction.account = Account.find_by_id(params[:transaction][:account_id])

    prepare_data

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction].except(:account_id).except(:transaction_category))
        format.js  { render :js => "window.location.href = '#{account_path(@transaction.account)}'" }
      else
        format.js
      end
    end
  end

  def destroy
    @transaction = Transaction.find_by_id(params[:id])
    @account = @transaction.account
    @transaction.destroy

    prepare_data

    respond_to do |format|
      format.js  { render :js => "window.location.href = '#{account_path(@account)}'" }
    end
  end

  private

  def prepare_data
    @days = days params
    @by = params[:by].nil? ? "all" : params[:by]
    @start_date = start_date params
    @end_date = end_date params
    @flot_type = params[:flot_type].nil? ? "by_date" : params[:flot_type]


    @account = Account.find_by_id(params[:account_id].to_i) if params[:account_id]

    @transactions = !@account ? current_user.transactions.since(@start_date).until(@end_date) : @account.transactions.since(@start_date).until(@end_date)
    @paged_transactions = !@account ? current_user.transactions.since(@start_date).until(@end_date).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10) : @account.transactions.since(@start_date).until(@end_date).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)

    prepare_accounts

  end

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def start_date(params)
    if !params[:start_date].nil? and params[:start_date] != ''
      return Time.parse(params[:start_date])
    elsif !params[:by].nil?
        return case params[:by]
          when "week" then Time.now.weeks_ago(1)
          when "month"  then Time.now.months_ago(1)
          when "year"   then Time.now.years_ago(1)
          else Time.at(0)
        end
    else
      Time.at(0)
    end
  end

  def end_date(params)
    if !params[:end_date].nil? and params[:end_date] != ''
      return Time.parse(params[:end_date])
    else
      Time.now
    end
  end

  def days(params)
    if (!params[:start_date].nil? and params[:start_date] != '') or (!params[:end_date].nil? and params[:end_date] != '')
      if start_date(params) == Time.at(0)
        return 0
      else
        return (end_date(params) - start_date(params)) / (60 * 60 * 24) + 1
      end
    elsif !params[:by].nil?
      return case params[:by]
        when "week" then 7
        when "month"  then 30
        when "year"   then 365
        else 0
      end
    else
      0
    end
  end

end
