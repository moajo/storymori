Rails.application.routes.draw do
  get "/api/stories", to: "stories#index"
  post "/api/stories", to: "stories#create"
  get "/api/stories/:storyId/pages/:pageId", to: "pages#index"
  post "/api/stories/:storyId/pages/:parentId/next", to: "pages#create"
end
