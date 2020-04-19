class WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :update, :destroy]

  # GET /websites
  # GET /websites.json
  def index
    @websites = Website.all
  end

  # GET /websites/1
  # GET /websites/1.json
  def show
  end

  # POST /websites
  # POST /websites.json
  def create
    @website = Website.new(website_params)

    if @website.save
      render :show, status: :created, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /websites/1
  # PATCH/PUT /websites/1.json
  def update
    if @website.update(website_params)
      render :show, status: :ok, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  # DELETE /websites/1
  # DELETE /websites/1.json
  def destroy
    @website.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_website
      @website = Website.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def website_params
      params.require(:website).permit(:url)
    end
end
