$(document).ready ->
  $("#script_search_name").observe_field 1, ->
    form = $(this).parents("form")
    url = form.attr "action"
    formData = form.serialize()
    $.get url, formData, (html) ->
      $("#record_list").html(html)