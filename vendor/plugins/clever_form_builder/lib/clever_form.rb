module CleverForm
  class CleverFormBuilder < ActionView::Helpers::FormBuilder
  
    helpers = field_helpers +
      %w(date_select datetime_select time_select collection_select calendar_date_select) +
      %w(collection_select select country_select time_zone_select radios) -
      %w(label fields_for hidden_field)
    
    helpers.each do |name|
      define_method name do |field, *args|
        options = args.detect {|argument| argument.is_a?(Hash)} || {}
        options[:field_type] = name

        build_shell(field, options) do
          super
        end
      end
    end

    def build_shell(field, options)
      locals = {}
      locals[:label]       = build_label(field, options)
      locals[:div_class]   = build_class(field, options)
      locals[:div_id]      = build_id(field, options)
      locals[:help]        = options[:help]
      locals[:description] = options[:description]
      locals[:error]       = nil
      
      if @template.respond_to?(:capture_without_haml)
        capture_method = 'capture_without_haml'
      else
        capture_method = 'capture'
      end
      
      @template.send(capture_method) do
        if options.delete(:inline)
          options[:class] = 'inline_with_errors' if has_errors_on?(field)
          return yield
        end

        locals[:element] = yield
        locals.merge!(:error => error_message(field, options)) if has_errors_on?(field)
        @template.render :partial => 'partials/field', :locals => locals
      end
    end
      
    private
    
    def error_message(field, options)
      if has_errors_on?(field)
        errors = object.errors.on(field)
        errors.is_a?(Array) ? errors.to_sentence : errors
      else
        ''
      end
    end
  
    def has_errors_on?(field)
      !(object.nil? || object.errors.on(field).blank?)
    end

    def build_class(field, options = {})
      class_name  = ''
      class_name += 'form_' + options[:field_type] unless !options[:field_type] || options[:field_type].blank?
      class_name += ' form_item_with_error' if has_errors_on?(field)
      return class_name
    end

    def build_id(field, options = {})
      'field_'+ field.to_s
    end

    def build_label(field, options = {})
      label_text = label(field, options.delete(:label))
      required_field = options.delete(:required)
      if required_field
        label_text.insert(label_text.index('>') + 1, '<span class="star">*</span>')
      end
      label_text
    end
  end
  
  module CleverFormHelper
    # Customer Form Builders
    [:form_for, :fields_for, :form_remote_for, :remote_form_for].each do |meth|
      src = <<-end_src
        def clever_#{meth}(object_name, *args, &proc)
          options = args.last.is_a?(Hash) ? args.pop : {}
          options.update(:builder => CleverFormBuilder)
          #{meth}(object_name, *(args << options), &proc)
        end
      end_src
    
      module_eval src
    end
  end
end