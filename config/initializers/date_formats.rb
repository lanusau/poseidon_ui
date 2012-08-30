
Date::DATE_FORMATS[:default] = '%m-%d-%Y'
Time::DATE_FORMATS[:default] = '%m-%d-%Y %H:%M:%S'

# Define custom validator that validates based on default format above
class DatetimeformatValidator < ActiveModel::EachValidator

  def validate(record)
    attributes.each do |attribute|
      value = record.read_attribute_for_validation(attribute)
      validate_each(record, attribute, value)
    end
  end

  def validate_each(record, attr_name, value)

    before_type_cast = "#{attr_name}_before_type_cast"

    raw_value = record.send(before_type_cast) if record.respond_to?(before_type_cast.to_sym)
    raw_value ||= value

    if (raw_value.nil? || raw_value.blank?)
      return if options[:allow_nil]
      record.errors.add(attr_name, (options[:message] || "must be set"))
      return
    end

    return if raw_value.acts_like?(:time)

    unless parse_raw_value_as_a_datetime(raw_value)
      record.errors.add(attr_name, (options[:message] || "invalid date"))
      return
    end
  end

  private

  def parse_raw_value_as_a_datetime(value)
    DateTime.strptime(value, Time::DATE_FORMATS[:default]) rescue nil
  end
end

# Extend ActiveRecord::Base to define set metod for datetime attributes
module ActiveRecord
  def Base.datetime_with_default_format(*attributes)
    options = attributes.extract_options!
    options.merge! :datetimeformat => true
    for attribute in attributes
      module_eval <<-"end_eval"
        # Modify datetime attribute method to accept datetime in default format
        def #{attribute.id2name}=(value)
        if value.class == String
          value = DateTime.strptime(value, Time::DATE_FORMATS[:default]) rescue value
        end
        super(value)
        end
      end_eval
      validates attribute,options
    end
  end
end