module ImageExternalService
  def self.get_image_details(id)
    # call external service...
    # { width: 42, height: 42 }
  end

  def self.upload_image_details(width:, height:)
    # call external service...
    # { id: 42 }
  end
end