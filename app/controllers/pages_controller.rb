class PagesController < ApplicationController
  before_action :set_page, only: [:show, :update, :destroy, :download]

  # GET /pages
  # GET /pages.json
  def index
    only_with_page_file = params.delete(:only_with_page_file)

    if only_with_page_file == 'true' || only_with_page_file == true
      @pages = Page.only_with_page_file
    else
      @pages = Page.all
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    if @page.save
      render :show, status: :created, location: @page
    else
      render json: @page.errors, status: :unprocessable_entity
    end

    DownloadPageJob.perform_later(@page)
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    if @page.update(page_params)
      render :show, status: :ok, location: @page
    else
      render json: @page.errors, status: :unprocessable_entity
    end
  end

  # Forces a download
  def download
    @page.download_page_file
    @page_file_service_url = @page.page_file.service_url
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def page_params
      params.require(:page).permit(:url)
    end
end
