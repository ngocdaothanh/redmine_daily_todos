require 'redmine'

Redmine::Plugin.register :redmine_daily_todos do
  name 'Daily TODOs'
  author 'GNT'
  description 'A plugin for managing daily TODOs'
  version '0.0.1'

  menu :top_menu, :daily_todos,
    {:controller => 'daily_todos', :action => 'all_users'}, :caption => 'Daily TODOs'
end


# Overwrite Helper of wikiformarting 
@@id_count = 0
Redmine::WikiFormatting::Textile::Helper.module_eval do
  def wikitoolbar_for(field_id)
    @@id_count = (@@id_count + 1) % 1000
    jstoolbar_obj_name = "jstoolbar_" + @@id_count.to_s
    color_picker_text_id = "color_picker" + @@id_count.to_s

    url = "#{Redmine::Utils.relative_url_root}/help/wiki_syntax.html"

    help_link = l(:setting_text_formatting) + ': ' +
      link_to(l(:label_help), url,
      :onclick => "window.open(\"#{ url }\", \"\", \"resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes\"); return false;")

    add_color_picker_lib() +
      javascript_tag("var colorPickerTextId = '#{color_picker_text_id}';") +
      javascript_include_tag('jstoolbar/jstoolbar', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('jstoolbar/textile', :plugin => 'redmine_daily_todos') +
      javascript_include_tag("jstoolbar/lang/jstoolbar-#{current_language.to_s.downcase}", :plugin => 'redmine_daily_todos') +
      javascript_tag("var #{jstoolbar_obj_name} = new jsToolBar($('#{field_id}')); #{jstoolbar_obj_name}.setColorPickerTextId('#{color_picker_text_id}') ; #{jstoolbar_obj_name}.setHelpLink('#{help_link}'); #{jstoolbar_obj_name}.draw();") +
      javascript_tag("var #{jstoolbar_obj_name}_colorPicker = new Control.ColorPicker('#{color_picker_text_id}', #{jstoolbar_obj_name}, { IMAGE_BASE : '/plugin_assets/redmine_daily_todos/images/color_picker/' });")
  end

  def add_color_picker_lib()
    javascript_include_tag('color_picker/prototype', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/scriptaculous', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/builder', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/effects', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/dragdrop', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/controls', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/slider', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/yahoo', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('color_picker/colorpicker', :plugin => 'redmine_daily_todos') +
      javascript_tag("colorPickerLibAdded=true;")
  end

  def heads_for_wiki_formatter
    stylesheet_link_tag('jstoolbar') +
      stylesheet_link_tag('jstoolbar', :plugin => 'redmine_daily_todos') +
      stylesheet_link_tag('colorpicker', :plugin => 'redmine_daily_todos') +
      javascript_tag("var colorPickerLibAdded=false;")
  end
end


# Overwrite Formatter of wikiFormatting
Redmine::WikiFormatting::Textile::Formatter.class_eval do
  def initialize(*args)
    super
    self.hard_breaks=true
    self.no_span_caps=true
    self.filter_styles=false
  end
end
