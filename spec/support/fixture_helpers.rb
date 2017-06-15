# Set of helper methods related to test fixtures.
module FixtureHelpers
  # @param [String] relative_path The path to a file, relative to the fixtures directory.
  # @return [File]
  def fixture(relative_path)
    File.new("#{fixture_path}/#{relative_path}")
  end

  # @return [String] Directory path to fixture files
  def fixture_path
    File.expand_path('../../fixtures', __FILE__)
  end
end
