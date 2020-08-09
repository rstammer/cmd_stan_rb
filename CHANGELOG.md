### Head (Not released yet)
#### v0.4.0
* Support for more cmdstan sample command line arguments. That is, `Stan::Model#fit` now
supports the following (optional) keyword arguments:
  * `warmup` - an integer specifying how many samples should used for an initial warm up phase
  * `samples` - integer number specifying how many samples should get generated at all
  * `save_warmup` - boolean value (defaults to `false` that specifies if warmup samples should get streamed to output, too
  * `thin` - integer value that states the period between saved samples. Must be greater than 0. Defaults to 1.
### v0.3.0
* Added simple output capturing Ruby object (`Stan::FitResult`) which offers
access to posterior distributions of the model parameters

### v0.2.0

* Renaming to CmdStanRb (See #5)

### v0.1.1

* Make model storage location configurable (#2)
* Make loading previously compiled models work

### v0.1.0

* Initial Version

