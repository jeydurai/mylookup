require 'mylookup/connector'


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

        def read(match: {}, hide: {}, q_meth: :find)
            aoa = @sht.parse(@col.to_sym => @col)
            @data = aoa.collect { |item| item[@col.to_sym].to_s.downcase }
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

        def read(hide: { '_id' => 0 }, q_meth: :agg, match: {})
            if q_meth == :find
                @coll.find(match).projection(hide).each do |doc|
                    @data = @data + [doc[@col].to_s.downcase]
                end
                @data = @data.uniq
            elsif q_meth == :agg
                qry = [
                    { '$match'   => match },
                    { '$group'   => { '_id' => { @col => '$' + @col } } },
                    { '$project' => { '_id' => 0, @col => '$_id.' + @col } }
                ]
                @coll.aggregate(qry).each do |doc|
                    @data = @data + [doc[@col].to_s.downcase]
                end
            end
            return "Mongo Data contains #{@data.size} row(s)\nMongo First Record => #{@data[0]}"
        end

        public :read
    end

end 
