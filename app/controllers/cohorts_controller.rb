class CohortsController < ApplicationController
  def index
    @users = []

    id_call()
    info_call()
  end #of index


  def id_call
    @search = params[:search] #WDI 15 = 1365559 #WDI 16 = 1456775 #WDI 10/11 = 1046194
    @class = HTTParty.get("https://api.github.com/teams/" + @search.to_s + "/members?per_page=100&access_token=" + ENV["GITHUB_KEY"])
    @ids = @class.map{ |x| x["id"] }
  end


  def info_call

    @blacklist = ["blaisethomas", "iscott", "johnptmcdonald", "kenaniah", "taylorhiggins", "albert-park", "harrisgca", "jimbog", "officiallysrod" ]
    @prefilter = []

    @ids.each do |id|
      # gets user info
      user = HTTParty.get("https://api.github.com/user/" + id.to_s + "?access_token=" + ENV["GITHUB_KEY"])
      # gets activity info
      @activity = HTTParty.get("https://api.github.com/users/" + user["login"] + "/events/public?access_token=" + ENV["GITHUB_KEY"])
      # make a new profile for the student index
      # insert username to user
      @person = { "name" => user["name"], "avatar" => user["avatar_url"], "login" => user["login"], "activity" => []}
      #raise @person.inspect
      @activity.each do |a|
        #raise a.inspect
        if a["payload"]["commits"] != nil
          a["payload"]["commits"].each do |c|
            commit = { "message" => c["message"], "url" => c["url"]}
            activity = { "repo" => a["repo"]["name"], "created_at" =>  a["created_at"], "commit" => commit }
            @person["activity"] << activity
          end #of commits loop
        end #of if block
      end #of activity loop
      @prefilter << @person
    end #of ids loop
    @users = @prefilter.reject { |h| @blacklist.include? h['login'] }
    @users.sort! { |a,b| a["name"] <=> b["name"] } # sort by name
  end

  def leaderboard
    id_call()
    
    @users = []
    @ids.each do |id|
      # gets user info
      user = HTTParty.get("https://api.github.com/user/" + id.to_s + "?access_token=" + ENV["GITHUB_KEY"])
      
      # gets activity info
      @activity = HTTParty.get("https://api.github.com/users/" + user["login"] + "/events/public?access_token=" + ENV["GITHUB_KEY"])
      
      # make a new profile for the student index
      # insert username to user
      if user["name"] != nil
        @person = { "name" => user["name"], "avatar" => user["avatar_url"], "login" => user["login"], "activity" => []}
      end
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
  end


  # def new
  #   @cohort = Cohort.new
  # end


  
  # def create
  #   @cohort = Cohort.new(cohort_params)
  #   respond_to do |format|
  #     if @cohort.save
  #       format.html { redirect_to @cohort, notice: 'cohort was successfully created.' }
  #       format.json { render :show, status: :created, location: @cohort }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @cohort.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private

  def cohort_params
    params.require(:cohort).permit(:name, :number)
  end


end
