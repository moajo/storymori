class StoriesController < ApplicationController
  def index
    con = ActiveRecord::Base.connection
    result = con.select_all("SELECT s.id, s.title, p.id AS parentId 
    FROM stories s
    INNER JOIN pages p ON s.id = p.story_id
    WHERE p.parent_id is null;")
    hash = result.to_hash
    render json: hash
  end

  def create
    text = params["text"]
    title = params["title"]

    if text.blank?
      puts "text is nil"
      head 400
      return
    end
    if title.blank?
      puts "title is nil"
      head 400
      return
    end

    summary = text[0...10]
    createdStroy = Story.create(title: title, summary: summary)

    storyId = createdStroy.id
    hoge = Page.create(name: title, text: text, story_id: storyId)
    pageId = hoge.id
    render json: { "storyId": storyId, "pageId": pageId }
    # TODO: transaction
    return
  end
end
