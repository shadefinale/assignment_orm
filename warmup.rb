# your code goes here
class Article
    # notice that this is a CLASS method
    def self.all
        "SELECT articles.*"
    end

    def find(*ids)
      if ids.flatten.length == 1
        return "SELECT articles.* FROM articles WHERE articles.id=#{ids.flatten[0]} LIMIT 1"
      else
        ids = ids.flatten.reduce("") {|acc, col| acc+=col.to_s+","}[0..-2]
        return "SELECT articles.* FROM articles WHERE articles.id IN (#{ids})"
      end
    end

    def self.first
      "SELECT articles.* FROM articles ORDER BY articles.created_at LIMIT 1"
    end

    def self.last
      "SELECT articles.* FROM articles ORDER BY articles.created_at DESC LIMIT 1"
    end

    def self.select(*columns)
      ("SELECT " + columns.reduce("") {|acc, col| acc+=col.to_s+","})[0..-2] + " FROM articles"
    end

    def self.count
      "SELECT COUNT(*) FROM articles"
    end

    def self.where()
    end
end

# Article.find(id)
# Article.first and Article.last
# Article.select(:column1, :column2) -- Note that this can take any number of parameters.
# Article.count
# Extend Article.find to also take an array of id's
# Article.where(:column1 => "value", :column2 => "value") -- Note that this takes a hash of parameters, and it essentially joins each constraint with an AND.












