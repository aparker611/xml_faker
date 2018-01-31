# XML Faker

## Task:

Write a Ruby 2.5 script that fakes student data in an XML file.

Given an XML input file (which will conform to the schema shown in `satchel_student_data_schema.xsd`),
running the following command:

```
./bin/xml_faker <input_filename>
```

should create a _new_ XML file with fake information for the following personally identifiable data fields:

* Forename
* Surname
* UPN
* FormerUPN
* EmailAddress

An example input file can be seen in `examples/satchel_student_data.xml`; but the script should of course
be designed to work with any input file in this format.

The generated file should have exactly the same structure as the original. The only
difference should be that these attributes (if present) are set to a sensible fake value.

Additionally, note that the email address of each student _must be unique_.

Feel free to incorporate any ruby gems as part of the solution, or add/move/rename any files
in this project.

---

This exercise is designed as an example of one of the many processes put in place by Satchel, in accordance with
[GDPR compliance](https://www.eugdpr.org/).
