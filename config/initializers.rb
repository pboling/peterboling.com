# Welcome to Bridgetown!
#
# This configuration file is for settings which affect your whole site.
#
# For more documentation on using this initializers file, visit:
# https://www.bridgetownrb.com/docs/configuration/initializers/
#
# A list of all available configuration options can be found here:
# https://www.bridgetownrb.com/docs/configuration/options
#
# For technical reasons, this file is *NOT* reloaded automatically when you use
# `bin/bridgetown start`. If you change this file, please restart the server process.
#
# For reloadable site metadata like title, SEO description, social media
# handles, etc., take a look at `src/_data/site_metadata.yml`

Bridgetown.configure do |config|
  # The base hostname & protocol for your site, e.g. https://example.com
  url ""

  # Available options are `erb` (default), `serbea`, or `liquid`
  template_engine "erb"

  # Configure permalinks for posts
  permalink "posts/:categories/:title/"

  # Enable pagination
  pagination do
    enabled true
  end

  # Configure collections for project-specific blogs
  collections do
    def project(name)
      instance_eval do |it|
        it.send(name) do
          output true
          permalink "/:collection/:title/"
        end
      end
    end
    project :blog
    project :active_security
    project :activerecord_tablefree
    project :activerecord_transactionable
    project :activesupport_broadcast_logger
    project :activesupport_logger
    project :activesupport_tagged_logging
    project :anonymous_active_record
    project :skywalking_eyes
    project :appraisal2
    project :archivist_client
    project :awesome_search
    project :awesome_sponsorships
    project :bash_step
    project :bsfl
    project :cacheable_flash
    project :capistrano_mailer
    project :celluloid_io_pg_listener
    project :controller_validator
    project :csv_pirate
    project :debug_logging
    project :destination_errors
    project :dry_views
    project :dynamoid
    project :each_in_batches
    project :flag_shih_tzu
    project :floss_funding
    project :gem_bench
    project :gitmoji_regex
    project :humorous_log_formatter
    project :include_with_respect
    project :json_schemer_fuzz
    project :kettle_dev
    project :kettle_soup_cover
    project :kettle_test
    project :letter_group
    project :library_tree
    project :logos
    project :masq
    project :masq2
    project :month_serializer
    project :oauth
    project :oauth_tty
    project :oauth2
    project :omniauth_identity
    project :omniauth_jwt
    project :omniauth_jwt2
    project :omniauth_ldap
    project :omniauth_openid
    project :open_id_authentication
    project :os
    project :pretty_feed
    project :qfill
    project :rack_insight
    project :rack_openid
    project :rack_openid2
    project :rack_toolbar
    project :rails_env_local
    project :react_rails_benchmark_renderer
    project :remit
    project :require_bench
    project :resque
    project :resque_lonely_job
    project :resque_unique_at_runtime
    project :resque_unique_by_arity
    project :resque_unique_in_queue
    project :rots
    project :rspec_block_is_expected
    project :rspec_pending_for
    project :rspec_stubbed_env
    project :rubocop_lts
    project :rubocop_ruby1_8
    project :rubocop_ruby1_9
    project :rubocop_ruby2_0
    project :rubocop_ruby2_1
    project :rubocop_ruby2_2
    project :rubocop_ruby2_3
    project :rubocop_ruby2_4
    project :rubocop_ruby2_5
    project :rubocop_ruby2_6
    project :rubocop_ruby2_7
    project :rubocop_ruby3_0
    project :rubocop_ruby3_1
    project :rubocop_ruby3_2
    project :ruby_openid
    project :ruby_openid2
    project :sanitize_email
    project :seed_migration
    project :sequential_file
    project :service_actor_promptable
    project :shields_badge
    project :shiftable
    project :silent_stream
    project :simple_column_scopes
    project :snaky_hash
    project :spyke_connection_lambda
    project :stackable_flash
    project :standard_rubocop_lts
    project :status_tag
    project :stone_checksums
    project :strict_states
    project :super_exception_notifier
    project :timecop_rspec
    project :undrive_google
    project :version_gem
    project :warden_oauth
    project :yacs
    project :ast_merge
    project :bash_merge
    project :bson
    project :bundler
    project :commonmarker_merge
    project :cyclonedx_ruby
    project :dotenv_merge
    project :gemfile_go
    project :hashie
    project :json_merge
    project :jsonc_merge
    project :magnus
    project :markdown_merge
    project :markly_merge
    project :ore_light
    project :prism_merge
    project :psych_merge
    project :rails
    project :rb_sys
    project :rbs_merge
    project :rexml
    project :ruby_tree_sitter
    project :rv
    project :setup_ruby_flash
    project :token_resolver
    project :toml_merge
    project :tree_haver
    project :tree_stump
    project :yaml_converter
    project :yard_fence
    project :yard_yaml
  end

  # Other options you might want to investigate:

  # See list of timezone values here:
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  #
  # timezone "America/Los_Angeles"

  # Add collection pagination features to your site. Documentation here:
  # https://www.bridgetownrb.com/docs/content/pagination
  #
  # pagination do
  #   enabled true
  # end

  # Configure the permalink style for pages and posts. Custom collections can be
  # configured separately under the `collections` key. Documentation here:
  # https://www.bridgetownrb.com/docs/content/permalinks
  #
  # permalink "simple"

  # Optionally host your site off a path, e.g. /blog. If you set this option,
  # ensure you use the `relative_url` helper for all links and assets in your HTML.
  # If you're using esbuild for frontend assets, edit `esbuild.config.js` to
  # update `publicPath`.
  #
  # base_path "/"

  # You can also modify options on this configuration object directly, like so:
  #
  # config.autoload_paths << "models"

  # If you find you're having trouble using the new Fast Refresh feature in development,
  # you can disable it to force full rebuilds instead:
  #
  # fast_refresh false

  # You can use `init` to initialize various Bridgetown features or plugin gems.
  # For example, you can use the Dotenv gem to load environment variables from
  # `.env`. Just `bundle add dotenv` and then uncomment this:
  #
  # init :dotenv
  #

  # Uncomment to use Bridgetown SSR (aka dynamic rendering of content via Roda):
  #
  # init :ssr
  #
  # Add `sessions: true` if you need to use session data, flash, etc.
  #

  # Uncomment to use file-based dynamic template routing via Roda (make sure you
  # uncomment the gem dependency in your `Gemfile` as well):
  #
  # init :"bridgetown-routes"
  #
  # NOTE: you can remove `init :ssr` if you load this initializer
  #

  # We also recommend that if you're using Roda routes you include this plugin
  # so you can get a generated routes list in `.routes.json`. You can then run
  # `bin/bridgetown roda:routes` to print the routes. (This will require you to
  # comment your route blocks. See example in `server/routes/hello.rb.sample`.)
  #
  # only :server do
  #   init :parse_routes
  # end
  #

  # You can configure the inflector used by Zeitwerk and models. A few acronyms are provided
  # by default like HTML, CSS, and JS, so a file like `html_processor.rb` could be defined by
  # `HTMLProcessor`. You can add more like so:
  #
  # config.inflector.configure do |inflections|
  #   inflections.acronym "W3C"
  # end
  #
  # Bridgetown's inflector is based on Dry::Inflector so you can read up on how to add inflection
  # rules here: https://dry-rb.org/gems/dry-inflector/1.0/#custom-inflection-rules

  # For more documentation on how to configure your site using this initializers file,
  # visit: https://edge.bridgetownrb.com/docs/configuration/initializers/
end
