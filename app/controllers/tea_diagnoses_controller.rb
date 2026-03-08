class TeaDiagnosesController < ApplicationController

  def start
    session[:scores] = Hash.new(0)
    redirect_to question_tea_diagnosis_path(step: 1)
  end

  def question
    @step = params[:step].to_i
    @question = TeaDiagnosisService.question(@step)
  end

  def answer
    category = params[:category].to_sym
    session[:scores][category] += 1

    next_step = session[:scores].values.sum + 1

    if TeaDiagnosisService.finished?(next_step)
      redirect_to result_tea_diagnosis_path
    else
      redirect_to question_tea_diagnosis_path(step: next_step)
    end
  end

  def result
    @category = TeaDiagnosisService.result(session[:scores])
  end

end
