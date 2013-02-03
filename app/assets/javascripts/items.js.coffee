# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  initialize_store_grid
    list_selector:  '#item_list'
    pager_selector: '#item_pager'
    refresh_list_selector: ''
    index_url:      '/items'
    update_url:     ''
    delete_url:     '/destroy_item'
    edit_url:       '/items'
    caption:        'Store'
    allowed_cols:   ['all']
