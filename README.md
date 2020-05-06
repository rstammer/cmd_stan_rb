# RubyStan

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_stan'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby_stan

## Before you can start…

After cloning _this_ repository, you need to get `CmdStan` on board. Suggestion: Do it this way:

    cd vendor; git clone https://github.com/stan-dev/cmdstan

## Usage


    # First, let's do some setup.
    # You need to have the stan compiler
    # and the output tooling built for your system
    RubyStan.build_binaries


    model =
      RubyStan::Model.new("bernoulli-test") do
        # Stan code goes here as a string
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

    model.data = {
      "N" => 4,
      "y" => [0,1,0,0]
    }

    model.compile
    model.fit
    puts model.show


The latter command shows the simulation result:


    Inference for Stan model: b439_model
    1 chains: each with iter=(1000); warmup=(0); thin=(1); 1000 iterations saved.

    Warmup took (0.0062) seconds, 0.0062 seconds total
    Sampling took (0.013) seconds, 0.013 seconds total

                    Mean     MCSE  StdDev     5%   50%   95%    N_Eff  N_Eff/s    R_hat
    lp__            -4.4  3.5e-02    0.77   -5.9  -4.1  -3.8  4.9e+02  3.7e+04  1.0e+00
    accept_stat__   0.90  4.4e-03    0.15   0.53  0.97   1.0  1.2e+03  9.2e+04  1.0e+00
    stepsize__       1.1      nan    0.00    1.1   1.1   1.1      nan      nan      nan
    treedepth__      1.4  1.5e-02    0.48    1.0   1.0   2.0  1.0e+03  7.6e+04  1.0e+00
    n_leapfrog__     2.3  3.2e-02    0.97    1.0   3.0   3.0  9.2e+02  6.8e+04  1.0e+00
    divergent__     0.00      nan    0.00   0.00  0.00  0.00      nan      nan      nan
    energy__         4.9  5.2e-02     1.1    3.9   4.6   6.8  4.3e+02  3.2e+04  1.0e+00
    theta           0.34  9.3e-03    0.18  0.071  0.32  0.64  3.7e+02  2.7e+04  1.0e+00

    Samples were drawn using hmc with nuts.
    For each parameter, N_Eff is a crude measure of effective sample size,
    and R_hat is the potential scale reduction factor on split chains (at
    convergence, R_hat=1).
