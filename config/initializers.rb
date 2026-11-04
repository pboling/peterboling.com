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

  # Configure bridgetown-feed plugin
  feed do
    collections do
      # Personal blog collection
      blog {}
      # Project collections - these will generate /feed/<collection>.xml
      # Only include projects that have posts (active ones with releases)
      active_security {}
      activerecord_tablefree {}
      activerecord_transactionable {}
      activesupport_broadcast_logger {}
      activesupport_logger {}
      activesupport_tagged_logging {}
      anonymous_active_record {}
      skywalking_eyes {}
      appraisal2 {}
      archivist_client {}
      awesome_search {}
      awesome_sponsorships {}
      bash_step {}
      bsfl {}
      cacheable_flash {}
      capistrano_mailer {}
      celluloid_io_pg_listener {}
      controller_validator {}
      csv_pirate {}
      debug_logging {}
      destination_errors {}
      dry_views {}
      dynamoid {}
      each_in_batches {}
      flag_shih_tzu {}
      floss_funding {}
      gem_bench {}
      gitmoji_regex {}
      humorous_log_formatter {}
      include_with_respect {}
      json_schemer_fuzz {}
      kettle_dev {}
      kettle_soup_cover {}
      kettle_test {}
      letter_group {}
      library_tree {}
      logos {}
      masq {}
      masq2 {}
      month_serializer {}
      oauth {}
      oauth_tty {}
      oauth2 {}
      omniauth_identity {}
      omniauth_jwt {}
      omniauth_jwt2 {}
      omniauth_ldap {}
      omniauth_openid {}
      open_id_authentication {}
      os {}
      pretty_feed {}
      qfill {}
      rack_insight {}
      rack_openid {}
      rack_openid2 {}
      rack_toolbar {}
      rails_env_local {}
      react_rails_benchmark_renderer {}
    end
  end

  init :"bridgetown-feed"

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
    project :alef
    project :anonymous_loader
    project :appraisal2_rubocop
    project :ast_crispr
    project :ast_crispr_markdown_markly
    project :ast_crispr_ruby_prism
    project :ast_crispr_toml
    project :ast_crispr_yaml_psych
    project :ast_merge
    project :ast_merge_git
    project :ast_template
    project :auth_sanitizer
    project :bash_merge
    project :binary_merge
    project :bson
    project :bundler
    project :citrus_toml_merge
    project :commonmarker_merge
    project :config_merge
    project :cyclonedx_ruby
    project :dotenv_merge
    project :gem_mine
    project :gemfile_go
    project :github_com_structuredmerge_structuredmerge_go
    project :go_merge
    project :hashie
    project :html_merge
    project :json_merge
    project :jsonc_merge
    project :kettle_changelog
    project :kettle_drift
    project :kettle_family
    project :kettle_gha_pins
    project :kettle_jem
    project :kettle_jem_appraisals
    project :kettle_ndjson
    project :kettle_paths
    project :kettle_rb
    project :kettle_rusty
    project :kettle_wash
    project :kramdown_merge
    project :magnus
    project :markdown_merge
    project :markly_merge
    project :nomono
    project :oauth2_mcp
    project :ore_light
    project :parslet_toml_merge
    project :pest_toml_merge
    project :plain_merge
    project :prism_merge
    project :psych_merge
    project :pulldown_cmark_merge
    project :pypi_tree_sitter_language_pack
    project :rails
    project :rb_sys
    project :rbs_merge
    project :rexml
    project :rubocop_lts_rspec
    project :rubocop_lts_ruby
    project :ruby_merge
    project :ruby_tree_sitter
    project :runtime_groups
    project :rust_ast_merge
    project :rust_ast_template
    project :rust_go_merge
    project :rust_json_merge
    project :rust_markdown_merge
    project :rust_merge
    project :rust_plain_merge
    project :rust_ruby_merge
    project :rust_rust_merge
    project :rust_tree_haver
    project :rust_typescript_merge
    project :rust_yaml_merge
    project :rv
    project :setup_ruby_flash
    project :smorg_rb
    project :structuredmerge_ast_merge
    project :structuredmerge_ast_template
    project :structuredmerge_binary_merge
    project :structuredmerge_go_merge
    project :structuredmerge_js_yaml_merge
    project :structuredmerge_json_merge
    project :structuredmerge_kettle_nodule
    project :structuredmerge_markdown_it_merge
    project :structuredmerge_markdown_merge
    project :structuredmerge_peggy_toml_merge
    project :structuredmerge_plain_merge
    project :structuredmerge_ruby_merge
    project :structuredmerge_rust_merge
    project :structuredmerge_toml_merge
    project :structuredmerge_tree_haver
    project :structuredmerge_typescript_compiler_merge
    project :structuredmerge_typescript_merge
    project :structuredmerge_yaml_merge
    project :structuredmerge_zip_merge
    project :token_resolver
    project :toml_merge
    project :tree_haver
    project :tree_stump
    project :turbo_tests2
    project :typescript_merge
    project :yaml_converter
    project :yaml_merge
    project :yaml_serde_merge
    project :yard_fence
    project :yard_timekeeper
    project :yard_yaml
    project :zip_merge
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
