# frozen_string_literal: true

RSpec.describe GraphqlToRest::TypeParsers::GraphqlInputTypeParser do
  subject(:graphql_type_name_parser) { described_class.new(unparsed_type: unparsed_type) }

  describe '#open_api_type_name' do
    subject(:open_api_type_name) { graphql_type_name_parser.open_api_type_name }

    let(:unparsed_type) { GraphQL::Types::String }

    context 'when type is basic' do
      it 'returns downcased type name' do
        expect(open_api_type_name).to eq('string')
      end
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType.to_non_null_type }

      it { is_expected.to eq('UserCreateInput') }
    end
  end

  describe '#inner_nullable_graphql_object' do
    subject(:inner_nullable_graphql_object) { graphql_type_name_parser.inner_nullable_graphql_object }

    let(:unparsed_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType.to_non_null_type }

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType.to_non_null_type }

      it 'returns unwrapped type' do
        expect(inner_nullable_graphql_object).to eq(GraphqlToRest::DummyApp1::Types::UserCreateInputType)
      end
    end
  end

  describe '#deeply_scalar?' do
    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.to be_deeply_scalar }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType }

      it { is_expected.not_to be_deeply_scalar }
    end

    context 'when type is Array with inner scalar type' do
      let(:unparsed_type) { GraphQL::Types::String.to_list_type.to_non_null_type }

      it { is_expected.to be_deeply_scalar }
    end
  end

  describe '#open_api_schema_reference' do
    subject(:open_api_schema_reference) { graphql_type_name_parser.open_api_schema_reference }

    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it 'returns basic type schema' do
        expect(open_api_schema_reference).to eq({ type: 'string' })
      end
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyApp1::Types::UserCreateInputType }

      it 'returns schema reference' do
        expect(open_api_schema_reference).to eq({ '$ref' => '#/components/requestBodies/UserCreateInput' })
      end
    end
  end
end
