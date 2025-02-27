module JsonHelper
  def expect_json_response_to_be_paginated(json_response)
    expect(json_response.dig(:links, :first)).not_to be_nil
    expect(json_response.dig(:links, :last)).not_to be_nil
    expect(json_response.dig(:links, :next)).not_to be_nil
    expect(json_response.dig(:links, :prev)).not_to be_nil
  end
end
