class ActivitiesController < ApplicationController
  include CommonMethods

  def index
    response = prepare_activity_response(params, current_user.try(:activities))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => response }
    end
  end
end
