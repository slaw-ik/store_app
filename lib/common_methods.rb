module CommonMethods
  def get_show_response(params, request_objects)
    details = []
    comparations = {'0' => '>', '1' => '<'}

    page = (params[:page].to_i == 0) ? 1 : params[:page].to_i
    limit = (params[:rows].to_i == 0) ? 50 : params[:rows].to_i
    sidx = params[:sidx]
    sord = params[:sord].try(:upcase) || "DESC"

    sidx = "id" if sidx.blank?

    start = limit * (page - 1)
    start = 0 if start < 0

    if params["_search"] == "true"

      conds = {"code" => params[:code],
               "description" => params[:description],
               "net_free_stock" => params[:net_free_stock],
               "category" => params[:category],
               "sell_price" => params[:sell_price],
               "brand" => params[:brand],
               "model" => params[:model],
               "total_stock" => params[:total_stock]
      }.delete_if { |key, value| value.nil? }

      condition = []
      conds.each do |key, val|
        condition << " #{key} LIKE '%#{val}%'"
      end
      condition = condition.join(" AND")
    end

    if params["filter"] == "true"
      if condition
        condition = condition.to_a
      else
        condition =[]
      end
      #condition ||=[]
      conds = params["item"]
      conds.each do |key, val|
        if val.class == conds.class
          if val['value'].blank?
            conds[key] = nil
          else
            conds[key] = "#{comparations[val['compare']]} #{val['value']}"
          end
        end
      end
      conds.delete_if { |key, value| value.blank? }
      conds.each do |key, val|
        condition << " #{key} #{comparations.index(val[0].chr).blank? ? "LIKE '%"+val+"%'" : val[0].chr+"'"+val[2..val.size]+"'" } "
      end
      condition = condition.join(" AND")
    end

    search_result = request_objects.where { condition } unless request_objects.blank? # do not forgot to require gem 'squeel'
    count = search_result.try(:count).to_i
    count > 0 ? total_pages = (count.to_f/limit.to_f).ceil : total_pages = 0
    page = total_pages if page > total_pages
    start = limit * (page - 1)
    start = 0 if start < 0

    details = search_result.try(:order, "#{sidx} #{sord}").try(:limit, limit).try(:offset, start)

    if details.try(:count)
      response = {:page => page,
                  :total => total_pages,
                  :records => details.count,
                  :rows => details.map { |det| {:id => det.id, :cell => [
                      det.code,
                      det.description,
                      det.net_free_stock,
                      det.category,
                      det.sell_price,
                      det.brand,
                      det.model,
                      det.total_stock
                  ]} }}
    else
      response = {:page => 1,
                  :total => 0,
                  :records => 0,
                  :rows => {:id => 0,
                            :cell => [
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil
                            ]}}
    end
    return response
  end

  def prepare_activity_response(params, request_objects)
    details = []
    comparations = {'0' => '>', '1' => '<'}

    page = (params[:page].to_i == 0) ? 1 : params[:page].to_i
    limit = (params[:rows].to_i == 0) ? 50 : params[:rows].to_i
    sidx = params[:sidx]
    sord = params[:sord].try(:upcase) || "DESC"

    sidx = "activities.id" if sidx.blank?

    start = limit * (page - 1)
    start = 0 if start < 0

    if params["_search"] == "true"

      conds = {"activities.id" => params[:'activities.id'],
               "statuses.name" => params[:'statuses.name'],
               "at_time" => params[:at_time]
      }.delete_if { |key, value| value.nil? }

      condition = []
      conds.each do |key, val|
        condition << " #{key} LIKE '%#{val}%'"
      end
      condition = condition.join(" AND")
    end

    if params["filter"] == "true"
      if condition
        condition = condition.to_a
      else
        condition =[]
      end
      #condition ||=[]
      conds = params["item"]
      conds.each do |key, val|
        if val.class == conds.class
          if val['value'].blank?
            conds[key] = nil
          else
            conds[key] = "#{comparations[val['compare']]} #{val['value']}"
          end
        end
      end
      conds.delete_if { |key, value| value.blank? }
      conds.each do |key, val|
        condition << " #{key} #{comparations.index(val[0].chr).blank? ? "LIKE '%"+val+"%'" : val[0].chr+"'"+val[2..val.size]+"'" } "
      end
      condition = condition.join(" AND")
    end

    search_result = request_objects.where { condition }.includes(:status) unless request_objects.blank?
    #search_result = request_objects.find(:all, :conditions => condition , :include => :status) unless request_objects.blank?
    count = search_result.try(:count).to_i
    count > 0 ? total_pages = (count.to_f/limit.to_f).ceil : total_pages = 0
    page = total_pages if page > total_pages
    start = limit * (page - 1)
    start = 0 if start < 0

    details = search_result.try(:order, "#{sidx} #{sord}").try(:limit, limit).try(:offset, start).try(:includes, :status)
    #details = search_result.find(:all, :include=>:status, :order => "#{sidx} #{sord}", :limit => limit, :offset => start)

    if details.try(:count)
      response = {:page => page,
                  :total => total_pages,
                  :records => details.count,
                  :rows => details.map { |det| {:id => det.id, :cell => [
                      det.id,
                      det.status.name,
                      det.at_time.strftime("%d-%b-%Y %H:%M:%S")
                  ]} }}
    else
      response = {:page => 1,
                  :total => 0,
                  :records => 0,
                  :rows => {:id => 0,
                            :cell => [
                                nil,
                                nil,
                                nil
                            ]}}
    end
    return response
  end

  def prepare_store_response(params, request_objects)
    details = []
    comparations = {'0' => '>', '1' => '<'}

    page = (params[:page].to_i == 0) ? 1 : params[:page].to_i
    limit = (params[:rows].to_i == 0) ? 50 : params[:rows].to_i
    sidx = params[:sidx]
    sord = params[:sord].try(:upcase) || "DESC"

    sidx = "id" if sidx.blank?

    start = limit * (page - 1)
    start = 0 if start < 0

    if params["_search"] == "true"

      conds = {"id" => params[:id],
               "name" => params[:name],
               "description" => params[:description],
               "count" => params[:count],
               "crit_count" => params[:crit_count],
               "item_type" => params[:item_type]
      }.delete_if { |key, value| value.nil? }

      condition = []
      conds.each do |key, val|
        condition << " #{key} LIKE '%#{val}%'"
      end
      condition = condition.join(" AND")
    end

    if params["filter"] == "true"
      if condition
        condition = condition.to_a
      else
        condition =[]
      end
      #condition ||=[]
      conds = params["item"]
      conds.each do |key, val|
        if val.class == conds.class
          if val['value'].blank?
            conds[key] = nil
          else
            conds[key] = "#{comparations[val['compare']]} #{val['value']}"
          end
        end
      end
      conds.delete_if { |key, value| value.blank? }
      conds.each do |key, val|
        condition << " #{key} #{comparations.index(val[0].chr).blank? ? "LIKE '%"+val+"%'" : val[0].chr+"'"+val[2..val.size]+"'" } "
      end
      condition = condition.join(" AND")
    end

    search_result = request_objects.where { condition } unless request_objects.blank? # do not forgot to require gem 'squeel'
    count = search_result.try(:count).to_i
    count > 0 ? total_pages = (count.to_f/limit.to_f).ceil : total_pages = 0
    page = total_pages if page > total_pages
    start = limit * (page - 1)
    start = 0 if start < 0

    details = search_result.try(:order, "#{sidx} #{sord}").try(:limit, limit).try(:offset, start)

    if details.try(:count)
      response = {:page => page,
                  :total => total_pages,
                  :records => details.count,
                  :rows => details.map { |det| {:id => det.id, :cell => [
                      det.id,
                      det.name,
                      det.description,
                      det.count,
                      det.crit_count,
                      det.item_type
                  ]} }}
    else
      response = {:page => 1,
                  :total => 0,
                  :records => 0,
                  :rows => {:id => 0,
                            :cell => [
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil
                            ]}}
    end
    return response
  end

  def prepare_store_act_response(params, request_objects)
    details = []
    comparations = {'0' => '>', '1' => '<'}

    page = (params[:page].to_i == 0) ? 1 : params[:page].to_i
    limit = (params[:rows].to_i == 0) ? 50 : params[:rows].to_i
    sidx = params[:sidx]
    sord = params[:sord].try(:upcase) || "DESC"

    sidx = "move_date" if sidx.blank?

    start = limit * (page - 1)
    start = 0 if start < 0

    if params["_search"] == "true"

      conds = {"users.email" => params[:'users.email'],
               "items.name" => params[:'items.name'],
               "statuses.name" => params[:'statuses.name'],
               "count" => params[:count],
               "critical" => params[:critical],
               "remainder" => params[:remainder],
               "move_date" => params[:move_date]
      }.delete_if { |key, value| value.nil? }

      condition = []
      conds.each do |key, val|
        condition << " #{key} LIKE '%#{val}%'"
      end
      condition = condition.join(" AND")
    end

    if params["filter"] == "true"
      if condition
        condition = condition.to_a
      else
        condition =[]
      end
      #condition ||=[]
      conds = params["item"]
      conds.each do |key, val|
        if val.class == conds.class
          if val['value'].blank?
            conds[key] = nil
          else
            conds[key] = "#{comparations[val['compare']]} #{val['value']}"
          end
        end
      end
      conds.delete_if { |key, value| value.blank? }
      conds.each do |key, val|
        condition << " #{key} #{comparations.index(val[0].chr).blank? ? "LIKE '%"+val+"%'" : val[0].chr+"'"+val[2..val.size]+"'" } "
      end
      condition = condition.join(" AND")
    end

    search_result = request_objects.where { condition }.includes(:status).includes(:user).includes(:item) unless request_objects.blank? # do not forgot to require gem 'squeel'
    count = search_result.try(:count).to_i
    count > 0 ? total_pages = (count.to_f/limit.to_f).ceil : total_pages = 0
    page = total_pages if page > total_pages
    start = limit * (page - 1)
    start = 0 if start < 0

    details = search_result.try(:order, "#{sidx}").try(:limit, limit).try(:offset, start).try(:includes, :status).try(:includes, :user).try(:includes, :item)

    if details.try(:count)
      response = {:page => page,
                  :total => total_pages,
                  :records => details.count,
                  :rows => details.map { |det| {:id => det.id, :cell => [
                      det.user.email,
                      det.item.name,
                      det.status.name,
                      det.count,
                      det.critical,
                      det.remainder,
                      det.move_date
                  ]} }}
    else
      response = {:page => 1,
                  :total => 0,
                  :records => 0,
                  :rows => {:id => 0,
                            :cell => [
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil,
                                nil
                            ]}}
    end
    return response
  end
end