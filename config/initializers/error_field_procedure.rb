# Default puts DIVs around fields with errors
# Which messes up form formatting
# Instead, add class to the element, which will make it red
ActionView::Base.field_error_proc =
  Proc.new { |html_tag, instance| html_tag.sub('/>','class="error" />').html_safe}

