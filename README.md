# bats-mock

Mocking/stubbing library for [BATS (Bash Automated Testing System)][bats-core]

## Installation

### git

The recommended installation is with git-subtree.
Assuming your project's bats tests are in `test/`:

```console
# v1 can be any valid ref (tag, branch, commit) of the bats-mock repo
git subtree add --prefix test/helpers/bats-mock https://github.com/jasonkarns/bats-mock v1 --squash

# pull a future bats-mock release (say, v2) with:
# git subtree pull --prefix test/helpers/bats-mock https://github.com/jasonkarns/bats-mock v2 --squash

# bats-mock keeps a "major version" tag pinned to the highest corresponding tag
```

then in `test/test_helper.bash`:

```bats
load helpers/bats-mock/stub
```

### npm

Also available as an [npm module](https://www.npmjs.com/package/bats-mock)
if you're into that sort of thing.

```console
npm install --save-dev bats-mock
```

then in `test/test_helper.bash`:

```bats
load ../node_modules/bats-mock/stub
```

## Usage

After loading `bats-mock/stub` you have two new functions defined:

- `stub`: for creating new stubs,
  along with a plan with expected args and the results to return when called.
- `unstub`: for cleaning up, and also verifying that the plan was fullfilled.

### Stubbing

The `stub` function takes a program name as its first argument;
any remaining arguments go into the stub plan.

Each plan line represents an expected invocation:
a list of expected arguments followed by the command to execute,
separated with a colon.

```text
arg1 arg2 ... : only_run if args matched
```

The expected args (and the colon) is optional.

So, in order to stub `date`,
we could use something like this in a test case
(where `format_date` is the function under test,
relying on data from the `date` command):

```bats
load helper

# this is the "code under test"
# it would normally be in another file
format_date() {
  date -r 222
}

setup() {
  _DATE_ARGS='-r 222'
  stub date \
      "${_DATE_ARGS} : echo 'I am stubbed!'" \
      "${_DATE_ARGS} : echo 'Wed Dec 31 18:03:42 CST 1969'"
}

teardown() {
  unstub date
}

@test "date format util formats date with expected arguments" {
  result="$(format_date)"
  [ "$result" == 'I am stubbed!' ]

  result="$(format_date)"
  [ "$result" == 'Wed Dec 31 18:03:42 CST 1969' ]
}
```

This verifies that `format_date` indeed called `date`
using the args defined in `${_DATE_ARGS}`
(which can not be declared in the test-case with local),
and made proper use of the output of it.

The plan is verified, one by one, as the calls come in.
Finally, when the stub is removed with `unstub`,
there is a final check to ensure there are no remaining un-met plans
(which would indicated an expected invocation that did not occur).

### Unstubbing

Once the test case is done,
you should call `unstub <program>` in order to clean up the temporary files,
and make a final check that all the plans have been met for the stub.

## How it works

Under the covers, `bats-mock` uses three scripts to manage the stubbed programs/functions.

First, it is the command (or program) itself,
which when the stub is created is placed in
(or rather, the `binstub` script is sym-linked to)
`${BATS_MOCK_BINDIR}/${program}`
(which is added to your `PATH` when loading the stub library).
Secondly, it creates a stub plan,
based on the arguments passed when creating the stub.
And finally, during execution, the command invocations are
tracked in a stub run file which is checked once the command is `unstub`'ed.
The `${program}-stub-[plan|run]` files are both in `${BATS_MOCK_TMPDIR}`.

### Caveat

If you stub functions, make sure to unset them,
or the stub script wan't be called,
as the function will shadow the binstub script on the `PATH`.

## Credits

Extracted from the [ruby-build][] test suite.
Many thanks to its author and contributors:
[Sam Stephenson][sstephenson] and [Mislav Marohnić][mislav].

[ruby-build]: https://github.com/sstephenson/ruby-build
[sstephenson]: https://github.com/sstephenson
[mislav]: https://github.com/mislav
[bats-core]: https://github.com/bats-core
