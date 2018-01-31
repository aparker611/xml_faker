class XmlFaker
  def run(file)
    return puts 'Please provide a valid filename' if file.nil? || !File.exist?(file)
  end

end
