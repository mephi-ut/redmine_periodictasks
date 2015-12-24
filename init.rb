require 'redmine'

Redmine::Plugin.register :redmine_periodictasks do
  name 'Redmine Periodictask plugin'
  author 'Tanguy de Courson, Julian Perelli, Kota Shiratsuka, Dmitry Yu Okunev'
  description 'This is a plugin for Redmine2 that will allow you to schedule a task to be assigned on a schedule'
  version '3.2.0'
  url 'https://github.com/mephi-ut/redmine_periodictasks'
  author_url 'http://jperelli.com.ar/'

  project_module :periodictasks do
    permission :periodictasks, {:periodictasks => [:index, :show, :edit, :update, :delete, :new, :create, :destroy]}
  end

  menu :project_menu, :periodictasks, { :controller => 'periodictasks', :action => 'index' }, :caption => :label_periodictask, :after => :settings, :param => :project_id
end
