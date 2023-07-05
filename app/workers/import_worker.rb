class ImportWorker
  include Sidekiq::Worker

  def perform
    @repertori = get_atlante_request("https://atlantetest.inapp.org/api/v2/repertori")
    qnqrs = []
    counter = 0
    @repertori.dig("result").each do |r|
      page = 1
      while page > 0
        result = get_qnqr(r["repertorio"], page)
        if result.present?
          qnqrs << result.map.with_index do |a, index|
            counter += 1
            a.merge("repertorio" => r["repertorio"], "page" => page, "uuid" => counter)
          end
          page += 1
        else
          page = 0
        end
      end
    end
    File.write(Rails.root.join("lib", './sample-data.json'), JSON.pretty_generate(qnqrs.flatten))
    File.write(Rails.root.join("lib", './sample-data-ridotto.json'), JSON.pretty_generate(qnqrs.flatten.map{ |hash| hash.slice("codice", "titolo", "settore", "ada", "repertorio", "page", "uuid") }))
  end

  def get_qnqr(r, page)
    json = get_atlante_request("https://atlantetest.inapp.org/api/v2/qnqr?repertorio=#{r}&page=#{page}")
    if json["code"] == 200
      json["result"]
    else
      []
    end
  end

  def get_atlante_request(url)
    begin
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "*/*"

      request.delete("user-agent")

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      content = response.body.force_encoding("UTF-8")
      content.gsub!("\xEF\xBB\xBF".force_encoding("UTF-8"), '')
      JSON.parse(content)
    rescue
      {}
    end

  end

end