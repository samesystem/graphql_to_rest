# frozen_string_literal: true

RSpec.describe GraphqlToRest::Schema::Basic::Paths::RouteToParameters do
  describe '.call' do
    subject(:call) do
      described_class.call(route: route)
    end

    context 'when route has path parameters' do
      let(:route) { build(:route_decorator, path: '/api/v1/:some_param/users(.:format)') }

      it 'returns correct parameters', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        expect(call.count).to eq(1)
        expect(call).to eq(
          [
            {
              name: 'some_param',
              in: 'path',
              required: true,
              schema: { type: 'string' }
            }
          ]
        )
      end
    end

    context 'when route has query parameters' do
      let(:route) { build(:route_decorator, :users_paginated) }

      context 'when query parameter is an object' do
        it 'returns correct parameters', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
          expect(call.count).to eq(1)
          expect(call).to eq(
            [
              {
                name: 'filter',
                in: 'query',
                required: true,
                schema: { '$ref' => '#/components/schemas/UsersFilter' },
                style: 'deepObject',
                allowReserved: true,
                explode: true
              }
            ]
          )
        end
      end

      context 'with multiple query parameters' do
        let(:route) { build(:route_decorator, :users_index_explicit_params) }

        it 'returns correct parameters', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
          expect(call.count).to eq(3)

          expect(call[0]).to eq(
            name: 'filter[id]',
            in: 'query',
            required: false,
            allowReserved: true,
            schema: {
              type: 'array',
              items: { type: 'string' }
            }
          )

          expect(call[1]).to eq(
            name: 'filter[name]',
            in: 'query',
            required: false,
            allowReserved: true,
            schema: { type: 'string' }
          )

          expect(call[2]).to eq(
            name: 'filter[status]',
            in: 'query',
            required: false,
            default: 'ACTIVE',
            allowReserved: true,
            schema: {
              type: 'array',
              items: { '$ref' => '#/components/schemas/StatusEnum' }
            }
          )
        end
      end
    end
  end
end
