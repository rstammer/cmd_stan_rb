module Stan
  class FitResult
    attr_reader :rows, :headers, :data_rows

    def initialize(original_output)
      # sometimes \r remains without the chomp
      @rows = Array(original_output.split("\n").map(&:chomp))

      # set headers
      headers_index = rows.index do |row|
        header_row?(row)
      end
      @headers = rows[headers_index].to_s.split(",")

      # set data rows
      data_rows_start_index = nil
      (headers_index + 1).upto(rows.length - 1) do |row_index|
      row = rows[row_index]
        if data_row?(row)
          data_rows_start_index = row_index
          break
        end
      end

      # last few lines are not actually data values but elapsed time
      data_rows_end_index = nil
      (rows.length - 1).downto(headers_index + 1) do |row_index|
        row = rows[row_index]
        if data_row?(row)
          data_rows_end_index = row_index
          break
        end
      end
      @data_rows = rows[data_rows_start_index..data_rows_end_index].map { |r| r.split(",") }

      define_histograms!
    end

    def parameters
      headers[7..]
    end

    private

    def define_histograms!
      headers.each do |parameter|
        define_singleton_method parameter do
          parameter_index = headers.index(parameter)
          data_rows.each_with_object({}) do |row, hash|
            v = row[parameter_index].to_f.round(1)
            hash[v] = (hash[v] || 0) + 1
          end.sort.to_h
        end
      end
    end

    # the first line that has no hash sign at the start AND at least seven words separated by a comma
    def header_row?(row)
      # in case a row is something not a string
      row_string = row.to_s
      row_string[0] != "#" && row_string.split(",").length >= 7
    end

    # data rows has numbers without a hash sign AND has the same entries as the length of the header
    def data_row?(row)
      # in case a row is something not a string
      row_string = row.to_s
      row_string[0] != "#" && row_string.split(",").length == headers.length
    end
  end
end
