{ready, app, indexRoute} = require "./server"


ready.done ->
  # Angular Routes
  app.get "/",                indexRoute
  app.get "/proximity",       indexRoute
  app.get "/follow-suggest",  indexRoute
  app.get "/newsfeed-plus",   indexRoute
  app.get "/meetups",         indexRoute

  # 404
  app.get "/404", indexRoute

  app.get "/*", [(req, res, next) ->
    res.status 404
    next() # Let angular figure out the 404 view.
  , indexRoute]

