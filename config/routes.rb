Rails.application.routes.draw do
  get("/", { :controller => "pages", :action => "home" })

  get("/recipes/new", { :controller => "recipes", :action => "new" })
  #Devise routes for User authentication
  devise_for :users

  # Routes for the Step resource:
  # CREATE
  post("/insert_step", { :controller => "steps", :action => "create" })

  # READ
  get("/steps", { :controller => "steps", :action => "index" })

  get("/steps/:path_id", { :controller => "steps", :action => "show" })

  # UPDATE
  post("/modify_step/:path_id", { :controller => "steps", :action => "update" })

  # DELETE
  get("/delete_step/:path_id", { :controller => "steps", :action => "destroy" })

  #------------------------------

  # Routes for the Ingredient resource:

  # CREATE
  post("/insert_ingredient", { :controller => "ingredients", :action => "create" })

  # READ
  get("/ingredients", { :controller => "ingredients", :action => "index" })

  get("/ingredients/:path_id", { :controller => "ingredients", :action => "show" })

  # UPDATE
  post("/modify_ingredient/:path_id", { :controller => "ingredients", :action => "update" })

  # DELETE
  get("/delete_ingredient/:path_id", { :controller => "ingredients", :action => "destroy" })

  #------------------------------

  # Routes for the Recipe resource:

  # CREATE
  post("/insert_recipe", { :controller => "recipes", :action => "create" })

  # READ
  get("/recipes", { :controller => "recipes", :action => "index" })

  get("/recipes/:path_id", { :controller => "recipes", :action => "show" })

  post("/recipes/:path_id/parse", { :controller => "recipes", :action => "parse" })

  # UPDATE
  post("/modify_recipe/:path_id", { :controller => "recipes", :action => "update" })

  # DELETE
  get("/delete_recipe/:path_id", { :controller => "recipes", :action => "destroy" })
end
