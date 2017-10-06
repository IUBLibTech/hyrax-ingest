module Hyrax
  module Ingest
    module Transformer
      class Base
        # no-op; intended to be overwritten
        def transform(value)
          value
        end
      end
    end
  end
end
