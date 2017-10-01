def date(d)
  Date.parse(d) || Time.now
end

def body(url)
  TextApi.new.summarize(url)['sentences']
end

@sources = NewsApi.new.sources['sources']

@sources.each do |s|
  source = Source.find_or_initialize_by(name: s["name"], slug: s["id"])
  source.save!
end

Source.all.each do |s|
  articles = NewsApi.new.articles(s['slug'])['articles']
  articles.each do |a|
    begin
      article = Article.find_or_initialize_by(source_id: s.id, published_at: date(a['publishedAt']) , author: (a['author'] || s['name']), url: a['url'], title: a['title'], source_name: s.slug, slug: a['title'].parameterize)
      article.body = "summary tbd"
      # TextApi.new.summarize(a['url'])[:sentences]
      article.save!
    rescue TypeError => e
      puts "ERROR: #{e}, ARTICLE: #{a}"
    rescue NoMethodError => e
      puts "ERROR: #{e}, ARTICLE: #{a}"
    end
  end
end

