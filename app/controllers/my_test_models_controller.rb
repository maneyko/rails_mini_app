class MyTestModelsController < ApplicationController
  def index
    render json: MyTestModel.all.as_json
  end
end
