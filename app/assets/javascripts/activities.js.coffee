# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  initialize_activity_grid
    list_selector:  '#list'
    pager_selector: '#pager'
    refresh_list_selector: ''
    index_url:      '/activities'
    update_url:     ''
    delete_url:     ''
    caption:        'My Activity'
    allowed_cols:   [5]
