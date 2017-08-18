require 'mylookup/connector'


#=Contains functionalities of writing data
module FileWriter

    #== Contains the functionalities of writing data in Excel
    class Excel < Connector::ExcelWriteConnector

        def initialize(path, data, header)
            super(path)
            @data = data
            @header = header
        end

        def write
            puts "Writing Data in Excel"
            begin
                write_header
                write_data
            rescue StandardError => err
                puts "[Error]: Error occured while writing in Excel!!!"
                puts err
            end
        end

        def write_header
            @ws.add_cell(0, 0, @header)
        end

        def write_data
            @data.each_with_index do |d, i|
                @ws.add_cell(i+1, 0, d.to_s.upcase)
            end
            @wb.write(@path)
        end

        private :write_header, :write_data
        public :write
    end

end

