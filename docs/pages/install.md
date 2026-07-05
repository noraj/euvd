# Installation

## Production

<!-- tabs:start -->

### **rubygems.org (universal)**

**Personal** (need `"$(gem env user_gemhome)/bin"` or `"$(ruby -e 'puts Gem.user_dir')/bin"` loaded in `$PATH` (can be done with `$(ruby -e 'puts Gem.user_dir')/bin"` in shell rc config file), ex: `/home/noraj/.gem/ruby/3.4.0/bin`)

```bash
gem install --user euvd
# or
gem install --user-install euvd
```

**Global** (probably need high privileges unless inside a virtual environment like [ASDM-VM](https://asdf-vm.com/))

```bash
gem install euvd
```

Gem: [euvd](https://rubygems.org/gems/euvd)

<!-- tabs:end -->

## Development

It's better to use [ASDM-VM](https://asdf-vm.com/) to have latests version of ruby and to avoid trashing your system ruby.

<!-- tabs:start -->

### **rubygems.org**

```bash
gem install --development euvd
```

### **git**

Just replace `x.x.x` with the gem version you see after `gem build`.

```bash
git clone https://github.com//euvd.git euvd
cd euvd
gem install bundler
bundler install
gem build euvd.gemspec
gem install euvd-x.x.x.gem
```

Note: if an automatic installation is needed you can get the version with `$ gem build euvd.gemspec | grep Version | cut -d' ' -f4`.

### **No install**

Run the library in irb without installing the gem.

From local file:

```bash
irb -Ilib -reuvd
```

<!-- tabs:end -->
