#= Module containing connectors to databases

module Connector

    #== Defines MongoDB connection properties
    class MongoConnector
        require 'mongo'

        attr_accessor :client, :coll, :coll_name, :db_name, :host, :port

        def initialize(coll_name, db_name: 'ccsdm', host: 'localhost', port: '27017')
            @coll_name, @db_name, @host, @port = coll_name, db_name, host, port
            Mongo::Logger.logger.level = Logger::WARN
            @conn_str = @host + ':' + @port
            @client = Mongo::Client.new([@conn_str], :database => @db_name)
            @coll = @client[@coll_name]
        end

        # Queries and returns number of documents in the collection
        def recs qry
            @coll.find(qry).count
        end

        def collection_exists?
            recs({}) > 0
        end

        def field_exists? field
            @coll.find({}).projection({ '_id' => 0 }).limit(1).collect { |doc| doc }[0].keys.include? field
        end

        public :recs, :collection_exists?
    end

    class ExcelReadConnector
        require 'roo'
        
        def initialize(path)
            @path = path
            @wb = Roo::Excelx.new(@path) 
            @sheets = @wb.sheets
        end

        def sheet_exists? sht_name
            @sheets.include? sht_name
        end

        def column_exists? sht, col_name 
            @wb.sheet(sht).row(1).include? col_name
        end
    end
end 
