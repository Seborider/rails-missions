require 'rails_helper'

RSpec.describe "Api::Fibonaccis", type: :request do

  describe "POST /create" do

    context 'with missing parameter n' do
      it 'returns a 400 status code' do
        post api_fibonaccis_path
        expect(response.status).to eq(400)
      end

      it 'returns an error message' do
        post api_fibonaccis_path
        expect(JSON.parse(response.body)['error']).to eq('Parameter n is missing')
      end
    end
    context 'with a negative n value' do
      let(:negative_value) { -5 }

      before { post api_fibonaccis_path, params: { n: negative_value } }

      it 'returns a 400 status code' do
        expect(response.status).to eq(400)
      end

      it 'returns an appropriate error message' do
        expect(JSON.parse(response.body)['error']).to eq('Parameter n should be non-negative')
      end
    end
    context 'with a non-integer n value' do
      let(:non_integer_value) { '5.5' }

      before { post api_fibonaccis_path, params: { n: non_integer_value } }

      it 'returns a 400 status code' do
        expect(response.status).to eq(400)
      end

      it 'returns an appropriate error message' do
        expect(JSON.parse(response.body)['error']).to eq('Parameter n should be an integer')
      end
    end
    context 'with an n value greater than the maximum allowed' do
      let(:large_value) { Api::FibonaccisController::MAX_FIB_VALUE + 1 }

      before { post api_fibonaccis_path, params: { n: large_value } }

      it 'returns a 400 status code' do
        expect(response.status).to eq(400)
      end

      it 'returns an appropriate error message' do
        expect(JSON.parse(response.body)['error']).to eq("Parameter n should be less than or equal to #{Api::FibonaccisController::MAX_FIB_VALUE}")
      end
    end  end
  describe "GET /index" do
    let!(:computations) { create_list(:computation, 12) }

    before { get api_fibonaccis_path }

    it 'returns a 200 status code' do
      expect(response.status).to eq(200)
    end

    it 'returns the last 10 computations' do
      json_response = JSON.parse(response.body)
      expect(json_response.size).to eq(10)
      expect(json_response.first['value']).to eq(computations.last.value)
    end
  end
  end