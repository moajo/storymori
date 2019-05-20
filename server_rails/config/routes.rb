Rails.application.routes.draw do
  get "/api/stories", to: "stories#get"
  post "/api/stories", to: "stories#post"
  get "/api/stories/:storyId/pages/:pageId", to: "pages#get"
  post "/api/stories/:storyId/pages/:pageId/next", to: "pages#post"
end
