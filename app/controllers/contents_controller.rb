class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # GET /contents/1/edit
  def edit
  end

  # POST /contents
  # POST /contents.json
  def create
    @content = Content.new(content_params)

    chapter=Chapter.find_by(id: @content.chapter_id)
    if chapter==nil
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end

   if Course.find_by(id: (chapter.course_id)).owner_id!=current_user.id 
      respond_to do |format|
        format.html { redirect_to :action => 'index',:controller=>"courses", notice: 'You are Not Authorized' }
      end
    return false
   end 

    respond_to do |format|
      if @content.save
        format.html { redirect_to :action => 'show', id: @content.chapter.course_id ,:controller=>"courses", notice: 'Chapter was successfully created.' }
        
        # format.html { redirect_to @content, notice: 'Content was successfully created.' }
        # format.json { render :show, status: :created, location: @content }
      else
        format.html { render :new }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    respond_to do |format|
      if @content.update(content_params)
        format.html { redirect_to @content, notice: 'Content was successfully updated.' }
        format.json { render :show, status: :ok, location: @content }
      else
        format.html { render :edit }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    chapter=Chapter.find_by(id: @content.chapter_id)
    if chapter==nil
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end

   if Course.find_by(id: (chapter.course_id)).owner_id!=current_user.id 
      respond_to do |format|
        format.html { redirect_to :action => 'index',:controller=>"courses", notice: 'You are Not Authorized' }
      end
    return false
   end 

    @content.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'show', id: @content.chapter.course_id ,:controller=>"courses", notice: 'Chapter was successfully created.' }
      # format.html { redirect_to contents_url, notice: 'Content was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def content_params
      params.require(:content).permit(:name, :attachment,:chapter_id)
    end
end
