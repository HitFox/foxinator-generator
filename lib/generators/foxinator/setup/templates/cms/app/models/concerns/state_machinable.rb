module StateMachinable
  extend ActiveSupport::Concern
  
  class_methods do
    def state_machine?(name = :state)
      respond_to?(:state_machines) && state_machines[name].present?
    end
    
    def by_status(status)
      where(state: status)
    end
  end
end
