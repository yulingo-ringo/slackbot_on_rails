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
                elsif @json[:event][:text]=="block1"
                    block_kit_1=[
                        {
                            "type": "section",
                            "text": {
                                "type": "mrkdwn",
                                "text": "A message *with some bold text* and _some italicized text_."
                            }
                        }
                    ]
                    body = {
                        :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                        :channel => @json[:event][:channel],#こうするとDM内に返信できます
                        #:text  => "これ要りますかね",
                        :blocks => block_kit_1
                        }
                    conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                elsif @json[:event][:text]=="block2"
                    block_kit_2=[
                        {
                            "type": "section",
                            "text": {
                              "type": "mrkdwn",
                              "text": "Danny Torrence left the following review for your property:"
                            }
                          },
                          {
                            "type": "section",
                            "block_id": "section567",
                            "text": {
                              "type": "mrkdwn",
                              "text": "<https://google.com|Overlook Hotel> \n :star: \n Doors had too many axe holes, guest in room 237 was far too rowdy, whole place felt stuck in the 1920s."
                            },
                            "accessory": {
                              "type": "image",
                              "image_url": "https://is5-ssl.mzstatic.com/image/thumb/Purple3/v4/d3/72/5c/d3725c8f-c642-5d69-1904-aa36e4297885/source/256x256bb.jpg",
                              "alt_text": "Haunted hotel image"
                            }
                          },
                          {
                            "type": "section",
                            "block_id": "section789",
                            "fields": [
                              {
                                "type": "mrkdwn",
                                "text": "*Average Rating*\n1.0"
                              }
                            ]
                          },
                          {
                            "type": "actions",
                            "elements": [
                              {
                                "type": "button",
                                  "text": {
                                      "type": "plain_text",
                                      "text": "Reply to review",
                                      "emoji": false
                                  },
                                "url": "https://www.amazon.co.jp/"
                              }
                            ]
                          }
                    ]
                    body = {
                        :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                        :channel => @json[:event][:channel],#こうするとDM内に返信できます
                        #:text  => "これ要りますかね",
                        :blocks => block_kit_2
                        }              
                        conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                elsif @json[:event][:text]=="block2"
                    block_kit_1=[
                        {
                            "type": "input",
                            "block_id": "input123",
                            "label": {
                              "type": "plain_text",
                              "text": "Label of input"
                            },
                            "element": {
                              "type": "plain_text_input",
                              "action_id": "plain_input",
                              "placeholder": {
                                "type": "plain_text",
                                "text": "Enter some plain text"
                              }
                            }
                          }
                    ]
                    body = {
                        :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                        :channel => @json[:event][:channel],#こうするとDM内に返信できます
                        #:text  => "これ要りますかね",
                        :blocks => block_kit_1
                        }
                    conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。

                else 
                    body = {
                            :token => ENV['SLACK_BOT_USER_TOKEN'],#あとでherokuで設定します
                            :channel => @json[:event][:channel],#こうするとDM内に返信できます
                            :text  => "<https://supership.jp/|ここをクリック>"
                            }
                    conn.post '/api/chat.postMessage',body.to_json, {"Content-type" => 'application/json',"Authorization"=>"Bearer #{ENV['SLACK_BOT_USER_TOKEN']}"}#ヘッダーはつけなければいけないらしい、このままで大丈夫です。
                end
            end
        end
    end
end