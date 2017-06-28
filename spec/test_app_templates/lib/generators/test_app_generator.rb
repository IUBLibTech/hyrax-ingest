        require 'rails/generators'

        class TestAppGenerator < Rails::Generators::Base
          source_root "./spec/test_app_templates"

          # if you need to generate any additional configuration
          # into the test app, this generator will be run immediately
          # after setting up the application

          def install_hyrax
            generate 'hyrax:install -f'
          end

          def create_test_work_types
            generate 'hyrax:work ExampleWork'
          end
        end
