source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

group :development, :test do
  gem 'colorize', '0.8.1'
  gem 'terminal-table', '3.0.1'

  %w[rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, git: "https://github.com/rspec/#{lib}.git"
  end

  gem 'simplecov', require: false
end