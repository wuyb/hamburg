# encoding: utf-8
class TransactionsController < ApplicationController
  layout  "main"
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!

  def index
    @days = 0
    @start_date = Time.at(0)

    if !params[:by].nil?
      @start_date = case params[:by]
        when "week" then Time.now.weeks_ago(1)
        when "month"  then Time.now.months_ago(1)
        when "year"   then Time.now.years_ago(1)
        else Time.at(0)
      end
      @days = case params[:by]
        when "week" then 7
        when "month"  then 30
        when "year"   then 365
        else 0
      end
      @transactions = current_user.transactions.where('transactions.created_at > ?', @start_date)
      @paged_transactions = current_user.transactions.where('transactions.created_at > ?', @start_date).order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)
    else
      @transactions = current_user.transactions
      @paged_transactions = current_user.transactions.order(sort_column + ' ' + sort_direction).page(params[:page]).per(10)
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @accounts = current_user.accounts
    @account = Account.find_by_id(params[:account].to_i)
    @transaction = Transaction.new(:account=>@account);

    respond_to do |format|
      format.js
    end
  end

  def create
    @transaction = Transaction.new(params[:transaction].except(:account_id).except(:transaction_category).except(:to_account))

    if params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end

    @transaction.account = Account.find_by_id(params[:transaction][:account_id])
    if params[:transaction][:to_account]
      @transaction.to_account = Account.find_by_id(params[:transaction][:to_account])
    end

    respond_to do |format|
      if @transaction.save!
        format.js
        format.json { render json: @transaction, status: :created, location: @transaction }
      else
        format.js
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
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
    if params[:transaction][:transaction_type] == '0' && params[:transaction][:to_account]
      @transaction.to_account = Account.find_by_id(params[:transaction][:to_account])
    end

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction].except(:account_id).except(:transaction_category).except(:to_account))
        format.js
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.js
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @transaction = Transaction.find_by_id(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
