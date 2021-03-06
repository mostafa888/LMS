class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :edit, :update, :destroy,:solve,:solve_quiz]
  before_action :authenticate_user!
  before_action :load_course


  def solve
    if @quiz.due_date < Date.today or !in_course() or solved_before()
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
  end

  def solve_quiz

    if @quiz.due_date < Date.today or !in_course() or solved_before()
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    quiz_id=params[:id]
    course_id=params[:course_id]
    quiz_answers = params[:question]
    my_grade = 0.0
    total_grade = 0.0
    @quiz.questions.each_with_index do |question,index|
      total_grade = total_grade + question.weight
      if question.answer1 == quiz_answers.values[index] then
        my_grade = my_grade + question.weight
      end
    end
    Answer.create(:user_id => current_user.id,:quiz_id => quiz_id,:grade => my_grade ,:total => total_grade)
    respond_to do |format|
        format.html { redirect_to course_quizzes_path(@course), notice: 'Quiz was successfully created.' }
        format.json { render :show, status: :created, location: @quiz }
    end
  end 

  # GET /quizzes
  # GET /quizzes.json
  def index
    if !in_course() then
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    @quizzes = @course.quizzes.all
  end

  # GET /quizzes/1
  # GET /quizzes/1.json
  def show
    if !in_course() then
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    if current_user.id!=@course.owner.id and @quiz.due_date > Date.today then
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
  end

  # GET /quizzes/new
  def new
    if current_user.id!=@course.owner.id
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    @quiz = @course.quizzes.new
  end

  # GET /quizzes/1/edit
  def edit
    if current_user.id!=@course.owner.id
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
  end

  # POST /quizzes
  # POST /quizzes.json
  def create
    if current_user.id!=@course.owner.id
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end

    @quiz = @course.quizzes.new(quiz_params)

    respond_to do |format|
      if @quiz.save
        format.html { redirect_to [@course,@quiz], notice: 'Quiz was successfully created.' }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1
  # PATCH/PUT /quizzes/1.json
  def update
    if current_user.id!=@course.owner.id
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to [@course,@quiz], notice: 'Quiz was successfully updated.' }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1
  # DELETE /quizzes/1.json
  def destroy
    if current_user.id!=@course.owner.id
      respond_to do |format|
        format.html { redirect_to :action => 'index' ,:controller=>"courses", notice: 'You are Not Authorized' }
      end
      return false
    end
    @quiz.destroy
    respond_to do |format|
      format.html { redirect_to course_quizzes_path(@course), notice: 'Quiz was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz

      @course = Course.find(params[:course_id])
      @quiz = @course.quizzes.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiz_params
      params.require(:quiz).permit(:name,:course_id,:due_date)
    end

    def load_course
      @course = Course.find(params[:course_id])
    end
    def in_course
     ret= (@course.students.include? current_user or @course.owner.id==current_user.id)
    end
    def solved_before 
       if Answer.where(:quiz_id => @quiz.id , :user_id => current_user.id).count == 0 then 
        return false
      else
        return true
      end
    end
end
