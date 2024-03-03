class SampleController < ApplicationController
  def index
    x = 123
    render json: { 'name': 'hoge', 'age': x }
  end

  def new
    piyo
  end

  private

  def piyo
    'piyo'
  end
end
