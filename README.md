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

## Credits

Extracted from the [ruby-build][] test suite. Many thanks to its author and contributors: [Sam Stephenson][sstephenson] and [Mislav Marohnić][mislav].

[ruby-build]: https://github.com/sstephenson/ruby-build
[sstephenson]: https://github.com/sstephenson
[mislav]: https://github.com/mislav
