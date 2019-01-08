class StaticPagesController < ApplicationController

require 'date'

  def home

  end

  def help
  end

  def about
  end

  def contact
  end
  
  def redirect_timecard_show
    d = Date.today
    year = d.year
    month = d.month
    redirect_to controller: 'time_cards', action: "show", user_id: current_user.id, year: year, month: month
  end

 helper_method :redirect_timecard_show
 
end