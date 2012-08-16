class StaticController < ApplicationController

  def landing

    respond_to do |format|
      format.html
    end
  end

  def summary
    respond_to do |format|
      format.html
    end
  end

end
