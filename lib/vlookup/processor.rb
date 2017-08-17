require 'vlookup/reader'

#= class containing the functionalities of handling the whole show
class Processor

    def initialize(opts)
       @l_db, @l_tbl, @l_on = opts[:left], opts[:leftsheet], opts[:lefton]
       @r_db, @r_tbl, @r_on = opts[:right], opts[:rightsheet], opts[:righton]
       @verbose = opts[:verbose]
       @l_src, @r_src = opts[:l_src], opts[:r_src] 
       @l_reader, @r_reader = nil, nil
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
        puts "Reading Left Table data..."
        l_comment = @l_reader.read
        puts "Reading Right Table data..."
        r_comment = @r_reader.read
        puts "[Info]: LEFT =>#{l_comment}"
        puts "[Info]: RIGHT=>#{r_comment}"
    end

    public :process

end
