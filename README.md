# bats-mock
Mocking/stubbing library for BATS (Bash Automated Testing System)


## Installation

Recommended installation is via git submodule. Assuming your project's bats
tests are in `test`:

``` sh
git submodule add https://github.com/jasonkarns/bats-mock test/helpers/mocks
git commit -am 'added bats-mock module'
```

then in `test/test_helper.bash`:

``` bash
load helpers/mocks/stub
```

(Optionally configure sparse-checkout if you're concerned with all the non-essential files being in your repo)

Also available as an [npm module](https://www.npmjs.com/package/bats-mock) if you're into that sort of thing.

``` sh
npm install --save-dev bats-mock
```

then in `test/test_helper.bash`:

``` bash
load ../node_modules/bats-mock/stub
```

## Usage

After loading `bats-mock/stub` you have two new functions defined:

- `stub`: for creating new stubs, along with a plan with expected args and the results to return when called.

- `unstub`: for cleaning up, and also verifying that the plan was fullfilled.


### Stubbing

The `stub` function takes a program name as its first argument, and any remaining arguments goes into the stub plan, one line per arg.

Each plan line represents an expected invocation, with a list of expected arguments followed by a command to execute in case the arguments matched, separated with a colon:

    arg1 arg2 ... : only_run if args matched

The expected args (and the colon) is optional.

So, in order to stub `date`, we could use something like this in a test case (where `get_timestamp` is the function under test, relying on data from the `date` command):

    @test "get_timestamp" {
      stub date \
          "${_DATE_ARGS} : echo 1460967598.184561556" \
          "${_DATE_ARGS} : echo 1460967598.084561556" \
          "${_DATE_ARGS} : echo 1460967598.004561556" \
          "${_DATE_ARGS} : echo 1460967598.000561556" \
          "${_DATE_ARGS} : echo 1460967598.000061556"

      run get_timestamp
      assert_success
      assert_output 1460967598184

      run get_timestamp
      assert_success
      assert_output 1460967598084

      run get_timestamp
      assert_success
      assert_output 1460967598004

      run get_timestamp
      assert_success
      assert_output 1460967598000

      run get_timestamp
      assert_success
      assert_output 1460967598000

      unstub date
    }


This verifies that `get_timestamp` indeed called `date` using the args defined in `${_DATE_ARGS}`, and made proper use of the output of it.

The plan is verified, one by one, as the calls come in, but the final check that there are no remaining un-met plans at the end is left until the stub is removed with `unstub`.

Here, we used the `assert_success` and `assert_output` functions from [bats-assert][], but any check you use in your `bats` tests are fine to use.


### Unstubbing

Once the test case is done, you should call `unstub <program>` in order to clean up the temporary files, and make a final check that all the plans have been met for the stub.


## How it works

(You may want to know this, if you get weird results there may be stray files lingering about messing with your state.)

Under the covers, `bats-mock` uses three scripts to manage the stubbed programs/functions.

First, it is the command (or program) itself, which when the stub is created is placed in (or rather, the `binstub` script is sym-linked to) `${BATS_MOCK_BINDIR}/${program}` (which is added to your `PATH` when loading the stub library). Secondly, it creates a stub plan, based on the arguments passed when creating the stub, and finally, during execution, the command invocations are tracked in a stub run file which is checked once the command is `unstub`'ed. The `${program}-stub-[plan|run]` files are both in `${BATS_MOCK_TMPDIR}`.


### Caveat

If you stub functions, make sure to unset them, or the stub script wan't be called, as the function will shadow the binstub script on the `PATH`.


## Credits

Extracted from the [ruby-build][] test suite. Many thanks to its author and contributors: [Sam Stephenson][sstephenson] and [Mislav Marohnić][mislav].

[ruby-build]: https://github.com/sstephenson/ruby-build
[sstephenson]: https://github.com/sstephenson
[mislav]: https://github.com/mislav
[bats-assert]: https://github.com/ztombol/bats-assert
