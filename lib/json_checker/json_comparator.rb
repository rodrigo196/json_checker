require 'diffy'
require 'tempfile'
require 'json_checker/checkable_file'
require 'json_checker/json_fetcher'

module JsonChecker
  class JSONComparator
    def self.compare(fileToCheck, compareTo)
      
      if fileToCheck.nil? || compareTo.nil? || !compareTo.is_a?(Array) || !fileToCheck.is_a?(CheckableFile)
        return
      end

      compareTo.each do |compare|
        if CheckableFile.is_valid_representation?(compare)
          checkableFile = CheckableFile.new(compare)
          fileContent = checkableFile.get_content()

          puts "Comparing #{fileToCheck.name} with #{checkableFile.name}"
          
          jsonComparator = JSONComparator.new()
          jsonComparator.compare_json(fileToCheck.get_content(), fileContent)
        end
      end
    end

    def compare_json(json, jsonToCompare)    
      temp_json = tempfile_from_json(json)
      temp_jsonToCompare = tempfile_from_json(jsonToCompare)

      unless temp_json.nil? && temp_jsonToCompare.nil?
        diff = Diffy::Diff.new(temp_json.path, temp_jsonToCompare.path, :source => 'files', :context => 3)
        puts diff
        report = html_report_from_diff(diff)
        save_report_to_file(report)

        temp_jsonToCompare.delete
        temp_json.delete
      end
    end

    def tempfile_from_json(json)
      json = JsonChecker::JSONFetcher.json_from_content(json)
      unless json.nil?
        tempfile = Tempfile.new("temp_json")
        tempfile.write(JSON.pretty_generate(json) + "\n")
        tempfile.close
        return tempfile
      end
      puts "[ERROR] File content is not a valid JSON"
      return nil
    end

    def save_report_to_file(report)
      if report.nil?
        puts "[ERROR] Invalid report"
      else
        File.write("output.html", report)
      end
      
    end

    def html_report_from_diff(diff)

      if diff.nil?
        return nil
      end

      result = ""
      style = "<style>  
          .addition {
              background: #eaffea;
          }
          .remotion {
              background: #ffecec;
          }
          div {
              outline: 1px solid #eff0d6;
              margin: 5px;
              padding: 8px;
              background: #ffffff;
          }
          p {
              margin-top: 0em;
              margin-bottom: 0em;
              white-space: pre;
              font-family: monospace;
              padding : 3;
              color: #3e3333
          }
      </style>"

      diff.to_s.each_line do |line|
        result = result + add_line(line)
      end

      return "<html>" + style + "<div>" +  result + "</div>" + "</html>"
    end

    def add_line(line)
      
      if line.nil?
        return ""
      end 

      line = line.gsub("\n","")
      formatter = "<p class=\"%{first}\">%{second}</p>"
      className = "null"

      if line.chars.first == "+"
        className = "addition"
      elsif line.chars.first == "-"
        className = "remotion"
      end
      return formatter % {first: className, second: line}
    end
  end
end
