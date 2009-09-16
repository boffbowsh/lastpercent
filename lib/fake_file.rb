class FakeFile < StringIO
  def self.from_anemone page
    fake_file = self.new page.doc.to_s
    fake_file.original_filename = page.url.to_s
    fake_file.content_type = page.content_type
    return fake_file
  end
  
  def self.from_net_http_response response, url
    fake_file = self.new response.body.to_s
    fake_file.original_filename = url.to_s
    fake_file.content_type = response.content_type
    return fake_fileatta
  end
end