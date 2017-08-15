#= Validation module to checks all the base rules in input options

module Validator

    #== File Validator to validate the input paths of a file
    class FileValidator

        def initialize(path)
            @path = path
        end

        def validate
            if is_excel_file
                return excel_file_exists ? [true, "#{@path} does exist"] : [false, "#{@path} does not exist"]
            else
                if @path =~ /\./i
                    return false, "#{@path} is neither an excel file nor a MongoDB collection" 
                else
                    return true, "#{@path} may be a MongoDB collection"
                end
            end
        end

        def excel_file_exists
            File.file?(@path)
        end

        def is_excel_file
            @path[-5, 5] == '.xlsx'
        end

        private :is_excel_file, :excel_file_exists

    end

end
