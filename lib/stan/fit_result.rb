module Stan
  class FitResult
    attr_reader :rows, :headers, :data_rows

    def initialize(original_output)
      @rows = Array(original_output.split("\n"))
      @headers = rows[38].to_s.split(",") # In L39 there is the header column
      @data_rows = rows[43..].map { |r| r.split(",") } # From L44 on there is the raw data!

      define_histograms!
    end

    def parameters
      headers[7..]
    end

    private

    def define_histograms!
      headers.each do |parameter|
        define_singleton_method parameter do
          parameter_index = parameters.index(parameter)
          data_rows.each_with_object({}) do |row, hash|
            v = row[parameter_index].to_f.round(1)
            hash[v] = (hash[v] || 0) + 1
          end.sort.to_h
        end
      end
    end
  end
end
