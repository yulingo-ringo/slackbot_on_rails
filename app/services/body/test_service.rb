module  Body
    class TestService
        def initialize(json)
            @json=json
        end
        def execute
            #Faradayを使って、JSON形式のファイルをPOSTできるようにする
                conn = Faraday::Connection.new(:url => 'https://slack.com') do |builder|
                    builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
                    builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
                    builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
                end
            if @json[:event][:subtype] != "bot_message" #これがないと無限ループになる
                body = {
                        :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                        :channel => @json[:event][:channel],#こうするとDM内に返信できます
                        :text  => "こんにちは、私はslackbotです！"
                        }
                conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                Request 'https://www.sejuku.net/blog/category/programing/ruby-on-rails/ruby-on-rails-nyumon'
            end
        end
    end
end