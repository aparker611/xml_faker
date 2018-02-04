require 'nokogiri'
require 'faker'

class XmlFaker

def get_student_data(file)
  students = Nokogiri::XML(File.open(file))
  names = students.css("Forename").map { |node| node.children.text }
  mis_id  = students.css("MIS_ID").map { |node| node.children.text }

  pupils = [
    {ID: nil, UPN: "", forename: "", surname: "", email: "", formerUPN: "", gender: "", yearGroup: "", lang: ""}
  ]

  student = pupils.shift

  students.xpath('//Student').each do |students|
    student[:forename]      = Faker::Name.first_name,
    student[:surname]       = Faker::Name.last_name,
    student[:UPN]           = Faker::Code.ean,
    student[:formerUPN]     = Faker::Code.ean,
    student[:gender]        = students.xpath('Gender').inner_html,
    student[:yearGroup]     = students.xpath('YearGroup').inner_html,
    student[:email]         = Faker::Internet.unique.email,
    student[:lang]          = students.xpath('FirstLanguage').inner_html,
    student[:ID]            = students.xpath('MIS_ID').inner_html

    pupils << student.clone
  end
verify_student_data(pupils, file)
end

def verify_student_data(students, file)
  emails = students.map { |student| student[:email] }
  emails = emails.select { |email| emails.count(email) > 1 }.uniq

  return puts "Duplicate emails, please make sure the student emails are unique." if emails.count > 0
  format_xml_file(students, file)
end

def run(file)
  return puts 'Please provide a valid filename' if file.nil?
  return puts 'Please prove another valid filename, as this one already exists' if !File.exist?(file)

  student = get_student_data(file)
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
        xml.Forename      student[:forename].first
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
  file_path = file.split('.')
  filename = file_path[1]
  filepath = "./" + filename + "_fake_data"
  file_extension = "." + file_path.last

  file = filepath+file_extension
  File.open("#{file}", "w") { |f| f.write(students)}
end

def validate_student_data(students, file)
  xsd = Nokogiri::XML::Schema(File.read("./satchel_student_data_schema.xsd"))
  student_list = Nokogiri::XML(students)

  xsd.validate(student_list).each do |error|
    puts error.message
  end

  create_xml_file(students, file)
end

end
