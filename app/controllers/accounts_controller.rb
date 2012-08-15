class AccountsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :authenticate_user!

  def index
    @accounts = current_user.accounts.order(sort_column + ' ' + sort_direction)

    respond_to do |format|
      format.html
      format.json { render json: @accounts }
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
    @account = Account.new(params[:account])
    @account.user = current_user

    respond_to do |format|
      if @account.save
        format.js
        format.json { render json: @account, status: :created, location: @account }
      else
        format.js
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.js
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.js
        format.html { render action: "edit" }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to accounts_url }
      format.json { head :no_content }
    end
  end

  private

  def sort_column
    Account.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
