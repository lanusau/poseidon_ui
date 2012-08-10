// Use jQuery extension (included in jquery.observe_field.js) to observe field
$(document).ready(function() {
  $("#target_name").observe_field(1, function() {
    var form, formData, url;
    form = $(this).parents("form");
    url = form.attr("action");
    formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#record_list").html(html);
    });
  });
});