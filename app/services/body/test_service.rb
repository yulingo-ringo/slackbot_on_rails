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
                if @json[:event][:text]=="redirect" 
                    attachments_json = [
                        {
                            "fallback": "Upgrade your Slack client to use messages like these.",
                            "color": "#258ab5",
                            "attachment_type": "default",
                            "callback_id": "the_greatest_war",
                            "actions": [
                                {
                                    "name": "choco1",
                                    "text": "<https://supership.jp/|きのこ>",
                                    "value": "kinoko",
                                    "type": "button"
                                },
                                {
                                    "name": "choco2",
                                    "text": "たけのこ",
                                    "value": "takenoko",
                                    "type": "button"
                                }
                            ]
                        }
                    ]
                    #attatchment_hash = JSON.parse(attachments_json)
                    body = {
                        :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                        :channel => @json[:event][:channel],#こうするとDM内に返信できます
                        :text  => "ボタン出てきた？",
                        :attachments => attachments_json
                        }
                    conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                else 
                    body = {
                            :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                            :channel => @json[:event][:channel],#こうするとDM内に返信できます
                            :text  => "<https://supership.jp/|🍣>"
                            }
                    conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                end
            end
        end
    end
end