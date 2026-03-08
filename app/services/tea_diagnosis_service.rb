class TeaDiagnosisService

  QUESTIONS = [
    {
      text: "今の気分は？",
      choices: [
        { text: "元気になりたい", category: :fruit },
        { text: "リラックスしたい", category: :flower },
        { text: "落ち着きたい", category: :non_flavor },
        { text: "気分を変えたい", category: :unique }
      ]
    },
    {
      text: "好きな香りは？",
      choices: [
        { text: "甘い香り", category: :sweets },
        { text: "さっぱりした香り", category: :fruit },
        { text: "花の香り", category: :flower },
        { text: "自然の香り", category: :herb }
      ]
    },
    {
      text: "甘いお菓子は？",
      choices: [
        { text: "大好き", category: :sweets },
        { text: "わりと好き", category: :fruit },
        { text: "あまり食べない", category: :non_flavor },
        { text: "苦手", category: :herb }
      ]
    },
    {
      text: "好きな香りはどれ？",
      choices: [
        { text: "焼き菓子", category: :sweets },
        { text: "フルーツ", category: :fruit },
        { text: "お花", category: :flower },
        { text: "スパイス", category: :spice }
      ]
    },
    {
      text: "理想のティータイムは？",
      choices: [
        { text: "カフェ気分", category: :sweets },
        { text: "自然の中", category: :herb },
        { text: "ゆったり読書", category: :non_flavor },
        { text: "新しい体験", category: :unique }
      ]
    },
    {
      text: "香りの強さは？",
      choices: [
        { text: "しっかり香る", category: :spice },
        { text: "ほどよい", category: :fruit },
        { text: "やさしい", category: :flower },
        { text: "控えめ", category: :non_flavor }
      ]
    },
    {
      text: "新しい味への挑戦は？",
      choices: [
        { text: "大好き", category: :unique },
        { text: "たまにする", category: :fruit },
        { text: "あまりしない", category: :flower },
        { text: "しない", category: :non_flavor }
      ]
    }
  ]

  def self.question(step)
    QUESTIONS[step - 1]
  end

  def self.total_questions
    QUESTIONS.length
  end

  def self.finished?(step)
    step > total_questions
  end

  def self.result(scores)
    scores.max_by { |_, v| v }&.first
  end

end
