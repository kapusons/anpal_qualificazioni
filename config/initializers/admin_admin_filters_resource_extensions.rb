ActiveAdmin::Filters::ResourceExtension.module_eval do

  # Rimuovo la views dei filtri attivi
  # http://localhost:3000/admin/applications?q%5Bstatus_eq%5D=draft&commit=Filtra&order=id_desc
  def add_search_status_sidebar_section
    # self.sidebar_sections << ActiveAdmin::Filters::ActiveSidebar.new
  end


end