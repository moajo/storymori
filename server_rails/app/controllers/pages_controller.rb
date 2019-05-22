def nilOrEmpty(str)
  str == nil || str == ""
end

def to_s_or_null(str)
  if str == nil
    return nil
  end
  i = str.to_i
  str == i.to_s ? i : nil
end

class PagesController < ApplicationController
  # before_action :set_page, only: [:show, :update, :destroy]

  # GET /pages
  def index
    storyIdStr = params["storyId"]
    pageIdStr = params["pageId"]

    storyId = to_s_or_null(storyIdStr)
    if storyId == nil
      puts "storyId is nil"
      head 400
      return
    end

    pageId = to_s_or_null(pageIdStr)
    if pageId == nil
      puts "pageId is nil"
      head 400
      return
    end
    page = Page.find_by(id: pageId, story_id: storyId)
    if page == nil
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

  # POST /pages
  def create
    json_request = JSON.parse(request.body.read)
    name = json_request["name"]
    text = json_request["text"]
    storyIdStr = params["storyId"]
    parentIdStr = params["parentId"]

    if nilOrEmpty(name)
      puts "name is nil"
      head 400
      return
    end

    if nilOrEmpty(text)
      puts "text is nil"
      head 400
      return
    end

    storyId = to_s_or_null(storyIdStr)
    if storyId == nil
      puts "storyId is nil"
      head 400
      return
    end

    parentId = to_s_or_null(parentIdStr)
    if parentId == nil
      puts "parentId is nil"
      head 400
      return
    end

    parent = Page.find_by(id: parentId, story_id: storyId)
    if parent == nil
      puts "parent is not exists"
      head 404
      return
    end

    createdPage = Page.create(name: name, text: text, story_id: storyId, parent_id: parent.id)
    render json: { "id": createdPage.id }
  end

  # # PATCH/PUT /pages/1
  # def update
  #   if @page.update(page_params)
  #     render json: @page
  #   else
  #     render json: @page.errors, status: :unprocessable_entity
  #   end
  # end

  # # DELETE /pages/1
  # def destroy
  #   @page.destroy
  # end

  # private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_page
  #   @page = Page.find(params[:id])
  # end

  # # Only allow a trusted parameter "white list" through.
  # def page_params
  #   params.fetch(:page, {})
  # end
end
