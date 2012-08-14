
$(document).ready(function() {
  // Use jQuery extension (included in jquery.observe_field.js) to observe field
  $("#script_search_name").observe_field(0.5, function() {
    var form, formData, url;
    form = $(this).parents("form");
    url = form.attr("action");
    formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#record_list").html(html);
    });
  });
  // Use jQuery extension (included in jquery.observe_field.js) to observe field
  $("#script_category_id").observe_field(0.5, function() {
    var form, formData, url;
    form = $(this).parents("form");
    url = form.attr("action");
    formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#record_list").html(html);
    });
  });
  // Override click handle for query test button
  $("#query_test_button").click(function(e) {
    e.preventDefault();
    // Show spinner
    $("#spinner_qry").removeClass("invisible");
    // Post just the query type, query_text and script_timeout fields
    var url = $(this).attr("data-url");
    // Make POST request
    $.post(url, $("#script_query_type,#script_query_text,#script_timeout_sec").serialize(), function( data ) {
        $("#query_test_result").html(data);
    }).error(function(jqXHR, textStatus, errorThrown) {
        $("#query_test_result").html("<p class=\"error_text\"> Error sending request: "+textStatus+"</p>")
    }).complete(function() {
        // Hide spinner
        $("#spinner_qry").addClass("invisible");
    });    
  });
  // Override click handle for expression test button
  $("#expression_test_button").click(function(e) {
    e.preventDefault();
    // Show spinner
    $("#spinner_expr").removeClass("invisible");
    // Post just the query type, query_text, script_timeout and expression fields
    var url = $(this).attr("data-url");
    // Make POST request
    $.post(url, $("#script_query_type,#script_query_text,#script_timeout_sec,#script_expression_text").serialize(), function( data ) {
        $("#expression_test_result").html(data);
    }).error(function(jqXHR, textStatus, errorThrown) {
        $("#expression_test_result").html("<p class=\"error_text\"> Error sending request: "+textStatus+"</p>")
    }).complete(function() {
        // Hide spinner
        $("#spinner_expr").addClass("invisible");
    });
  });
  // Override click handle for query column rebuild button
  $("#rebuild_query_columns_button").click(function(e) {
    e.preventDefault();
    // Show spinner
    $("#spinner_rebuild").removeClass("invisible");
    // Post just the query type and text fields
    var url = $(this).attr("data-url");
    // Make POST request
    $.post(url, $("#script_query_type,#script_query_text,#script_timeout_sec").serialize(), function( data ) {
        $("#query_columns_list").html(data);
    }).error(function(jqXHR, textStatus, errorThrown) {
        $("#query_columns_list").html("<p class=\"error_text\"> Error sending request: "+textStatus+"</p>")
    }).complete(function() {
        // Hide spinner
        $("#spinner_rebuild").addClass("invisible");
    });
  });
  // Override click handle for message test button
  $("#message_test_button").click(function(e) {
    e.preventDefault();
    var url = $(this).attr("data-url");
    var params = $("#script_query_type,#script_query_text,#script_timeout_sec,#script_message_format,#script_message_subject,#script_message_header,#script_message_text_str,#script_message_footer").serialize()
    // Just open new window
    window.open(url+"?"+params, "Message Test", "width=600,height=400,scrollbars=yes");
  });
});