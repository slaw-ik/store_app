class ItemsController < ApplicationController
  include CommonMethods

  # GET /items
  # GET /items.json

  def index
    response = prepare_store_response(params, Item.where(:removed => nil))
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => response }
    end
  end

  # POST /items
  # POST /items.json
  def create
    action = params[:oper]
    if action == "add"
      @item = Item.new(params[:item])

      respond_to do |format|
        if @item.save
          StoreActivity.leave(:item => @item,
                              :action => :create,
                              :user => current_user
          )
          format.html { render :nothing => true, :status => 200 }
          format.json { render json: @item, status: :created, location: @item }
        else
          format.html { render :nothing => true, :status => 500 }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    elsif action == "edit"
      @item = Item.find(params[:id])
      first_count = @item.count

      respond_to do |format|
        if @item.update_attributes(params[:item])

          StoreActivity.leave(:item => @item,
                              :action => :edit,
                              :user => current_user,
                              :count => @item.count,
                              :first_count => first_count
          )
          format.html { render :nothing => true, :status => 200 }
          format.json { head :no_content }
        else
          format.html { render :nothing => true, :status => 500 }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy_item
    @item = Item.find(params[:id])
    @item.update_attributes(:removed => true)

    StoreActivity.leave(:item => @item,
                        :action => :delete,
                        :user => current_user
    )

    respond_to do |format|
      format.html {  render :nothing => true, :status => 200  }
      format.json { head :no_content }
    end
  end
end
