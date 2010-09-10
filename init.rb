require 'redmine'

Redmine::Plugin.register :redmine_daily_todos do
  name 'Daily TODOs'
  author 'GNT'
  description 'A plugin for managing daily TODOs'
  version '0.0.1'

  menu :top_menu, :daily_todos,
    {:controller => 'daily_todos', :action => 'all_users'}, :caption => 'Daily TODOs'
end

@@id_count = 0
Redmine::WikiFormatting::Textile::Helper.module_eval do
  def wikitoolbar_for(field_id)
    @@id_count = (@@id_count + 1) % 1000
    wiki_name = "wikiToolbar_" + @@id_count.to_s

    url = "#{Redmine::Utils.relative_url_root}/help/wiki_syntax.html"

    help_link = l(:setting_text_formatting) + ': ' +
      link_to(l(:label_help), url,
      :onclick => "window.open(\"#{ url }\", \"\", \"resizable=yes, location=no, width=300, height=640, menubar=no, status=no, scrollbars=yes\"); return false;")

    javascript_tag("var currentWikiName = '#{wiki_name}';") +
    javascript_include_tag('jstoolbar/jstoolbar', :plugin => 'redmine_daily_todos') +
      javascript_include_tag('jstoolbar/textile', :plugin => 'redmine_daily_todos') +
      javascript_include_tag("jstoolbar/lang/jstoolbar-#{current_language.to_s.downcase}", :plugin => 'redmine_daily_todos') +
      javascript_tag("var #{wiki_name} = new jsToolBar($('#{field_id}'));  #{wiki_name}.setHelpLink('#{help_link}'); #{wiki_name}.setWikiName('#{wiki_name}'); #{wiki_name}.draw();") +
    javascript_tag("jscolor.install( #{wiki_name});")

  end

  def heads_for_wiki_formatter
    stylesheet_link_tag('jstoolbar') +
      stylesheet_link_tag('jstoolbar', :plugin => 'redmine_daily_todos')+
      javascript_include_tag('jscolor', :plugin => 'redmine_daily_todos')
  end
end

Redmine::WikiFormatting::Textile::Formatter.class_eval do
  def initialize(*args)
    super
    self.hard_breaks=true
    self.no_span_caps=true
    self.filter_styles=false
  end
end
