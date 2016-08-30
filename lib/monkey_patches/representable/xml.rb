module Representable
  module XML
    private

    def parse_xml(doc, *args)
      node = Nokogiri::XML(doc) { |config| config.strict }

      node.remove_namespaces! if remove_namespaces?
      node.root
    end
  end
end
