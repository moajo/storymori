
class PagesController < ApplicationController
  def index
    storyIdStr = params["storyId"]
    pageIdStr = params["pageId"]

    storyId = to_s_or_null(storyIdStr)
    if storyId.nil?
      puts "storyId is nil"
      head 400
      return
    end

    pageId = to_s_or_null(pageIdStr)
    if pageId.nil?
      puts "pageId is nil"
      head 400
      return
    end
    page = Page.find_by(id: pageId, story_id: storyId)
    if page.nil?
      puts "123"
      head 404
      return
    end

    children = Page.where(parent_id: page.id)

    att = page.attributes
    ret = page.as_json(:except => [:created_at, :updated_at])
    ret["children"] = children.map { |a| a.as_json(:except => [:created_at, :updated_at]) }
    render json: ret
  end

  def create
    name = params["name"]
    text = params["text"]
    storyIdStr = params["storyId"]
    parentIdStr = params["parentId"]

    if name.blank?
      puts "name is nil"
      head 400
      return
    end

    if text.blank?
      puts "text is nil"
      head 400
      return
    end

    storyId = to_s_or_null(storyIdStr)
    if storyId.nil?
      puts "storyId is nil"
      head 400
      return
    end

    parentId = to_s_or_null(parentIdStr)
    if parentId.nil?
      puts "parentId is nil"
      head 400
      return
    end

    parent = Page.find_by(id: parentId, story_id: storyId)
    if parent.nil?
      puts "parent is not exists"
      head 404
      return
    end

    createdPage = Page.create(name: name, text: text, story_id: storyId, parent_id: parent.id)
    render json: { "id": createdPage.id }
  end

  private

  def to_s_or_null(str)
    if str.nil?
      return nil
    end
    i = str.to_i
    str == i.to_s ? i : nil
  end
end
