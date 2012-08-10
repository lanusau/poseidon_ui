
$(document).ready(function() {
  // Use jQuery extension (included in jquery.observe_field.js) to observe field
  $("#script_search_name").observe_field(1, function() {
    var form, formData, url;
    form = $(this).parents("form");
    url = form.attr("action");
    formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#record_list").html(html);
    });
  });
  // Overrider click handle for query test button
  $("#query_test_button").click(function(e) {
    e.preventDefault();
    // Show spinner
    $("#spinner_qry").removeClass("invisible");
    // Post just the query type and text fields
    var url = $(this).attr("data-url");
    // Make POST request
    $.post(url, $("#script_query_type,#script_query_text,#script_timeout_sec").serialize(), function( data ) {
        $("#query_test_result").html(data);
    }).error(function(jqXHR, textStatus, errorThrown) {
        $("#query_test_result").html("<p class=\"error_text\"> Error testing query: "+textStatus+"</p>")
    }).complete(function() {
        // Hide spinner
        $("#spinner_qry").addClass("invisible");
    });
    
  });
});