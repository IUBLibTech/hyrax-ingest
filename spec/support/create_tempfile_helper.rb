require 'rspec'

module CreateTempfileHelper
  def create_tempfile(content=nil)
    Tempfile.new.tap do |file|
      file.write content if content
      file.close
    end
  end
end

RSpec.configure do |config|
  config.include CreateTempfileHelper
end
