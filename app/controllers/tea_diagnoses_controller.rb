class TeaDiagnosesController < ApplicationController

  def start
    session[:scores] = {}
    session[:step] = 1
    redirect_to question_tea_diagnosis_path(step: 1)
  end

  def question
    @step = params[:step].to_i
    @question = TeaDiagnosisService.question(@step)
  end

  def answer

    # 未選択対策
    unless params[:category]
      redirect_back fallback_location: question_tea_diagnosis_path(step: session[:step]),
                    alert: "選択してください"
      return
    end

    category = params[:category].to_sym

    session[:scores][category] ||= 0
    session[:scores][category] += 1

    session[:step] += 1

    if session[:step] > TeaDiagnosisService.total_questions
      redirect_to result_tea_diagnosis_path
    else
      redirect_to question_tea_diagnosis_path(step: session[:step])
    end

  end

  def result
    @category = TeaDiagnosisService.result(session[:scores])
  end

end
