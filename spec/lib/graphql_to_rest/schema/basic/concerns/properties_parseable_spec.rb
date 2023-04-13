# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::PropertiesParseable do # rubocop:disable RSpec/FilePath
  let(:dummy_class) do
    Class.new do
      include GraphqlToRest::Schema::Basic::PropertiesParseable

      attr_reader :route, :type_parser

      def initialize(route:, type_parser:)
        @route = route
        @type_parser = type_parser
      end
    end
  end

  let(:dummy_instance) { dummy_class.new(route: route, type_parser: type_parser) }
  let(:route) { build(:route_decorator) }
  let(:unparsed_type) { route.return_type }
  let(:type_parser) do
    GraphqlToRest::TypeParsers::GraphqlTypeParser.new(unparsed_type: unparsed_type)
  end

  describe '#unparsed_properties' do
    let(:unparsed_properties) { dummy_instance.send(:unparsed_properties) }
    let(:field) { unparsed_type.fields['id'] }

    context 'when all fields visible' do
      it 'returns visible properties' do
        expect(unparsed_properties.keys).to include(field.name)
      end
    end

    context 'when some fields not visible' do
      before do
        allow(field).to receive(:visible?).and_return(false)
      end

      it 'returns only visible properties' do
        expect(unparsed_properties.keys).not_to include(field.name)
      end

      it 'checks visibility with graphql context' do
        unparsed_properties
        expect(field).to have_received(:visible?).with(route.schema_builder.graphql_context)
      end
    end
  end
end
