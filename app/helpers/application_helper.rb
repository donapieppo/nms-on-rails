module ApplicationHelper
  def horizontal_form_for(record, options={}, &block)
    simple_form_for(record, options.merge({html: { class: 'form-horizontal' }, wrapper: :horizontal_form}), &block)
  end
end
