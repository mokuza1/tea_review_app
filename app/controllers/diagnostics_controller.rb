class DiagnosticsController < ApplicationController

  def start
  end

  def initialize_session
    session[:diagnostic_answers] = []

    redirect_to question_diagnostic_path(step: 1)
  end

  def question
    @step = params[:step].to_i
    @question = TeaDiagnosticService.question(@step)
    @total_questions = TeaDiagnosticService.total_questions

    if @question.nil?
      redirect_to result_diagnostic_path
    end
  end

  def answer
    session[:diagnostic_answers] ||= []
    session[:diagnostic_answers] << params[:answer].to_i

    next_step = session[:diagnostic_answers].length + 1

    if next_step > TeaDiagnosticService.total_questions
      redirect_to result_diagnostic_path
    else
      redirect_to question_diagnostic_path(step: next_step)
    end
  end

  def result
    answers = session[:diagnostic_answers]

    if answers.blank?
      redirect_to start_diagnostic_path
      return
    end

    category = TeaDiagnosticService.diagnose(answers)

    @category = category
    @result = TeaDiagnosticService.result_data(category)

    session.delete(:diagnostic_answers)
  end

end