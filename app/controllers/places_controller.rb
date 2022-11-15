class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session["last_city"] = params[:city]
      render :index, status: 418
    end
  end

  def show
  end

  def set_place
    if session["last_city"]
      places = BeermappingApi.places_in(session["last_city"])
      p =  places.select {|p| p.id == params[:id]}
      if p
        @place = p.first
      end
    end

  end

end
