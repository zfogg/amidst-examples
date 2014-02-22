{ready, app, indexRoute} = require "./server"


ready.done ->
  # Angular Routes
  app.get "/",                         indexRoute
  app.get "/examples/proximity",       indexRoute
  app.get "/examples/auto-follow",     indexRoute
  app.get "/examples/livegraph",       indexRoute
  app.get "/examples/foursquare-plus", indexRoute

  # 404
  app.get "/404", indexRoute

  app.get "/*", [(req, res, next) ->
    res.status 404
    next() # Let angular figure out the 404 view.
  , indexRoute]

