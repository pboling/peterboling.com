require_relative '../scripts/check_new_releases'

checker = ReleaseChecker.allocate
checker.instance_variable_set(:@state, { 'projects' => {} })
response = Struct.new(:code, :body).new('200', File.read(File.expand_path('fixtures/kettle_soup_changelog.md', __dir__)))
http = Net::HTTP.singleton_class
http.alias_method :original_start_for_test, :start
http.define_method(:start) { |*_, **_, &_| response }
begin
  release = checker.fetch_changelog('https://github.com/kettle-dev/kettle-soup-cover', 'v3.0.16')
  raise 'wrong release' unless release['version'] == '3.0.16'
  raise 'wrong coverage' unless release.dig('coverage', 'percent') == 99.67
  markdown = release.fetch('markdown')
  raise 'lost structure' unless markdown.include?("\n\n### Changed\n\n")
  raise 'included footer' if markdown.include?('Community support') || markdown.include?('Many paths lead to being a sponsor')
  raise 'missing release did not fail' unless checker.fetch_changelog('https://github.com/example/example', 'v9.0.0').nil?
ensure
  http.alias_method :start, :original_start_for_test
  http.remove_method :original_start_for_test
end
checker.define_singleton_method(:fetch_latest_github_release) { |_| { 'tag_name' => 'v1.0.0', 'published_at' => '2026-01-01T00:00:00Z' } }
checker.define_singleton_method(:fetch_changelog) { |*| nil }
project = { 'name' => 'example', 'release_date' => '2026-01-01', 'forges' => [{ 'type' => 'GitHub', 'url' => 'https://github.com/example/example' }] }
raise 'failed release was processed' unless checker.check_project(project).nil? && checker.state['projects'].empty?
puts 'Release checker tests passed'
