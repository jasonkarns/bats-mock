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

### sparse-checkout
That is all that's necessary to get the stub helpers into your project. However, as a submodule, it pulls in this entire repo. If you'd like only the minimum necessary files, you'll need to configure the submodule for sparse-checkout.

Enable sparse-checkout *from the submodule directory*:

``` sh
cd test/helpers/mocks
git config core.sparsecheckout true
```

Then configure explictly list the files you wish to have checked out. From the root of your project:

``` sh
echo stub.bash >> .git/modules/test/helpers/mocks/info/sparse-checkout
echo binstub >> .git/modules/test/helpers/mocks/info/sparse-checkout
```


## Credits

Extracted from the [ruby-build][] test suite. Many thanks to its author and contributors: [Sam Stephenson][sstephenson] and [Mislav Marohnić][mislav].

[ruby-build]: https://github.com/sstephenson/ruby-build
[sstephenson]: https://github.com/sstephenson
[mislav]: https://github.com/mislav
