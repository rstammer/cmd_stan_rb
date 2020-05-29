module Stan
  class Histogram
    attr_reader :list, :bin_size

    def initialize(list, bin_size: nil)
      @list = list
      @bin_size = bin_size
    end

    def to_a
      @list.each_with_object({}) do |item, hash|
        bin =
          if bin_size.to_f > 0
            (item.to_f / bin_size).round * bin_size
          else
            item
          end

        hash[bin] = hash[bin].to_i + 1
      end.sort
    end

    def to_h
      to_a.to_h
    end
  end
end
