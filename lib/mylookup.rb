require "mylookup/version"
require "mylookup/validator"
require "mylookup/processor"

#= Entry point to startup the application
module Mylookup

    # Entry point method that starts the whole app
    def self.run(opts)
        validate_options opts 
        l_src  = source_type opts[:left], opts[:leftsheet], :left
        r_src = source_type opts[:right], opts[:rightsheet], :right
        options = {
            :left       => opts[:left],
            :right      => opts[:right],
            :lefton     => opts[:lefton],
            :righton    => opts[:righton],
            :leftsheet  => opts[:leftsheet],
            :rightsheet => opts[:rightsheet],
            :verbose    => opts[:verbose],
            :l_src   => l_src, 
            :r_src   => r_src,
        }
        validate_sources l_src, r_src, options
        processor = Processor.new(options)
        unless opts[:get]
            processor.process
        else
            processor.process_without_writing
        end
    end

    # Health check up on options entered
    def self.validate_options opts
        unless opts[:left]
            puts "[Error]: Left database/file name must be defined"
            exit
        else
            unless opts[:leftsheet]
                puts "[Warning]        : Left table name must be defined in case of source being MongoDB"
                puts "[Warning--cont'd]: First/Default sheet is assumed to be Left Table/Sheet "
            else
                unless opts[:lefton]
                    puts "[Error]: Left table/sheet matching column must be defined" 
                    exit
                end
            end
        end
        unless opts[:right]
            puts "[Error]: Right Database/File name must be defined"
            exit
        else
            unless opts[:rightsheet]
                puts "[Warning]        : Right Collection name must be defined in case of source being MongoDB"
                puts "[Warning--cont'd]: First/Default Sheet is assumed to be Right Table/Sheet "
            else
                unless opts[:righton]
                    puts "[Error]: Right table/sheet matching column must be defined" 
                    exit
                end
            end
        end
        return true
    end

    # Validates the existence of fields/sheets of the left and right tables
    def self.validate_sources l_src, r_src, ops
        l_path, l_tbl, l_col = ops[:left], ops[:leftsheet], ops[:lefton]
        r_path, r_tbl, r_col = ops[:right], ops[:rightsheet], ops[:righton]
        if l_src == :excel
            sht_comment, col_comment = validate_excel_attribs(l_path, l_tbl, l_col, :left)
            puts "[Info]: Left Table => #{sht_comment} | #{col_comment}" if ops[:verbose]
        elsif l_src == :mongo
            db = File.split(l_path)[1]
            valid, comment = validate_mongo_field_existence l_tbl, db, l_col
            puts "[Info]: Left Table => #{comment}" if ops[:verbose]
        end
        if r_src == :excel
            sht_comment, col_comment = validate_excel_attribs(r_path, r_tbl, r_col, :right)
            puts "[Info]: Right Table => #{sht_comment} | #{col_comment}" if ops[:verbose]
        elsif r_src == :mongo
            db = File.split(r_path)[1]
            valid, comment = validate_mongo_field_existence r_tbl, db, r_col
            puts "[Info]: Right Table => #{comment}" if ops[:verbose]
        end
    end

    # Validates the existence of sheet and matching column in an excel file
    def self.validate_excel_attribs path, sht_name, col_name, src_type
        valid, sht_comment = validate_excel_sheet_existence sht_name, path 
        valid, col_comment = validate_excel_column_existence col_name, sht_name, path, src_type
        return sht_comment, col_comment
    end

    # Validates and gives the type of the file whether it is an excel file or
    # Mongo DB collection
    def self.source_type file_name, sht, what_tbl
        unless file_name
            puts "[Error]: #{what_tbl.to_s.capitalize} Table's path must be given"
            exit
        else
            valid, comment = validate_file_existence file_name, sht
            comment =~ /mongodb/i ? :mongo : :excel
        end
    end

    # Validates whether the given file does exist or not
    def self.validate_file_existence path, sht
        valid, comment = Validator::FileValidator.new(path, coll: sht).validate
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
    def self.validate_mongo_field_existence coll_name, db_name, field
        validator = Validator::MongoAttribValidator.new(coll_name, db_name, field)
        valid, comment = validator.validate_field
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end

end
