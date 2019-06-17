# frozen_string_literal: true

require 'games/errors'

class GamesController < ApplicationController
  def index
    games = games_service.list(start: start_param, limit: limit_param)
    render json: games.to_json
  end

  def show
    game = games_service.find(params[:id].to_i)
    render json: game.to_json
  rescue ::Games::Errors::GameNotFound => _e
    render json: { error: 'Game not found' }, status: 404
  end

  private

  def limit_param
    limit = params.fetch(:limit, 10).to_i
    limit > 50 ? 50 : limit
  end

  def games_service
    Boardy::Container['games.service']
  end
end
