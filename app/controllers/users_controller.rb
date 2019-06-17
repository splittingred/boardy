class UsersController < ApplicationController
  def collection
    user = users_service.find_by_usernames(username_param)
    collection = collections_service.find_for_user(user, limit: limit_param)

    render json: { games: collection, total: collection.total }
  end

  private

  def username_param
    params[:user_id].to_s
  end

  def collections_service
    Boardy::Container['collections.service']
  end

  def users_service
    Boardy::Container['users.service']
  end
end
