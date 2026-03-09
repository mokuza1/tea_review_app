# app/services/tea_diagnostic_service.rb

class TeaDiagnosticService
  QUESTIONS = [
    {
      text: "どんな味が好き？",
      options: ["すっきり", "コクがある"]
    },
    {
      text: "飲むタイミングは？",
      options: ["リラックス", "朝"]
    },
    {
      text: "ミルクは入れる？",
      options: ["ストレート", "ミルクティー"]
    }
  ].freeze

  class << self

    # 質問一覧
    def questions
      QUESTIONS
    end

    # 指定ステップの質問
    def question(step)
      QUESTIONS[step - 1]
    end

    # 質問数
    def total_questions
      QUESTIONS.size
    end

    # 診断結果
    def diagnose(answers)
      if answers.include?("コクがある") || answers.include?("ミルクティー")
        "アッサム"
      else
        "ダージリン"
      end
    end

  end
end