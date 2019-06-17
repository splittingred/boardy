class ApplicationJob < ActiveJob::Base
  def logger
    Boardy::Container['logger']
  end
end
