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
    answers = session[:diagnostic_answers] || []
    answers << params[:answer]
    session[:diagnostic_answers] = answers

    next_step = answers.length + 1

    if next_step > TeaDiagnosticService.total_questions
      redirect_to result_diagnostic_path
    else
      redirect_to question_diagnostic_path(step: next_step)
    end
  end

  def result
    @answers = session[:diagnostic_answers] || []
    @result = TeaDiagnosticService.diagnose(@answers)
  end

end