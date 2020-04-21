class PagesController < ApplicationController
  before_action :set_page, only: %i[
    show
    update
    destroy
    download
    download_links
  ]


  # Forces a download
  def download
    DownloadPageJob.perform_now(@page)
  end

  def download_links
    DownloadLinksJob.perform_now(@page)
    @pages = @page.reload.links.to_a
  end

  def statistics
    @total_count = Page.count
    @downloaded_count = Page.only_with_page_file.count
  end

  # GET /pages
  # GET /pages.json
  def index
    permitted_params = params.permit(:website_id)
    only_with_page_file = params.delete(:only_with_page_file)

    if ['false', false].any? {|bool| bool == only_with_page_file}
      @pages = Page.all.where(permitted_params).pagination(params[:pagination])
    else
      @pages = Page.only_with_page_file.where(permitted_params).pagination(params[:pagination])
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

    DownloadLinksJob.perform_later(@page)
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
