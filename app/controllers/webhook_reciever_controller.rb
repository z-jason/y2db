class WebhookRecieverController < ApplicationController

  before_filter :show_params

  def slack
    render :text => params
  end

  def email
    message = CloudMailinMessage.create_from_params(params)
    body = message.plain_body

    puts message.sender.match(/benjamin19890721@gmail.com/)
    # if sender == 'benjamin19890721@gmail.com'
      # find the URL and expand the it
      regex = /(http[s]?:\/\/youtu\.be\/.*)/
      match = regex.match(body)
      if match.nil?
        Rails.logger.debug('No Match', context: binding)
        render :text => 'No Match'
      else
        youtube_short_url = match[0]
        youtube_long_url = ExpandUrlService.lengthen(youtube_short_url)
        youtube_vidoe = YoutubeVideo.new(youtube_long_url)
        ApplicationMailer.send_youtube_digest_to_evernote({
          subject: 'Youtube Video URL',
          youtube_vidoe: youtube_vidoe }
          ).deliver_now
        Rails.logger.debug('OK', context: binding)
        render :text => 'OK'
      end
    # else
      # render :status => 500
    # end
  end

private

    def show_params
      ap params
    end


end
