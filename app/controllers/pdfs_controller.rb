require 'mini_magick'
require 'tempfile'

class PdfsController < ApplicationController
  before_action :set_pdf_with_attached_pdf_and_jpegs, only: [:show]
  before_action :set_pdf, only: [:edit, :update, :destroy]
  
  # GET /pdfs
  def index
    @pdfs = Pdf.all.order(last_access: :desc)
    @turbolinks_no_cache = true
  end

  # GET /pdfs/1
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
  def create
    @pdf = Pdf.new
    # active storageはnewした段階で保存されてしまい、
    # モデルバリデーションは後からになってしまうので、ここで検証する。
    unless create_pdf_validation
      render :new
      return
    end
    
    @pdf.attributes = pdf_params
    @pdf.name = pdf_params[:pdf].original_filename if pdf_params[:name] = ""
    @pdf.last_access = Time.zone.now
    @pdf.pdf_and_jpegs_filesize = pdf_params[:pdf].size
    pdf_to_jpegs
    @pdf.save
    redirect_to @pdf, notice: (t '.notice')
  end

  # PATCH/PUT /pdfs/1
  def update
    pdf_to_jpegs if pdf_params[:pdf]
    if @pdf.update(pdf_params)
      redirect_to @pdf, notice: (t '.notice')
    else
      render :edit
    end
  end

  # DELETE /pdfs/1
  # DELETE /pdfs/1.json
  def destroy
    @pdf.pdf.purge
    @pdf.jpegs.purge
    @pdf.destroy
    redirect_to pdfs_url, notice: (t '.notice')
  end

  private
    def set_pdf_with_attached_pdf_and_jpegs
      @pdf = Pdf.with_attached_pdf.with_attached_jpegs.find(params[:id])
    end
  
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
        @pdf.errors.add(:pdf, (t 'pdfs.create_pdf_validation.required'))
      elsif !pdf.original_filename.include?('.pdf')
        @pdf.errors.add(:pdf, (t 'pdfs.create_pdf_validation.pdf'))
      elsif pdf.size > 1.megabytes
        @pdf.errors.add(:pdf, (t 'pdfs.create_pdf_validation.size', n: 1))
      elsif Pdf.sum(:pdf_and_jpegs_filesize) > 10.megabytes
        @pdf.errors.add(:pdf, (t 'pdfs.create_pdf_validation.totalsize', n: 10))
      else
        return true
      end
      return false
    end
    
    # pdf→jpeg変換の本体
    def pdf_to_jpegs
      @pdf.jpegs.purge
      pdf = MiniMagick::Image.open(pdf_params[:pdf].path)
      jpegs_filesize = 0
      pdf.layers.each_with_index do |page, idx|
        Tempfile.create(["", ".jpeg"]) do |jpeg|
          MiniMagick::Tool::Convert.new do |convert|
            convert.density(300)
            convert << page.path
            convert << jpeg.path
          end
          @pdf.jpegs.attach(io: jpeg,
            filename: "#{idx}.jpeg", content_type: 'image/jpeg')
          jpegs_filesize += jpeg.size
        end
      end
      @pdf.pdf_and_jpegs_filesize += jpegs_filesize
    end
end
