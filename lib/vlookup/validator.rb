#= Validation module to checks all the base rules in input options

require 'vlookup/connector'

module Validator

    #== Excel file attributes and properties validator
    class ExcelAttribValidator < Connector::ExcelReadConnector

        def initialize(path, sht)
            super(path)
            @sht = sht
        end
        
        def validate_sheet
            if sheet_exists? @sht
                [true, "#{@sht} sheet in #{@path} exists"]
            else
                [false, "#{@sht} sheet in #{@path} DOES NOT exist!"]
            end
        end

        def validate_column col_name
            if column_exists? @sht, col_name 
                [true, "#{col_name} column in #{@sht} sheet of #{@path} exists"]
            else
                [false, "#{col_name} column in #{@sht} sheet of #{@path} DOES NOT exist!"]
            end
        end

        public :validate_sheet, :validate_column

    end

    #== MongoDB collection attributes and properties validator
    class MongoAttribValidator < Connector::MongoConnector

        def initialize(coll_name, field)
            super(coll_name)
            @field = field
        end

        def validate_field
            if field_exists? @field
                [true, "'#{@field}' field exists in '#{@coll_name}' collection"]
            else
                [false, "'#{@field}' field DOES NOT exist in '#{@coll_name}' collection"]
            end
        end

        public :validate_field

    end 

    #== File Validator to validate the input paths of a file
    class FileValidator

        def initialize(path)
            @path = path
            @coll = File.split(@path)[1] # In case of not a collection, this will have extension as well
        end

        def validate
            if is_excel_file
                if excel_file_exists
                    [true, "#{@path} does exist"]
                else
                    return [false, "#{@path} does not exist"]
                end
            else
                if @path =~ /\./i
                    return false, "#{@path} is neither an excel file nor a MongoDB collection" 
                else
                    mongo_conn = Connector::MongoConnector.new(@coll)
                    unless mongo_conn.collection_exists?
                        return [false, "'#{@path}' collection in MongoDB does not exist"]
                    else
                        return true, "'#{@path}' is a MongoDB collection"
                    end
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
