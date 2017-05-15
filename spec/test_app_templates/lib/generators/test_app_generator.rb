        require 'rails/generators'

        class TestAppGenerator < Rails::Generators::Base
          source_root "./spec/test_app_templates"


          def install_hyrax
            generate 'hyrax:install'
          end

          def install_engine
            generate 'hyrax-ingest:install'
          end
        end

