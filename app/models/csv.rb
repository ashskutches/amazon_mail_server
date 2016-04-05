class Csv
  attr_accessor :file

  def initialize(file)
    self.file = file
  end

  def generate_text_file_by_column(column)
    collected_text = collect_by_column(column)
    File.open("assets/" + column + ".txt", "w+") do |f|
      collected_text.each { |element| f.puts(TextParser.remove_characters(element)) }
    end
  end

  def save(name: "report")
    File.open("assets/generated/" + name + ".txt", 'w') { |file| file.write(self.file) }
  end

  private

  def collect_by_column(column)
    self.file.by_row.collect do |row|
      TextParser.seperate_into_words(row[column]) unless row[column].nil?
    end.flatten.compact.uniq
  end
end
