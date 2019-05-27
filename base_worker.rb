class BaseWorker
  def run
    raise NotImplementedError
  end

  def self.perform
    ActiveRecord::Base.clear_active_connections!
    new.run
  end
end
