require 'mini_magick'
require 'tempfile'

class PdfsController < ApplicationController
  before_action :set_pdf, only: [:show, :edit, :update, :destroy]
  
  # GET /pdfs
  # GET /pdfs.json
  def index
    @pdfs = Pdf.all.order(last_access: :desc)
  end

  # GET /pdfs/1
  # GET /pdfs/1.json
  def show
    @pdf.last_access = Time.now
    @pdf.save
  end

  # GET /pdfs/new
  def new
    @pdf = Pdf.new
  end

  # GET /pdfs/1/edit
  def edit
  end

  # POST /pdfs
  # POST /pdfs.json
  def create
    @pdf = Pdf.new
    # active storageはnewした段階で保存されてしまい、
    # モデルバリデーションは後からになってしまうので、ここで検証する。
    if !create_pdf_validation
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
      return
    end
    
    @pdf.attributes = pdf_params
    @pdf.name = pdf_params[:pdf].original_filename if pdf_params[:name] = ""
    @pdf.last_access = Time.zone.now
    pdf_to_jpegs
    @pdf.save
    respond_to do |format|
      format.html { redirect_to @pdf, notice: 'Pdf was successfully created.' }
      format.json { render :show, status: :created, location: @pdf }
    end
  end

  # PATCH/PUT /pdfs/1
  # PATCH/PUT /pdfs/1.json
  def update
    pdf_to_jpegs if pdf_params[:pdf]
    respond_to do |format|
      if @pdf.update(pdf_params)
        format.html { redirect_to @pdf, notice: 'Pdf was successfully updated.' }
        format.json { render :show, status: :ok, location: @pdf }
      else
        format.html { render :edit }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdfs/1
  # DELETE /pdfs/1.json
  def destroy
    @pdf.destroy
    respond_to do |format|
      format.html { redirect_to pdfs_url, notice: 'Pdf was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pdf
      @pdf = Pdf.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pdf_params
      params.require(:pdf).permit(:name, :pdf)
    end
    
    def create_pdf_validation
      pdf = pdf_params[:pdf]
      if pdf.nil?
        @pdf.errors.add(:pdf, ' : file is required')
      elsif !pdf.original_filename.include?('.pdf')
        @pdf.errors.add(:pdf, ' : file should be pdf')
      elsif pdf.size > 1.gigabytes
        @pdf.errors.add(:pdf, ' : file should be less than 1GB')
      else
        return true
      end
      return false
    end
    
    def pdf_to_jpegs
      @pdf.jpegs.purge
      pdf = MiniMagick::Image.open(pdf_params[:pdf].path)
      pdf.layers.each_with_index do |page, idx|
        Tempfile.create(["", ".jpeg"]) do |jpeg|
          MiniMagick::Tool::Convert.new do |convert|
            convert.density(200)
            convert << page.path
            convert << jpeg.path
          end
          @pdf.jpegs.attach(io: jpeg,
            filename: "#{idx}.jpeg", content_type: 'image/jpeg')
        end
      end
    end
end
