require 'link_header'
require 'json'
require 'uri'
require 'http'

module GithubBackup
  class Api
    URL = 'https://api.github.com'

    def initialize(token, version = 'v3')
      @token = token
      @version = version
    end

    def accept
      "application/vnd.github.#{@version}+json"
    end

    def get(url)
      @response = HTTP[
        'User-Agent' => 'sleepinginsomniac - cloner',
        'Authorization' => "token #{@token}",
        'Accept' => accept
      ].get(URI.join(URL, url))
      JSON.parse(@response)
    end

    def next
      links = LinkHeader.parse(@response.headers['Link']).links
      next_link = links.find do |link|
        Hash[link.attr_pairs]['rel'] == 'next'
      end
      if next_link
        get(next_link.href)
      else
        false
      end
    end
  end
end
