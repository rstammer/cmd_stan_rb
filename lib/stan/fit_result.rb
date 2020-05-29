module Stan
  class FitResult
    attr_reader :rows, :headers, :data_rows

    def initialize(original_output)
      @rows = Array(original_output.split("\n"))
      @headers = rows[38].to_s.split(",") # In L39 there is the header column
      @data_rows = rows[43..].map { |r| r.split(",") } # From L44 on there is the raw data!
    end
  end
end
