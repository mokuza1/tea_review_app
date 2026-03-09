class TeaDiagnosticService

  CATEGORIES = %i[
    fruit
    flower
    spice
    sweets
    herb
    unique
    non_flavor
  ].freeze

  QUESTIONS = [
    {
      text: "今日の「気分」を例えるなら？",
      options: [
        { text: "朝日を浴びて、元気にスタートしたい！", scores: { fruit: 2, herb: 1 } },
        { text: "優しい気持ちで、ゆったり過ごしたい。", scores: { flower: 2, non_flavor: 1 } },
        { text: "ちょっと贅沢に、自分を甘やかしたい！", scores: { sweets: 2, unique: 1 } }
      ]
    },

    {
      text: "合わせたい「おやつ」はどっちのイメージ？",
      options: [
        { text: "甘酸っぱいタルトや、季節のフルーツケーキ", scores: { fruit: 2, flower: 1 } },
        { text: "チョコやキャラメル、クリームたっぷりのスイーツ", scores: { sweets: 2, spice: 1 } },
        { text: "シンプルなスコーンや、バター香るクッキー", scores: { non_flavor: 2, herb: 1 } }
      ]
    },

    {
      text: "直感で好きな「香り」はどれ？",
      options: [
        { text: "清潔感のある、せっけんやミントの香り", scores: { herb: 2, fruit: 1 } },
        { text: "お花屋さんの前を通ったときのような香り", scores: { flower: 2, sweets: 1 } },
        { text: "異国の市場やお香のような不思議と落ち着く香り", scores: { spice: 2, unique: 1 } }
      ]
    },

    {
      text: "あなたが惹かれる「お部屋の雰囲気」は？",
      options: [
        { text: "木のぬくもりがある、シンプルで上質な空間", scores: { non_flavor: 2, herb: 1 } },
        { text: "窓が大きくて明るい、カラフルでポップな空間", scores: { fruit: 2, spice: 1 } },
        { text: "お花やアンティークを飾った、上品な空間", scores: { flower: 2, unique: 1 } }
      ]
    },

    {
      text: "仕事や家事の合間、どう「リフレッシュ」したい？",
      options: [
        { text: "体をポカポカ温めて、活力をチャージしたい", scores: { spice: 2, sweets: 1 } },
        { text: "爽やかな風を感じて、頭をシャキッとさせたい", scores: { herb: 2, fruit: 1 } },
        { text: "良い香りに包まれて、映画の主人公気分に浸りたい", scores: { unique: 2, flower: 1 } }
      ]
    },

    {
      text: "「色」で選ぶなら、今の直感はどれ？",
      options: [
        { text: "オレンジや黄色のような、ビタミンカラー", scores: { fruit: 1, spice: 1, sweets: 1 } },
        { text: "ピンクや白のような、淡くて優しい色", scores: { flower: 1, herb: 1, non_flavor: 1 } },
        { text: "深みのある赤や茶色のような、落ち着いた色", scores: { unique: 1, spice: 1, non_flavor: 1 } }
      ]
    },

    {
      text: "飲み終わった後、どんな「後味」がいい？",
      options: [
        { text: "お口の中がスッキリ、清々しい感じ", scores: { non_flavor: 2, herb: 1 } },
        { text: "幸せな甘い余韻が、ふわっと残る感じ", scores: { sweets: 2, flower: 1 } },
        { text: "複雑で奥深い、大人の余韻を楽しむ感じ", scores: { unique: 2, spice: 1 } }
      ]
    }
  ].freeze

  RESULTS = {
    fruit: {
      title: "フルーツ",
      subtitle: "果実のフレッシュな香り",
      description: "元気になれるような爽やかな一杯。気分をリフレッシュしたいときにぴったりです。"
    },

    flower: {
      title: "フラワー",
      subtitle: "華やかでやさしい香り",
      description: "優雅でやさしい気持ちになれる紅茶。ゆったりした時間を過ごしたいときにおすすめです。"
    },

    sweets: {
      title: "スイート",
      subtitle: "デザートを思わせる甘い香り",
      description: "デザートのように楽しめる紅茶。おやつタイムをより幸せな時間にしてくれます。"
    },

    spice: {
      title: "スパイス",
      subtitle: "温かくも刺激ある香り",
      description: "シナモンやクローブなど、スパイシーな香りが魅力。リラックスしたいときにぴったりです。"
    },

    herb: {
      title: "ハーブ",
      subtitle: "爽やかで清涼感のある香り",
      description: "すっきりした飲み心地で気分転換にぴったり。リフレッシュしたいときの一杯です。"
    },

    unique: {
      title: "ユニーク",
      subtitle: "特徴的で個性豊かな香り",
      description: "少し変わった魅力を楽しめる紅茶。新しい味に出会いたいあなたにおすすめです。"
    },

    non_flavor: {
      title: "ノンフレーバー",
      subtitle: "茶葉本来の香り",
      description: "シンプルで奥深い紅茶の味わい。紅茶本来の美味しさをゆっくり楽しめます。"
    }
  }.freeze

  def self.result_data(category)
    RESULTS[category]
  end

  class << self

    def questions
      QUESTIONS
    end

    def question(step)
      QUESTIONS[step - 1]
    end

    def total_questions
      QUESTIONS.size
    end

    def diagnose(answer_indexes)

      scores = CATEGORIES.index_with { 0 }

      answer_indexes.each_with_index do |option_index, question_index|
        option_index = option_index.to_i

        option = QUESTIONS[question_index][:options][option_index]

        option[:scores].each do |category, point|
          scores[category] += point
        end
      end

      scores.max_by { |_, score| score }.first
    end

  end
end