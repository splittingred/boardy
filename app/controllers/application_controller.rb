# frozen_string_literal: true

class ApplicationController < ActionController::API
  def limit_param
    params.fetch(:limit, 20).to_i
  end

  def start_param
    params.fetch(:start, 0).to_i
  end

  rescue_from StandardError do |e|
    ::Boardy::Container['logger'].error e.message
    render json: { error: 'Unknown error' }, status: 500
  end

  rescue_from ActiveRecord::RecordNotFound do |_e|
    render json: { error: 'Not found' }, status: 404
  end
end
