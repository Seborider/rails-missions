class Api::FibonaccisController < ApplicationController
  before_action :validate_parameters, only: [:create]

  MAX_FIB_VALUE = 10000

  def create
    start_time = Time.now
    result = ::FibonacciService.calculate(params[:n].to_i)
    end_time = Time.now

    computation = Computation.create(
      value: params[:n].to_i,
      result: result,
      runtime: ((end_time - start_time) * 1000).round
    )

    render json: {
      value: computation.value,
      result: computation.result,
      runtime: computation.runtime,
      created_at: computation.created_at.iso8601
    }
  end

  def index
    computations = Computation.order(created_at: :desc).limit(10)

    render json: computations.map { |comp|
      {
        value: comp.value,
        result: comp.result,
        runtime: comp.runtime,
        created_at: comp.created_at.iso8601
      }
    }
  end

  private

  def validate_parameters
    n = params[:n]

    return render json: { error: 'Parameter n is missing' }, status: 400 if !params.has_key?(:n) || params[:n].blank?
    return render json: { error: 'Parameter n should not be zero' }, status: 400 if n.to_i.zero?
    return render json: { error: 'Parameter n should be non-negative' }, status: 400 if n.to_i.negative?
    return render json: { error: 'Parameter n should be an integer' }, status: 400 if n.to_i.to_s != n.strip
    render json: { error: "Parameter n should be less than or equal to #{MAX_FIB_VALUE}" }, status: 400 if n.to_i > MAX_FIB_VALUE
  end
end

