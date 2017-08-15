#= Validation module to checks all the base rules in input options

require 'vlookup/connector'

module Validator

    #== File Validator to validate the input paths of a file
    class FileValidator

        def initialize(path)
            @path = path
            @coll = File.split(@path)[1] # In case of not a collection, this will have extension as well
        end

        def validate
            if is_excel_file
                return excel_file_exists ? [true, "#{@path} does exist"] : [false, "#{@path} does not exist"]
            else
                if @path =~ /\./i
                    return false, "#{@path} is neither an excel file nor a MongoDB collection" 
                else
                    @mongo_conn = Connector::MongoConnector.new(@coll)
                    unless @mongo_conn.collection_exists?
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
