# frozen_string_literal: true

RSpec.describe GraphqlToRest::TypeParsers::GraphqlTypeParser do
  subject(:graphql_type_name_parser) do
    described_class.new(unparsed_type: unparsed_type, **parser_params)
  end

  let(:parser_params) { {} }

  describe '#open_api_type_name' do
    subject(:open_api_type_name) { graphql_type_name_parser.open_api_type_name }

    let(:unparsed_type) { GraphQL::Types::String }

    context 'when type is basic' do
      it { is_expected.to eq('string') }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_non_null_type }

      it { is_expected.to eq('User') }
    end
  end

  describe '#inner_nullable_graphql_object' do
    subject(:inner_nullable_graphql_object) { graphql_type_name_parser.inner_nullable_graphql_object }

    let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_non_null_type }

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_non_null_type }

      it 'returns unwrapped type' do
        expect(inner_nullable_graphql_object).to eq(GraphqlToRest::DummyAppShared::Types::UserType)
      end
    end

    context 'when type is a Connection' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.connection_type }

      context 'when unwrap_connection is true or not set' do
        it 'returns unwrapped non-connection type' do
          expect(inner_nullable_graphql_object).to eq(GraphqlToRest::DummyAppShared::Types::UserType)
        end
      end

      context 'when unwrap_connection is false' do
        let(:parser_params) { { unwrap_connection: false } }

        it 'returns connection type' do
          expect(inner_nullable_graphql_object).to eq(GraphqlToRest::DummyAppShared::Types::UserType.connection_type)
        end
      end
    end
  end

  describe '#deeply_scalar?' do
    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.to be_deeply_scalar }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType }

      it { is_expected.not_to be_deeply_scalar }
    end

    context 'when type is Array with inner scalar type' do
      let(:unparsed_type) { GraphQL::Types::String.to_list_type.to_non_null_type }

      it { is_expected.to be_deeply_scalar }
    end
  end

  describe '#deeply_object?' do
    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.not_to be_deeply_object }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType }

      it { is_expected.to be_deeply_object }
    end

    context 'when type is Array with inner scalar type' do
      let(:unparsed_type) { GraphQL::Types::String.to_list_type.to_non_null_type }

      it { is_expected.not_to be_deeply_object }
    end

    context 'when type is Array with inner object type' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_list_type.to_non_null_type }

      it { is_expected.to be_deeply_object }
    end
  end

  describe '#deeply_enum?' do
    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.not_to be_deeply_enum }
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType }

      it { is_expected.not_to be_deeply_enum }
    end

    context 'when type is Array with inner scalar type' do
      let(:unparsed_type) { GraphQL::Types::String.to_list_type.to_non_null_type }

      it { is_expected.not_to be_deeply_enum }
    end

    context 'when type is Array with inner object type' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_list_type.to_non_null_type }

      it { is_expected.not_to be_deeply_enum }
    end

    context 'when type is Array with inner enum type' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::GenderEnum.to_list_type.to_non_null_type }

      it { is_expected.to be_deeply_enum }
    end
  end

  describe '#required?' do
    context 'when type is nullable' do
      let(:unparsed_type) { GraphQL::Types::String }

      it { is_expected.not_to be_required }
    end


    context 'when type is non-nullable' do
      let(:unparsed_type) { GraphQL::Types::String.to_non_null_type }

      it { is_expected.to be_required }
    end
  end

  describe '#connection?' do
    context 'when type is connection' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.connection_type }

      it { is_expected.to be_connection }
    end

    context 'when type is not connection' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType }

      it { is_expected.not_to be_connection }
    end
  end

  describe '#open_api_schema_reference' do
    subject(:open_api_schema_reference) { graphql_type_name_parser.open_api_schema_reference }

    context 'when type is basic' do
      let(:unparsed_type) { GraphQL::Types::String }

      it 'returns basic type schema' do
        expect(open_api_schema_reference).to eq(type: 'string')
      end
    end

    context 'when type is GraphQL::Object' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType }

      it 'returns reference to object' do
        expect(open_api_schema_reference).to eq('$ref' => '#/components/schemas/User')
      end
    end

    context 'when type is Array with inner scalar type' do
      let(:unparsed_type) { GraphQL::Types::String.to_list_type.to_non_null_type }

      it 'returns reference to object' do
        expect(open_api_schema_reference).to eq(type: 'array', items: { type: 'string' })
      end
    end

    context 'when type is Array with inner object type' do
      let(:unparsed_type) { GraphqlToRest::DummyAppShared::Types::UserType.to_list_type.to_non_null_type }

      it 'returns reference to object' do
        expect(open_api_schema_reference).to eq(type: 'array', items: { '$ref' => '#/components/schemas/User' })
      end
    end
  end
end
