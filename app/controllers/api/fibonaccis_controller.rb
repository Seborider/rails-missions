class Api::FibonaccisController < ApplicationController
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
end

