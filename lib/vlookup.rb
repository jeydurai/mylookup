require "vlookup/version"
require "vlookup/validator"
require "vlookup/processor"

#= Entry point to startup the application
module Vlookup

    # Entry point method that starts the whole app
    def self.run(opts)
        l_src  = source_type opts[:left], :left
        r_src = source_type opts[:right], :right
        options = {
            :left       => opts[:left],
            :right      => opts[:right],
            :lefton     => opts[:lefton],
            :righton    => opts[:righton],
            :leftsheet  => opts[:leftsheet],
            :rightsheet => opts[:rightsheet],
            :verbose    => opts[:verbose],
            :l_source   => l_src, 
            :r_source   => r_src,
        }
        validate_sources l_src, r_src, options
        processor = Processor.new(options)
        processor.process
    end

    def validate_sources l_src, r_src, ops
        l_path, l_tbl, l_col = ops[:left], ops[:leftsheet], ops[:lefton]
        r_path, r_tbl, r_col = ops[:right], ops[:rightsheet], ops[:righton]
        if l_src == :excel
            sht_comment, col_comment = validate_excel_attribs(l_path, l_tbl, l_col, :left)
            puts "[Info]: Left Table => #{sht_comment} | #{col_comment}" if ops[:verbose]
        elsif l_src == :mongo
            coll = File.split(l_path)[1]
            valid, comment = validate_mongo_field_existence coll, l_col
            puts "[Info]: Left Table => #{comment}" if ops[:verbose]
        end
        if r_src == :excel
            sht_comment, col_comment = validate_excel_attribs(r_path, r_tbl, r_col, :right)
            puts "[Info]: Right Table => #{sht_comment} | #{col_comment}" if ops[:verbose]
        elsif r_src == :mongo
            coll = File.split(r_path)[1]
            valid, comment = validate_mongo_field_existence coll, r_col
            puts "[Info]: Right Table => #{comment}" if ops[:verbose]
        end
    end

    def validate_excel_attribs path, sht_name, col_name, src_type
        valid, sht_comment = validate_excel_sheet_existence sht_name, path 
        valid, col_comment = validate_excel_column_existence col_name, sht_name, path, src_type
        sht_comment, col_comment
    end

    # Validates the left option
    def self.source_type opt, what_tbl
        unless opt
            puts "[Error]: #{what_tbl.to_s.capitalize} Table's path must be given"
            exit
        else
            valid, comment = validate_file_existence opt
            comment =~ /mongodb/i ? :mongo : :excel
        end
    end

    # Validates whether the given file does exist or not
    def self.validate_file_existence path
        valid, comment = Validator::FileValidator.new(path).validate
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end
    
    # Validates whether the given sheet does exist or not
    def self.validate_excel_sheet_existence sht, path
        sht_name = sht
        sht_name = 0 unless sht_name
        validator = Validator::ExcelAttribValidator.new(path, sht_name)
        valid, comment = validator.validate_sheet
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end

    # Validates whether the given column does exist or not
    def self.validate_excel_column_existence col, sht, path, what_tbl
        unless col
            puts "[Error]: #{what_tbl.to_s.capitalize} Table's matching column must be given" 
            exit
        end
        validator = Validator::ExcelAttribValidator.new(path, sht)
        valid, comment = validator.validate_column col
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end

    # Validates whether the given column does exist or not
    def self.validate_mongo_field_existence coll_name, field
        validator = Validator::MongoAttribValidator.new(coll_name, field)
        valid, comment = validator.validate_field
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end

end
