require 'vlookup/connector'

#= Contains funtionalities of reading data
module FileReader

    #== Contains the functionalities of reading Excel data
    class Excel < Connector::ExcelReadConnector
        attr_reader :data

        def initialize(path, sht_name, col_name)
            super(path)
            @sht = @wb.sheet(sht_name)
            @col = col_name
            @data = nil
        end

        def read
            aoa = @sht.parse(@col.to_sym => @col)
            @data = aoa.collect { |item| item[@col.to_sym] }
            @data = @data.uniq
            return "Excel Data contains #{@data.size} row(s)\nExcel First Record => #{@data[0]}"
        end

        public :read

    end

    #== Contains the reading functionalities of MongoDB data
    class MongoDB < Connector::MongoConnector
        attr_reader :data

        def initialize(col_name, coll_name, db_name: 'ccsdm', host: 'localhost', port: '27017')
            super(coll_name, db_name: db_name, host: host, port: port) 
            @col = col_name
            @data = [] 
        end

        def read(qry: {}, hide: { '_id' => 0 })
            @coll.find(qry).projection(hide).each do |doc|
                @data = @data + [doc[@col]]
            end
            @data = @data.uniq
            return "Mongo Data contains #{@data.size} row(s)\nMongo First Record => #{@data[0]}"
        end

        public :read
    end

end 
