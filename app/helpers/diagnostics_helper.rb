module DiagnosticsHelper
  def x_share_url(result_title)
    text = "あなたにおすすめの紅茶は「#{result_title}」です！"
    url  = request.original_url

    "https://twitter.com/intent/tweet?text=#{CGI.escape(text)}&url=#{CGI.escape(url)}"
  end
end
