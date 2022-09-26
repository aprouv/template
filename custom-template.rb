# Gemfile
inject_into_file "Gemfile", before: "group :development, :test do" do
  <<~RUBY
    gem "devise"
    gem "bootstrap"

  RUBY
end

inject_into_file "Gemfile", after: 'gem "debug", platforms: %i[ mri mingw x64_mingw ]' do
<<-RUBY

  gem "rspec-rails"
RUBY
end

after_bundle do

  # Devise install
  generate("devise:install")

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: "development"

  inject_into_file "app/views/layouts/application.html.erb", after: "<body>" do
    <<-HTML
      <% if notice %>
        <p class="alert alert-success"><%= notice %></p>
      <% end %>
      <% if alert %>
        <p class="alert alert-danger"><%= alert %></p>
      <% end %>
    HTML
  end

  #Bootstrap
  run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss"

  inject_into_file "app/assets/stylesheets/application.scss" do
    <<~RUBY
      @import "bootstrap";
    RUBY
  end

  #Rspec
  generate("rspec:install")

  # Git

  git :init
  git add: "."
  git commit: "-m 'Initial commit with custom rails template'"

end
