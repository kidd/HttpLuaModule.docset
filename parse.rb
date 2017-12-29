require 'nokogiri'
require "sqlite3"

class Parser
  attr_reader :doc
  def initialize(path)
    f = File.read(path)
    @doc = Nokogiri::HTML(f)
  end

  def get(sel)
    elems = doc.css(sel)
    elems.map do |e|
      [e.text, e['id']]
    end
  end
end

# Open a database
db = SQLite3::Database.new "docSet.dsidx"

# Create a table
rows = db.execute <<-SQL
create table searchIndex(id INTEGER PRIMARY KEY,
                         name TEXT,
                         type TEXT,
                         path TEXT);
CREATE UNIQUE INDEX anchr  ON searchIndex (name, type, path);
SQL

# ngx.say
p =  Parser.new(ARGV.shift)
p.get('h1').each do |pair|
  db.execute "insert into searchIndex(name,type,path) values ( ?, 'Function', ? )", [pair.first, "HttpLuaModule.html#"+pair[1]]
end

p.get('h2').each do |pair|
  db.execute "insert into searchIndex(name,type,path) values ( ?, 'Function', ? )", [pair.first, "HttpLuaModule.html#"+pair[1]]
end
