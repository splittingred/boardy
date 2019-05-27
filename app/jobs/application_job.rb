class ApplicationJob < ActiveJob::Base
  def logger
    App['logger']
  end
end
