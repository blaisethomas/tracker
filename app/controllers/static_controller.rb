class StaticController < ApplicationController


  def index
    #WDI 15 = /teams/1365559
    #WDI 16 = /teams/1456775
    
    # switch off while testing
    #@class = HTTParty.get("https://api.github.com/teams/1456775/members?per_page=100&access_token=" + ENV["GITHUB_KEY"])
    #ids = @class.map{ |x| x["id"] }
    
    #raise ids.inspect
    ids = [7661708, 11747141, 6424788] #, 11968344, 12061711, 5176573, 8016648, 12010823, 11829434, 11725133, 12080891, 363800, 11904900, 11762584, 7832832, 4044328, 8467229, 12039870, 8183771, 11986887]
    @users = []
    # @activities = []
    ids.each do |id|
      # gets user info
      user = HTTParty.get("https://api.github.com/user/" + id.to_s + "?access_token=" + ENV["GITHUB_KEY"])
      
      # gets activity info
      @activity = HTTParty.get("https://api.github.com/users/" + user["login"] + "/events/public?access_token=" + ENV["GITHUB_KEY"])
      
      # make a new profile for the student index
      # insert username to user
      @person = { "name" => user["name"], "avatar" => user["avatar_url"], "login" => user["login"], "activity" => []}
      
      #raise @person.inspect

      @activity.each do |a|    
        #reponame = { "repo" => a["repo"]["name"], "type" => a["type"], "commits" => a["payload"]["commits"] } #, "commit url" => a["payload"]["commits"]["url"] }
        #raise a.inspect
        if a["payload"]["commits"] != nil
          a["payload"]["commits"].each do |c|
            commit = { "message" => c["message"], "url" => c["url"]}
            activity = { "repo" => a["repo"]["name"], "created_at" =>  a["created_at"], "commit" => commit }
            @person["activity"] << activity
          end #of commits loop
        end #of if block
      end #of activity loop
      # raise @person.inspect 
      @users << @person
    end #of ids loop
  end #of index
end #of class
