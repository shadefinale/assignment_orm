module FakeActiveRecord
  class BASE
    # CLASS method on any
    # model object
    # that returns pluralized
    # version of class name
    def self.table_name
      "#{self.name.downcase}s"
    end

    def self.create(**args)
      column_names = args.keys.reduce("") {|acc, col| acc+=col.to_s+","}[0..-2]
      column_values = args.values.reduce("") do |acc, val|
        if val.is_a? String
          acc+="'#{val.to_s}'"+","
        else
          acc+= val.to_s+","
        end
      end[0..-2]


      insert_string = <<INSERTSTRING
      INSERT INTO #{Post.table_name} (#{column_names})
      VALUES (#{column_values});
INSERTSTRING
      DB.execute(insert_string)
    end

    def self.all
      DB.execute("SELECT #{self.table_name}.* FROM posts")
    end

    def self.find(*ids)
      if ids.flatten.length == 1
        DB.execute("SELECT #{self.table_name}.* FROM #{self.table_name} WHERE #{self.table_name}.id=#{ids.flatten[0]} LIMIT 1")
      else
        ids = ids.flatten.reduce("") {|acc, col| acc+=col.to_s+","}[0..-2]
        DB.execute("SELECT #{self.table_name}.* FROM #{self.table_name} WHERE #{self.table_name}.id IN (#{ids})")
      end
    end

    def self.first
      DB.execute("SELECT #{self.table_name}.* FROM #{self.table_name} ORDER BY #{self.table_name}.created_at LIMIT 1")
    end

    def self.last
      DB.execute("SELECT #{self.table_name}.* FROM #{self.table_name} ORDER BY #{self.table_name}.created_at DESC LIMIT 1")
    end

    def self.select(*columns)
      raise ArgumentError unless columns.all?{|col| self.columns.include? (col)}
      DB.execute(("SELECT " + columns.reduce("") {|acc, col| acc+=col.to_s+","})[0..-2] + " FROM #{self.table_name}")
    end

    def self.count
      DB.execute("SELECT COUNT(*) FROM #{self.table_name}")
    end

    def self.where(**opts)
      raise ArgumentError unless opts.keys.all?{|col| self.columns.include? (col.to_s)}
      result = "SELECT #{self.table_name}.* FROM #{self.table_name} WHERE "
      opts.each do |col, val|
        if val.is_a? String
          result += col.to_s + "='#{val}' AND "
        else
          result += col.to_s + "=#{val} AND "
        end
      end
      DB.execute(result[0..-6])
    end

    # gives you a hash of {column_name: column_type }
    # for your table
    def self.schema
      return @schema if @schema

      @schema = {}

      # example:
      # If you're a Post
      # runs DB.table_info("posts")
      DB.table_info(table_name) do |row|
        @schema[row["name"]] = row["type"]
      end

      @schema
    end

    # convenience wrapper for your schema's column names
    def self.columns
      schema.keys
    end





    # YOUR CODE GOES HERE





  end
end

