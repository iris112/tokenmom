class Order < ApplicationRecord
    self.inheritance_column = nil
    after_create_commit :broadcast_order
    after_update_commit :broadcast_update_order
    # before_destroy :broadcast_remove_order

    private

    def broadcast_order
        OrderBroadcastJob.perform_later("add",self)
    end

    def broadcast_remove_order        
        OrderBroadcastJob.perform_later("remove",self)
    end
    def broadcast_update_order
        OrderBroadcastJob.perform_later("update",self)
    end

    
end
