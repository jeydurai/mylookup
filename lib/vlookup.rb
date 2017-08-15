require "vlookup/version"
require "vlookup/validator"
require "vlookup/processor"

#= Entry point to startup the application
module Vlookup

    # Entry point method that starts the whole app
    def self.run(opts)
        left_table  = validate_option_left opts[:left]
        right_table = validate_option_right opts[:right]
        validate_option_lefton opts[:lefton]
        print_verbose(left_table, right_table, opts[:left], opts[:right]) if opts[:verbose]
        options = {
            :left => opts[:left],
            :right => opts[:right],
            :lefton => opts[:lefton],
            :righton => opts[:righton],
            :verbose => opts[:verbose],
        }
        unless opts[:righton]
            puts "[Warning]: #{opts[:lefton]} assumed as Right Table's matching column"
            options[:righton] = opts[:lefton]
        end
        processor = Processor.new(options)
        processor.process
    end

    # Print verbose
    def self.print_verbose left, right, opt_left, opt_right
        puts "\n\n"
        puts "======================================================================================="
        puts "#{left  == :mongo ? 'MongoDB Collection => ' : 'Excel File => '} #{opt_left} considered as LEFT TABLE"
        puts "#{right == :mongo ? 'MongoDB Collection => ' : 'Excel File => '} #{opt_right} considered as RIGHT TABLE"
        puts "======================================================================================="
        puts "\n\n"
    end

    # Validates the left option
    def self.validate_option_left opt
        unless opt
            puts "[Error]: Left Table's path must be given"
            exit
        else
            valid, comment = validate_existence opt
            comment =~ /mongodb/i ? :mongo : :excel
        end
    end

    # Validates the right option
    def self.validate_option_right opt
        unless opt
            puts "[Error]: Right Table's path must be given"
            exit
        else
            valid, comment = validate_existence opt
            comment =~ /mongodb/i ? :mongo : :excel
        end
    end

    # Validates the 'lefton' option
    def self.validate_option_lefton opt
        unless opt
            puts "[Error]: Left Table's matching column must be given" 
            exit
        end
    end

    # Validates whether the given file does exist or not
    def self.validate_existence opt
        valid, comment = Validator::FileValidator.new(opt).validate
        unless valid
            puts "[Error]: #{comment}"
            exit
        else
            return valid, comment
        end
    end

end
