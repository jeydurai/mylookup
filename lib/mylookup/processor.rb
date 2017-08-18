require 'mylookup/reader'
require 'mylookup/writer'

#= class containing the functionalities of handling the whole show
class Processor

    def initialize(opts)
       @l_db, @l_tbl, @l_on = opts[:left], opts[:leftsheet], opts[:lefton]
       @r_db, @r_tbl, @r_on = opts[:right], opts[:rightsheet], opts[:righton]
       @verbose = opts[:verbose]
       @l_src, @r_src = opts[:l_src], opts[:r_src] 
       @l_reader, @r_reader = nil, nil
       @l_data, @r_data, @matched, @unmatched = nil, nil, nil, nil
       if @l_src == :excel
           @l_reader = FileReader::Excel.new(@l_db, @l_tbl, @l_on)
       else
           @l_reader = FileReader::MongoDB.new(@l_on, @l_tbl, db_name: @l_db)
       end
       if @r_src == :excel
           @r_reader = FileReader::Excel.new(@r_db, @r_tbl, @r_on)
       else
           @r_reader = FileReader::MongoDB.new(@r_on, @r_tbl, db_name: @r_db)
       end
    end

    def process
        puts "Processing initiating..." 
        read_data
        mylookup
        write_unmatched unless @unmatched.empty?
    end

    def mylookup
        puts "Executing mylookup..."
        @unmatched = @l_data - @r_data
        @matched = @l_data - @unmatched
        puts "[Info]: Left Table size: #{@l_data.size} row(s)"
        puts "Matched: #{@matched.size} row(s) Unmatched: #{@unmatched.size} row(s)"
        puts "Matched: #{(@matched.size.to_f*100/@l_data.size.to_f).round(2)}%"
    end

    def write_unmatched
        writer = FileWriter::Excel.new('unmatched.xlsx', @unmatched, @l_on) 
        writer.write
    end

    def read_data
        puts "Reading Left Table data..."
        l_comment = @l_reader.read
        @l_data = @l_reader.data
        puts "Reading Right Table data..."
        r_comment = @r_reader.read
        @r_data = @r_reader.data
        puts "[Info]: LEFT =>#{l_comment}"
        puts "[Info]: RIGHT=>#{r_comment}"
    end

    private :read_data, :mylookup, :write_unmatched
    public :process

end
