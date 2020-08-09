module Stan
  module Examples
    class << self
      def bernoulli
        %q{
          data {
            int<lower=0> N;
            int<lower=0,upper=1> y[N];
          }

          parameters {
            real<lower=0,upper=1> theta;
          }

          model {
            theta ~ beta(1,1);  // uniform prior on interval 0,1
            y ~ bernoulli(theta);
          }
        }
      end

      # Convenience method to cross check on bundle console if all pieces
      # are glued together correctly. Should get supported by far more test
      # cases, but until I managed this this is a good assistence 😅
      def run_bernoulli_integration_test
        model = Stan::Model.new("test_#{rand(1000000)}") do
          Stan::Examples.bernoulli
        end
        model.compile
        model.data = {"N"=>4, "y"=>[1,1,0,0]}
        result = model.fit(warm_up: 5, samples: 10)
        result.theta
      end
    end
  end
end
