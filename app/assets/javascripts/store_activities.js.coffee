# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  initialize_store_act_grid
    list_selector:  '#store_act_list'
    pager_selector: '#store_act_pager'
    refresh_list_selector: ''
    index_url:      '/store_activities'
    update_url:     ''
    delete_url:     ''
    edit_url:       ''
    caption:        'Store Activity'
    allowed_cols:   ['all']
