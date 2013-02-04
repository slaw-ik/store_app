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

#==================================Activity grid================================================
@initialize_activity_grid = (params = {}) ->
  content_width = parseInt(jQuery(".work-area").css("width"))

  table_w = content_width
  this_content_width = content_width
  one = this_content_width/6

  id_w = one
  name_w = one*3
  at_time_w = one*2-30

  jQuery(params.list_selector).jqGrid(
    shrinkToFit: false
    firstsortorder: 'desc'
    sortorder: 'desc'
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
      editrules:
        required: true
      editoptions:
        readonly: true
        size: 10
    ,
      name: "item[name]"
      index: "name"
      width: name_w
      editable: true
      editrules:
        required: true
      editoptions:
        size: 10
    ,
      name: "item[description]"
      index: "description"
      width: desc_w
      editable: true
      edittype: "textarea"
      editrules:
        required: true
      editoptions:
        rows: "2"
        cols: "21"
    ,
      name: "item[count]"
      index: "count"
      width: count_w
      align: "right"
      editable: true
      editrules:
        required: true
        integer: true
        minValue: 1
      editoptions:
        size: 10
    ,
      name: "item[crit_count]"
      index: "crit_count"
      width: crit_w
      align: "right"
      editable: true
      editrules:
        required: true
        integer: true
        minValue: 0
      editoptions:
        size: 10
    ,
      name: "item[item_type]"
      index: "item_type"
      width: type_w
      align: "right"
      editable: true
      editrules:
        required: true
        integer: true
        minValue: 0
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