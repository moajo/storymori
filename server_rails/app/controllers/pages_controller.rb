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
  before_action :set_page, only: [:show, :update, :destroy]

  # GET /pages
  def get
    @pages = Page.all

    render json: @pages
  end

  # # GET /pages/1
  # def show
  #   render json: @page
  # end

  # POST /pages
  def post
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

  # PATCH/PUT /pages/1
  def update
    if @page.update(page_params)
      render json: @page
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pages/1
  def destroy
    @page.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def page_params
    params.fetch(:page, {})
  end
end
