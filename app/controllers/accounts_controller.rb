class AccountsController < ApplicationController

  layout  "accounts"

  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!

  def index
    prepare_accounts
    @transactions = current_user.transactions.where("transactions.created_at >= ?", Date.today - 7).order("created_at DESC").page(params[:page]).per(10)
    respond_to do |format|
      format.html
    end
  end

  def show
    prepare_accounts
    @account = Account.find(params[:id])
    @transactions = @account.transactions.where("created_at >= ?", Date.today - 7).order("created_at DESC").page(params[:page]).per(10)
    respond_to do |format|
      format.html
    end
  end

  def new
    @account = Account.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    @account = Account.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @account = Account.new(params[:account].except('currency'))
    @account.user = current_user
    @account.currency = Currency.find_by_id(params[:account][:currency].to_i)

    respond_to do |format|
      if @account.save
        format.js { render :js => "window.location.href = '#{account_path(@account)}'" }
      else
        format.js
      end
    end
  end

  def update
    @account = Account.find(params[:id])
    @account.currency = Currency.find_by_id(params[:account][:currency].to_i)

    respond_to do |format|
      if @account.update_attributes(params[:account].except('currency'))
        format.js { render :js => "window.location.href = '#{account_path(@account)}'" }
      else
        format.js
      end
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.js { render :js => "window.location.href = '#{accounts_path}'" }
    end
  end

  def sort_column
    Transaction.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
