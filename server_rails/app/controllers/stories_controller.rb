def nilOrEmpty(str)
  str == nil || str == ""
end

class StoriesController < ApplicationController
  # before_action :set_story, only: [:show, :update, :destroy]

  # GET /stories
  def get
    con = ActiveRecord::Base.connection
    result = con.select_all("SELECT s.id, s.title, p.id AS parentId 
    FROM stories s
    INNER JOIN pages p ON s.id = p.story_id
    WHERE p.parent_id is null;")
    hash = result.to_hash
    render json: hash
  end

  # POST /stories
  def post
    json_request = JSON.parse(request.body.read)
    text = json_request["text"]
    title = json_request["title"]

    if nilOrEmpty(text)
      puts "text is nil"
      head 400
      return
    end
    if nilOrEmpty(title)
      puts "title is nil"
      head 400
      return
    end

    summary = text[0...10]
    createdStroy = Story.create(title: title, summary: summary)

    storyId = createdStroy.id
    hoge = Page.create(title: title, text: text, story_id: storyId)
    pageId = hoge.id
    render json: { "storyId": storyId, "pageId": pageId }
    # TODO: transaction
    return
    # if @story.save
    #   render json: @story, status: :created, location: @story
    # else
    #   render json: @story.errors, status: :unprocessable_entity
    # end
  end

  # private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_story
  #   @story = Story.find(params[:id])
  # end

  # # Only allow a trusted parameter "white list" through.
  # def story_params
  #   params.fetch(:story, {})
  # end
end
