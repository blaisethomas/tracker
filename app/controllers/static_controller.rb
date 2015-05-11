class StaticController < ApplicationController


  def index
    #WDI 15 = /teams/1365559
    #WDI 16 = /teams/1456775
    # @class = HTTParty.get("https://api.github.com/teams/1365559/members?per_page=100&access_token=")
    #@class_16 = HTTParty.get("https://api.github.com/teams/1456775/members?per_page=100&access_token=" + ENV["GITHUB_KEY"])
    # {"login"=>"abe-m1", "id"=>11234357, "avatar_url"=>"https://avatars.githubusercontent.com/u/11234357?v=3", "gravatar_id"=>"", "url"=>"https://api.github.com/users/abe-m1", "html_url"=>"https://github.com/abe-m1", "followers_url"=>"https://api.github.com/users/abe-m1/followers", "following_url"=>"https://api.github.com/users/abe-m1/following{/other_user}", "gists_url"=>"https://api.github.com/users/abe-m1/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/abe-m1/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/abe-m1/subscriptions", "organizations_url"=>"https://api.github.com/users/abe-m1/orgs", "repos_url"=>"https://api.github.com/users/abe-m1/repos", "events_url"=>"https://api.github.com/users/abe-m1/events{/privacy}", "received_events_url"=>"https://api.github.com/users/abe-m1/received_events", "type"=>"User", 

    # @class = HTTParty.get("https://api.github.com/users/blaisethomas?=access_token=")

    #ids = @class_16.map{ |x| x["id"] }
    
    #raise ids.inspect
    ids = [7661708] # 11747141, 6424788, 11968344, 12061711, 5176573, 8016648, 12010823, 11829434, 11725133, 12080891, 363800, 11904900, 11762584, 7832832, 4044328, 8467229, 12039870, 8183771, 11986887]
    @users = []
    
    ids.each do |id|
      user = HTTParty.get("https://api.github.com/user/" + id.to_s + "?access_token=" + ENV["GITHUB_KEY"])
      if user["name"] == nil
        person = { "name" => "please add your name to github", "avatar" => user["avatar_url"], "login" => user["login"]}
      else 
        person = { "name" => user["name"], "avatar" => user["avatar_url"], "login" => user["login"]}
      end
        @users << person
    end

    @users.each do |u|
      #raise u.inspect
      activity = HTTParty.get("https://api.github.com/users/" + u["login"] + "/events/public")
      # raise activity.inspect
      @activities = []
      #activity.inspect

      activity.each do |a|    
        #if a["type"] == "PushEvent"
          reponame = { "repo" => a["repo"]["name"], "type" => a["type"], "commits" => a["payload"]["commits"] } #, "commit url" => a["payload"]["commits"]["url"] }
          #raise reponame["commits"].inspect
          #@activities << reponame
          if reponame["commits"] != nil
            commits = reponame["commits"]
          #raise commits.inspect
            commits.each do |c|
              commit = { "message" => c["message"], "url" => c["url"]}
              @activities << commit
            end
          end

      end
      #raise @activities.inspect   

    end
  end

end
