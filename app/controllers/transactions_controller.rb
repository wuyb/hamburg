# encoding: utf-8
class TransactionsController < ApplicationController

  def index
    @transactions = current_user.transactions
    respond_to do |format|
      format.html
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
    @transaction.account = Account.find_by_id(params[:transaction][:account_id])

    if params[:transaction][:transaction_category]
      @transaction.transaction_category = TransactionCategory.find_by_id(params[:transaction][:transaction_category])
    end

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

end
