require 'nokogiri'

class XmlFaker

def student_data
  students = [
    {ID: 1, UPN: "S535449032228", forename: "James", surname: "Penn", email: "jpenn@stanleypark.com", formerUPN: "S535449032229", gender: "Male", yearGroup: "Year 3", lang: "ENG"},
    {ID: 2,UPN: "K535449032230", forename: "Sandy", surname: "Snow", email: "ssnow@stanleypark.com", formerUPN: "K535449032231", gender: "Female", yearGroup: "Year 2", lang: "ENG"},
    {ID: 3, UPN: "J535449032230", forename: "Mike", surname: "Myers", email: "myers@stanleypark.com", formerUPN: "J535449032230", gender: "Male", yearGroup: "Year 5", lang: "ENG"},
    {ID: 4, UPN: "P535449032228", forename: "Penny", surname: "Dyer", email: "pdyer@stanleypark.com", formerUPN: "P535449032229", gender: "Female", yearGroup: "Year 4", lang: "ENG"},
    {ID: 5, UPN: "D535449032230", forename: "Roger", surname: "Smith", email: "rogers@stanleypark.com", formerUPN: "D535449032231", gender: "Male", yearGroup: "Year 1", lang: "ENG"},
    {ID: 6, UPN: "E535449032230", forename: "Johnny", surname: "Johnson", email: "jjohnson@stanleypark.com", formerUPN: "E535449032230", gender: "Male", yearGroup: "Year 3", lang: "ENG"},
    {ID: 7, UPN: "S695449032228", forename: "Robert", surname: "Pennfold", email: "rpennfold@stanleypark.com", formerUPN: "S535449033229", gender: "Male", yearGroup: "Year 2", lang: "ENG"},
    {ID: 8, UPN: "R535449032230", forename: "Chelsey", surname: "Luigi", email: "chelluigi@stanleypark.com", formerUPN: "R535449032231", gender: "Female", yearGroup: "Year 4", lang: "ENG"}
  ]

  return puts "Student list is empty!" if students.empty?
  return students
end

def verify_student_data(students, file)
  emails = students.map { |student| student[:email] }
  emails = emails.select { |email| emails.count(email) > 1 }.uniq

  return puts "Duplicate emails, please make sure the student emails are unique." if emails.count > 0
  format_xml_file(students, file)
end

def run(file)
  return puts 'Please provide a valid filename' if file.nil?
  return puts 'Please prove another valid filename, as this one already exists' if File.exist?(file)

  student = student_data
  verify_student_data(student, file)
end

def format_xml_file(students, file)

  studentxml = Nokogiri::XML::Builder.new { |xml|

  xml.Satchel do

  xml.Header do
    xml.AcademicYear Time.now.year
  end

  xml.Students {
    students.each { |student|
      xml.Student {
        xml.MIS_ID        student[:ID]
        xml.Forename      student[:forename]
        xml.Surname       student[:surname]
        xml.UPN           student[:UPN]
        xml.FormerUPN     student[:formerUPN]
        xml.Gender        student[:gender]
        xml.YearGroup     student[:yearGroup]
        xml.EmailAddress  student[:email]
        xml.FirstLanguage student[:lang]
      }
    }
  }
end
}.to_xml
  validate_student_data(studentxml, file)
end

def create_xml_file(students, file)
  File.open("#{file}", "w") { |f| f.write(students)}
end

def validate_student_data(students, file)
  xsd = Nokogiri::XML::Schema(File.read("./satchel_student_data_schema.xsd"))
  student_list = Nokogiri::XML(students)

  xsd.validate(student_list).each do |error|
    puts error.message
  end

  create_xml_file(students, file)
  p "Verified"
end

end
