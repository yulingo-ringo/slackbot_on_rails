class SlackController < ApplicationController
    def index
    end

    def create
        @body = JSON.parse(request.body.read)
        case @body['type']
        when 'url_verification'
            render json: @body
        when 'event_callback'
            # ..
        end
        json_hash  = params[:slack]
        Body::TestService.new(json_hash).execute
    end

    def action
        p request.body.read
        #body =JSON.parse(request.body.read)
        body = JSON.stringify(request.body.read, null, "  ")
        Body::TestService.new(body).interact
    end
end
