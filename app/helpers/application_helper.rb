module ApplicationHelper

  def add_color_picker_lib()
    stylesheet_link_tag('colorpicker', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/prototype', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/scriptaculous', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/builder', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/effects', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/dragdrop', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/controls', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/slider', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/yahoo', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/colorpicker', :plugin => 'redmine_daily_todos')
  end
  
  def wikitoolbar_with_color_for(field_id, jstoolbar_obj_name ,color_picker_text_id)
    url = "#{Redmine::Utils.relative_url_root}/help/wiki_syntax.html"

    help_link = l(:setting_text_formatting) + ': ' +
      link_to(l(:label_help), url,
      :onclick => "window.open(\"#{ url }\", \"\", \"resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes\"); return false;")

    javascript_tag("var colorPickerTextId = '#{color_picker_text_id}';") +
      javascript_include_tag('jstoolbar/jstoolbar', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('jstoolbar/textile', :plugin => 'redmine_daily_todos') +
      javascript_include_tag("jstoolbar/lang/jstoolbar-#{current_language.to_s.downcase}", :plugin => 'redmine_daily_todos') +
      javascript_tag("var #{jstoolbar_obj_name} = new jsToolBar($('#{field_id}')); #{jstoolbar_obj_name}.setColorPickerTextId('#{color_picker_text_id}') ; #{jstoolbar_obj_name}.setHelpLink('#{help_link}'); #{jstoolbar_obj_name}.draw();") +
      javascript_tag("var #{jstoolbar_obj_name}_colorPicker = new Control.ColorPicker('#{color_picker_text_id}', #{jstoolbar_obj_name}, { IMAGE_BASE : '/plugin_assets/redmine_daily_todos/images/color_picker/' });")
  end
end
