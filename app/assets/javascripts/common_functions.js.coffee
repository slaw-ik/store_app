#================Initializing the jqGrid===============
#initialize_grid
#  list_selector:         '#list'
#  pager_selector:        '#pager'
#  refresh_list_selector: '#refresh_list'
#  index_url:             '/'
#  update_url:            '/update_item'
#  delete_url:            '/delete_item'
#  caption:               'Items'
#  allowed_cols:          [1,2,3] #or ['all']
#======================================================

@initialize_grid = (params = {}) ->
  content_width = parseInt(jQuery(".content").css("width"))

  content_width = 1100 if content_width < 1100
  table_w = content_width
  this_content_width = content_width
  this_content_width = 1170 if content_width < 1170
  one = this_content_width/40

  code_w = one*4
  desc_w = one*12
  net_free_w = one*4-10
  category_w = one*4-10
  sell_price_w = one*4-10
  brand_w = one*4-10
  model_w = one*4-10
  price_w = one*4-10

  window.for_highlight = []

  window.save_bd = false
  window.current_row = null

  jQuery(params.list_selector).jqGrid(
    shrinkToFit: false
    width: table_w
    height: "475px"
    ignoreCase: true
    url: params.index_url
    datatype: "json"
    colNames: ["Code", "Description", "Free Stock", "Category", "Price", "Brand", "Model", "Quantity"]
    colModel: [
      name: "code"
      index: "code"
      width: code_w
    ,
      name: "description"
      index: "description"
      width: desc_w
    ,
      name: "net_free_stock"
      index: "net_free_stock"
      width: net_free_w
    ,
      name: "category"
      index: "category"
      width: category_w
    ,
      name: "sell_price"
      index: "sell_price"
      width: sell_price_w
    ,
      name: "brand"
      index: "brand"
      width: brand_w
    ,
      name: "model"
      index: "model"
      width: model_w
    ,
      name: "total_stock"
      index: "total_stock"
      width: price_w
    ]
    rowNum: 50
    rowList: [5, 10, 20, 50, 100]
    pager: params.pager_selector
    multiselect: false
    loadonce: false
    caption: params.caption
    viewrecords: true
    postData:
      filter: ->
        $("#filter").val()
      'item[brand]': ->
        $("#item_brand").val()
      'item[description]': ->
        $("#item_description").val()
      'item[code]': ->
        $("#item_code").val()
      'item[model]': ->
        $("#item_model").val()
      'item[sell_price][compare]': ->
        $("#item_sell_price_compare").val()
      'item[sell_price][value]': ->
        $("#item_sell_price_value").val()
      'item[total_stock][compare]': ->
        $("#item_total_stock_compare").val()
      'item[total_stock][value]': ->
        $("#item_total_stock_value").val()
      'item[net_free_stock][compare]': ->
        $("#item_net_free_stock_compare").val()
      'item[net_free_stock][value]': ->
        $("#item_net_free_stock_value").val()
    onSelectRow: (ids) ->
      window.current_row = ids
    onCellSelect: (rowId, iCol) ->
      on_cell_select(rowId, iCol, params)
    gridComplete: ->
      i = 0
      while i < window.for_highlight?.length
        if JSON.stringify(jQuery(params.list_selector).getRowData(window.for_highlight[i][0])) != "{}"
          jQuery(params.list_selector).jqGrid('setCell',
                                              window.for_highlight[i][0],
                                              window.for_highlight[i][1],
                                              window.for_highlight[i][2],
                                              "editable_#{window.for_highlight[i][1]+1}_#{window.for_highlight[i][0]}"
                                              )
          jQuery('.editable_'+ (window.for_highlight[i][1]+1) + '_' + window.for_highlight[i][0] ).attr("style", "background: #8bd1dc;")
        i++
  ).navGrid params.pager_selector,
    { edit: false, add: false, del: true, search: false, refresh: false, loadui: "enable" }
    { url: '#' } # edit options
    {url: '#' } #  add options
    {url: params.delete_url,  msg: 'Are you sure?\nThis action is irreversable.', caption: 'Delete selected Bid', mtype: 'POST'} # delete options
    {} # search options
    {} # refresh options
  .navButtonAdd params.pager_selector,
    caption: ""
    title: "Reload Grid"
    buttonicon: "ui-icon-refresh"
    onClickButton: ->
      window.for_save = []
      window.for_highlight = []
      clearFilter()
      $(params.list_selector).setGridParam({postData:{filter: false}}).trigger("reloadGrid", [{page: 1}]);
  .navButtonAdd params.pager_selector,
    caption:"Save"
    buttonicon: "ui-icon-check"
    position: "last"
    title:"Save changes"
    cursor: "pointer"
    datatype: "json"
    onClickButton: ->
      if window.save_bd == true
        if JSON.stringify(window.for_save) != "[]"
          jQuery.ajax({
            type: "POST",
            contentType: "application/json",
            url: params.update_url,
            data: JSON.stringify(window.for_save),
            dataType: "json"
            })
          jQuery(params.list_selector).trigger('reloadGrid')
        window.save_bd = false
        window.for_save = []
        window.for_highlight = []
  jQuery(params.list_selector).jqGrid('filterToolbar', { searchOnEnter:false, defaultSearch: 'cn' })

#  jQuery(params.refresh_list_selector).click ->
#    window.for_save = []
#    window.for_highlight = []
#    clearFilter()
#    $(params.list_selector).setGridParam({postData:{filter: false}}).trigger("reloadGrid", [{page: 1}]);

#===============================New Initializers=====================================================#

#==================================Activity grid================================================
@initialize_activity_grid = (params = {}) ->
  content_width = parseInt(jQuery(".work-area").css("width"))

#  content_width = 1100 if content_width < 1100
  table_w = content_width
  this_content_width = content_width
#  this_content_width = 1170 if content_width < 1170
  one = this_content_width/6

  id_w = one
  name_w = one*3
  at_time_w = one*2-30

  jQuery(params.list_selector).jqGrid(
    shrinkToFit: false
    width: table_w
    height: "475px"
    ignoreCase: true
    url: params.index_url
    datatype: "json"
    colNames: ["Id", "Activity Name", "Date"]
    colModel: [
      name: "activities.id"
      index: "activities.id"
      width: id_w
    ,
      name: "statuses.name"
      index: "statuses.name"
      width: name_w
    ,
      name: "at_timet"
      index: "at_time"
      width: at_time_w
    ]
    rowNum: 50
    rowList: [5, 10, 20, 50, 100]
    pager: params.pager_selector
    multiselect: false
    loadonce: false
    caption: params.caption
    viewrecords: true
  ).navGrid params.pager_selector,
    { edit: false, add: false, del: false, search: false, refresh: true, loadui: "enable" }
    { url: '#' } # edit options
    {url: '#' } #  add options
    {url: params.delete_url,  msg: 'Are you sure?\nThis action is irreversable.', caption: 'Delete selected Bid', mtype: 'POST'} # delete options
    {} # search options
    {} # refresh options
  jQuery(params.list_selector).jqGrid('filterToolbar', { searchOnEnter:false, defaultSearch: 'cn' })

#==============================Store grid======================================================

@initialize_store_grid = (params = {}) ->
  content_width = parseInt(jQuery(".work-area").css("width"))

  table_w = content_width
  this_content_width = content_width
  one = this_content_width/15

  id_w = one
  name_w = one*3
  desc_w = one*5
  count_w = one*2
  crit_w = one*2
  type_w = one+10

  jQuery(params.list_selector).jqGrid(
    shrinkToFit: false
    width: table_w
    height: "475px"
    ignoreCase: true
    url: params.index_url
    datatype: "json"
    colNames: ["Id", "Name", "Description", "Count", "Criticall Count", "Type"]
    colModel: [
      name: "id"
      index: "id"
      width: id_w
      editable: false
      editoptions:
        readonly: true
        size: 10
    ,
      name: "item[name]"
      index: "name"
      width: name_w
      editable: true
      editoptions:
        size: 10
    ,
      name: "item[description]"
      index: "description"
      width: desc_w
      editable: true
      edittype: "textarea"
      editoptions:
        rows: "2"
        cols: "21"
    ,
      name: "item[count]"
      index: "count"
      width: count_w
      align: "right"
      editable: true
      editoptions:
        size: 10
    ,
      name: "item[crit_count]"
      index: "crit_count"
      width: crit_w
      align: "right"
      editable: true
      editoptions:
        size: 10
    ,
      name: "item[item_type]"
      index: "item_type"
      width: type_w
      align: "right"
      editable: true
      editoptions:
        size: 10
    ]
    rowNum: 10
    rowList: [10, 20, 30]
    pager: params.pager_selector
    viewrecords: true
    caption: params.caption
    editurl: params.edit_url
    )
  jQuery(params.list_selector).jqGrid "navGrid", params.pager_selector, {}, #options
    height: 300 # edit options
    width: 350 # edit options
    reloadAfterSubmit: true
    closeAfterEdit: true
  ,
    height: 300 # add options
    width: 350 # add options
    reloadAfterSubmit: true
    closeAfterAdd: true
  ,
    reloadAfterSubmit: false # del options
    url: params.delete_url
  , {} # search options

  jQuery(params.list_selector).jqGrid('filterToolbar', { searchOnEnter:false, defaultSearch: 'cn' })

#=============================Store Activity grid=============================================
@initialize_store_act_grid = (params = {}) ->
  content_width = parseInt(jQuery(".work-area").css("width"))

  table_w = content_width
  this_content_width = content_width
  one = this_content_width/13

  email_w = one*2
  it_name_w = one * 3 - 20
  stat_name_w = one *2
  count_w = one * 1
  crit_w = one * 1
  rem_w = one * 2
  date_w = one * 2 - 30

  jQuery(params.list_selector).jqGrid(
    shrinkToFit: false
    width: table_w
    height: "475px"
    ignoreCase: true
    url: params.index_url
    datatype: "json"
    colNames: ["User Email", "Item Name", "Action", "Count", "Is Critical" ,"Availible Count", "Date" ]
    colModel: [
      name: "users.email"
      index: "users.email"
      width: email_w
    ,
      name: "items.name"
      index: "items.name"
      width: it_name_w
    ,
      name: "statuses.name"
      index: "statuses.name"
      width: stat_name_w
    ,
      name: "count"
      index: "count"
      width: count_w
    ,
      name: "critical"
      index: "critical"
      width: crit_w
    ,
      name: "remaider"
      index: "remainder"
      width: rem_w
    ,
      name: "move_date"
      index: "move_date"
      width: date_w
    ]
    rowNum: 50
    rowList: [5, 10, 20, 50, 100]
    pager: params.pager_selector
    multiselect: false
    loadonce: false
    caption: params.caption
    viewrecords: true
    grouping:true
    groupingView:
      groupField: ['move_date']
      groupText: ['<b>{0} - {1} Item(s)</b>']
  ).navGrid params.pager_selector,
    { edit: false, add: false, del: false, search: false, refresh: true, loadui: "enable" }
    { url: '#' } # edit options
    {url: '#' } #  add options
    {url: params.delete_url,  msg: 'Are you sure?\nThis action is irreversable.', caption: 'Delete selected Bid', mtype: 'POST'} # delete options
    {} # search options
    {} # refresh options
  jQuery(params.list_selector).jqGrid('filterToolbar', { searchOnEnter:false, defaultSearch: 'cn' })

#==============================================Functions===============================================================

@on_cell_select = (rowId, iCol, params = {}) ->
  change_rows = []
  window.for_save = []
  change_cell = false
  cellValue = jQuery(params.list_selector).jqGrid('getCell',rowId, iCol)
  jQuery(params.list_selector).jqGrid('setCell',rowId, iCol, cellValue, "editable_#{iCol+1}_#{rowId}")
  cellClass = jQuery(".editable_" +"#{iCol+1}" + "_" + "#{rowId}").attr("class")
  if iCol+1 in params.allowed_cols or params.allowed_cols[0] == "all"
    jQuery("." + cellClass).html("<input value='" + cellValue + "' class='" + cellClass + "_input' style='width:100%;'></input>")
  jQuery("." + cellClass + "_input").trigger("focus").trigger("onCellSelect").blur ->
    inputValue = jQuery("." + cellClass + "_input").attr("value")
    jQuery("." + cellClass).html(inputValue)
    if window.change_cell == true
      i = 0
      repeat_row = false
      while i < window.for_save?.length
        if window.for_save[i].id == rowId
          window.for_save[i] =
            id : rowId
            data:
              code : jQuery(params.list_selector).jqGrid('getCell',rowId, 0)
              description : jQuery(params.list_selector).jqGrid('getCell',rowId, 1)
              net_free_stock : jQuery(params.list_selector).jqGrid('getCell',rowId, 2)
              category : jQuery(params.list_selector).jqGrid('getCell',rowId, 3)
              sell_price : jQuery(params.list_selector).jqGrid('getCell',rowId, 4)
              brand : jQuery(params.list_selector).jqGrid('getCell',rowId, 5)
              model : jQuery(params.list_selector).jqGrid('getCell',rowId, 6)
              total_stock : jQuery(params.list_selector).jqGrid('getCell',rowId, 7)
          repeat_row = true
          break
        i = i + 1
      if repeat_row == false
        window.for_save?.push
          id : rowId
          data:
            code : jQuery(params.list_selector).jqGrid('getCell',rowId, 0)
            description : jQuery(params.list_selector).jqGrid('getCell',rowId, 1)
            net_free_stock : jQuery(params.list_selector).jqGrid('getCell',rowId, 2)
            category : jQuery(params.list_selector).jqGrid('getCell',rowId, 3)
            sell_price : jQuery(params.list_selector).jqGrid('getCell',rowId, 4)
            brand : jQuery(params.list_selector).jqGrid('getCell',rowId, 5)
            model : jQuery(params.list_selector).jqGrid('getCell',rowId, 6)
            total_stock : jQuery(params.list_selector).jqGrid('getCell',rowId, 7)
      i = 0
      repeat_cell = false
      while i < window.for_highlight?.length
        if (window.for_highlight[i][0] == rowId && window.for_highlight[i][1] == iCol)
          window.for_highlight[i][2] = jQuery(params.list_selector).jqGrid('getCell',rowId, iCol)
          repeat_cell = true
          break
        i = i + 1
      if repeat_cell == false
        change_rows[0] = rowId
        change_rows[1] = iCol
        change_rows[2] = jQuery(params.list_selector).jqGrid('getCell',rowId, iCol)
        window.for_highlight.push change_rows
        change_rows = []
    window.change_cell = false

  jQuery("." + cellClass + "_input").change ->
    window.change_cell = true
    window.save_bd = true
    jQuery("." + cellClass).attr("style", "background: #8bd1dc;")

  jQuery("." + cellClass + "_input").keypress (e)->
    if e.which is 13
      jQuery("." + cellClass + "_input").trigger("change").trigger("blur")

@clearFilter = () ->
  $('input[id *= "item_"]').val("")
  $('#filter_form select').val($('#filter_form select option:first').val())
  $('input#filter').val(false)