# CmdStanRb
[![Build Status](https://travis-ci.org/neumanrq/cmd_stan_rb.svg?branch=master)](https://travis-ci.org/neumanrq/cmd_stan_rb)

Ruby interface to Stan, a library a for performing high performance statistical computations, i.e.
full Bayesian Inference.

<a href="https://mc-stan.org">
  <img src="https://raw.githubusercontent.com/stan-dev/logos/master/logo.png" width=200 alt="Stan Logo"/>
</a>


## Installation

    gem install cmd_stan_rb

## Installation for IRuby notebooks

    gem install cmd_stan_rb

… and then re-register your Ruby kernel by

    iruby register --force

## Before you can start…

This project makes use of [CmdStan](https://github.com/stan-dev/cmdstan) to compile models
with the Stan compiler and incorporating additional tooling from the Stan ecosystem. There
are battle-tested similar projects for other Programming languages are i.e.

  * [CmdStanPy](https://github.com/stan-dev/cmdstanpy)
  * [CmdStanR](https://github.com/stan-dev/cmdstanr)
  * [stannis](https://github.com/sakrejda/stannis])

Because of its dependency to `CmdStan`, you need to get `CmdStan` on board to
make `CmdStanRb` work. In the future I'd like to happen this automatically, but
for now you need to do this manually.

The easiest way is cloning the repository to a location of your choice:

    git clone https://github.com/stan-dev/cmdstan

Then, remember the path to that directory, as we need CmdStanRb to point
to that directory by setting a config variable

Sometimes you have to `cd` into your `cmdstan` directory and run

    git submodule update --init --recursive

## Usage

To see some examples with detailed context, you may want to consult [one of the example jupyter notebooks](https://github.com/neumanrq/cmd_stan_rb/tree/master/examples). I.e, [here's how one performs linear regression](https://github.com/neumanrq/cmd_stan_rb/blob/master/examples/linear_regression.ipynb) with CmdStandRb. If you like monkeys and pirates, check the [example of an A/B test by fitting models based on exponential distribution](https://github.com/neumanrq/cmd_stan_rb/blob/master/examples/exponential.ipynb).

```Ruby
# Tell CmdStanRb where your CmdStan repository is located.
# If you skip this step, the default value is "vendor/cmdstan"
CmdStanRb.configuration.cmdstan_dir = "~/path/to/cmdstan"

# Optional: Tell CmdStanRb where to store the models
CmdStanRb.configuration.model_dir = "/Users/robin/cmd_stan_rb-models"

# Prepare Stan compiler and assistent tooling
CmdStanRb.build_binaries

# Now we're ready to fit some models 👨‍🔬
# First, define your model. The first argument is a name,
# which is used to identify your model for re-use later.
model =
  Stan::Model.new("bernoulli-test") do
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

# Translate model
model.compile

# Specify data you've observed
model.data = {
  "N" => 4,
  "y" => [0,1,0,0]
}

# Run simulation to obtain samples from posterior distribution
result = model.fit

# Print result
puts model.show
```

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

### Diving deeper into the model output

The return value of `model.fit`, called `posterior` below, holds all (sampled) posterior distributions
for each parameter, like `theta`. For each parameter there is a method generated with the same name. The
method returns a Ruby Hash reflecting the sampled posterior distribution of that parameter.

<img width="1018" alt="Screenshot 2020-07-08 at 08 34 21" src="https://user-images.githubusercontent.com/3685123/86885606-d7e74580-c0f5-11ea-9586-975b90ea34dc.png">

### Loading previously compiled models

CmdStanRb stores models in a diretory you can define by

```Ruby
CmdStanRb.configuration.model_dir = "/Users/robin/cmd_stan_rb-models"
```

If you skip this, CmdStanRb will create a folder in your home directory named `cmd_stan_rb-models` and store
the model files and the compiled model binaries there.

Having compiled a model with name `my-model-01`, you can load it again by

```Ruby
model = Stan::Model.load("my-model-01")
```

Note that once loaded, the model's data has been wiped out, so `model.data` is blank and
needs to get set again to fit again.
