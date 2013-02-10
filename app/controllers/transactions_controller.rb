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
    prepare_accounts
    @account = Account.find_by_id(params[:account_id].to_i)
    @transaction = Transaction.new(:account=>@account);

    respond_to do |format|
      format.js
    end
  end

  def create
    @transaction = Transaction.new(params[:transaction].except(:account_id).except(:transaction_category).except(:link_account).except(:transfer_account))

    if @transaction.transaction_type != 0 && params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end
    if @transaction.transaction_type != 0
      @transaction.account = Account.find_by_id(params[:transaction][:account_id])
    else
      @transaction.account = Account.find_by_id(params[:transaction][:transfer_account])
    end

    if @transaction.transaction_type == 0
      @transaction.transaction_type = -1 
      @transaction.link_account = Account.find_by_id(params[:transaction][:link_account])
      @transaction.link_transaction = Transaction.new(params[:transaction].except(:account_id).except(:transaction_category).except(:link_account).except(:transfer_account))
      @transaction.link_transaction.transaction_type = 1
      @transaction.link_transaction.amount = @transaction.account.currency.to_currency @transaction.link_account.currency, @transaction.amount 
      @transaction.link_transaction.account = @transaction.link_account
      @transaction.link_transaction.link_account = @transaction.account
    end

    respond_to do |format|
      @transaction.transaction do 
        @transaction.save!
        @transaction.link_transaction.link_transaction = @transaction if @transaction.link_transaction
        if @transaction.link_transaction && @transaction.link_transaction.save! || !@transaction.link_transaction
          format.js { render :js => "window.location.href = '#{account_path(@transaction.account)}'" }
        else
          format.js
        end
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

    if !@transaction.link_transaction && params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end

    if @transaction.transaction_type != 0
      @transaction.account = Account.find_by_id(params[:transaction][:account_id])
    end

    @transaction.amount = params[:transaction][:amount].to_f
    @transaction.tag_list = params[:transaction][:tag_list]
    @transaction.description = params[:transaction][:description]
    @transaction.created_at = params[:transaction][:created_at] if params[:transaction][:created_at]

    if @transaction.link_transaction
      @transaction.link_transaction.amount = @transaction.account.currency.to_currency @transaction.link_account.currency, params[:transaction][:amount].to_f
      @transaction.link_transaction.tag_list = params[:transaction][:tag_list]
      @transaction.link_transaction.description = params[:transaction][:description]
      @transaction.link_transaction.created_at = params[:transaction][:created_at] if params[:transaction][:created_at]
    else
      @transaction.transaction_type = params[:transaction][:transaction_type].to_i
    end

    respond_to do |format|
      @transaction.transaction do

        @transaction.save!

        if @transaction.link_transaction && @transaction.link_transaction.save! || !@transaction.link_transaction
          format.js { render :js => "window.location.href = '#{account_path(@transaction.account)}'" }
        else
          format.js
        end
      end
    end

  end

  def destroy
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.transaction do
      @transaction.link_transaction.destroy if @transaction.link_transaction
      @transaction.destroy
    end

    respond_to do |format|
      format.js { render :js => "window.location.href = '#{account_path(@transaction.account)}'" }
    end
  end

  private

  def prepare_data
#    @days = days params
#    @by = params[:by].nil? ? "all" : params[:by]
    @start_date = start_date params
    @end_date = end_date params
#    @flot_type = params[:flot_type].nil? ? "by_date" : params[:flot_type]


   @account = Account.find_by_id(params[:account_id].to_i) if params[:account_id]

    @transactions = !@account ? current_user.transactions: @account.transactions.since(@start_date).until(@end_date)
    @paged_transactions = !@account ? current_user.transactions.since(@start_date).until(@end_date).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10) : @account.transactions.since(@start_date).until(@end_date).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)

    prepare_accounts

  end

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
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
