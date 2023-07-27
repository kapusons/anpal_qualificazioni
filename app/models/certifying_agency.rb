# == Schema Information
#
# Table name: certifying_agencies
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CertifyingAgency < ApplicationRecord

  validates :name, presence: true

  def self.find_repertorio(app)
    return nil if app.atlante_region.blank?
    begin
      el = mapping.find { |a| a[:repertorio] == app.atlante_region }
      r = CertifyingAgency.find_by(name: el[:region_name])
      Airbrake.notify("Repertorio #{app.atlante_region} non trovato") if r.nil?
      r.id
    rescue Exception => ex
      Airbrake.notify(ex)
    end
  end

  def self.mapping
    [
      { "id": "129", "repertorio": "Abruzzo", region_name: "Abruzzo" },
      { "id": "78", "repertorio": "Basilicata", region_name: "Basilicata" },
      { "id": "181", "repertorio": "Calabria", region_name: "Calabria" },
      { "id": "7", "repertorio": "Campania", region_name: "Campania" },
      { "id": "2", "repertorio": "Emilia-Romagna", region_name: "Emilia-Romagna" },
      { "id": "4", "repertorio": "Friuli Venezia Giulia", region_name: "Friuli-Venezia Giulia" },
      { "id": "9", "repertorio": "Lazio", region_name: "Lazio" },
      { "id": "5", "repertorio": "Liguria", region_name: "Liguria" },
      { "id": "64", "repertorio": "Lombardia", region_name: "Lombardia" },
      { "id": "124", "repertorio": "Marche", region_name: "Marche" },
      { "id": "179", "repertorio": "Molise", region_name: "Molise" },
      { "id": "6", "repertorio": "Piemonte", region_name: "Piemonte" },
      { "id": "128", "repertorio": "Provincia autonoma di Bolzano", region_name: "Provincia autonoma di Bolzano" },
      { "id": "79", "repertorio": "Provincia Autonoma di Trento", region_name: "Provincia autonoma di Trento " },
      { "id": "123", "repertorio": "Puglia", region_name: "Puglia" },
      { "id": "63", "repertorio": "Sardegna", region_name: "Sardegna" },
      { "id": "180", "repertorio": "Sicilia", region_name: "Sicilia" },
      { "id": "3", "repertorio": "Toscana", region_name: "Toscana" },
      { "id": "8", "repertorio": "Umbria", region_name: "Umbria" },
      { "id": "10", "repertorio": "Valle d'Aosta", region_name: "Valle d'Aosta/Vallée d'Aoste" },
      { "id": "178", "repertorio": "Veneto", region_name: "Veneto" }
    ]
  end
end
