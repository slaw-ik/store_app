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

    sidx = "id" if sidx.blank?

    start = limit * (page - 1)
    start = 0 if start < 0

    if params["_search"] == "true"

      conds = {"id" => params[:id],
               "name" => params[:name],
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

    search_result = request_objects.where { condition } unless request_objects.blank?
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
                      det.status,
                      det.at_time
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
end