class StoreActivitiesController < ApplicationController
  include CommonMethods

    # GET /store_activities

    def index
      response = prepare_store_act_response(params, StoreActivity.scoped)
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => response }
      end
    end
end
