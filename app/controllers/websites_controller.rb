class WebsitesController < ApplicationController
  before_action :set_website, only: [:show, :update, :destroy]

  def statistics
    @total_count = Website.count
  end

  def index
    @websites = Website.all.pagination(params[:pagination])
  end

  def show
  end

  def create
    @website = Website.new(website_params)

    if @website.save
      render :show, status: :created, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  def update
    if @website.update(website_params)
      render :show, status: :ok, location: @website
    else
      render json: @website.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @website.destroy
  end

  private
    def set_website
      @website = Website.find(params[:id])
    end

    def website_params
      params.require(:website).permit(:url, :should_scrape)
    end
end
