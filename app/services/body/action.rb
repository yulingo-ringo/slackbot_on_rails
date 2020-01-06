module Body
    class Action
        def initialize(json)
            @json=json
        end
        def interact
            p @json[:trigger_id]
        end
    end   
end