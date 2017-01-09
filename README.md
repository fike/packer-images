# Packer Templates

**The templates here are used to build labs for research and just fun. :)**

The boxes are available at [https://atlas.harshicorp.com/fike](https://atlas.hashicorp.com/fike/) and Git repository is [packer-images](https://github.com/fike/packer-images) at Github.

## What're images there

* [Debian Sid]((https://raw.githubusercontent.com/fike/packer-images/master/sid/README.md)
* [Docker](https://raw.githubusercontent.com/fike/packer-images/master/docker/README.md)

## How to use that

It's quite simple, just create a Vagrantfile.  

	curl -LO https://raw.githubusercontent.com/fike/packer-images/master/docker/Vagrantfile; vagrant up
	vagrant init fike/sid; vagrant up

Some images might have a own **Vagrantfile** like Docker for support to test Swarm mode. Therefore, take look README into each image directory.

## Rebuild boxes

Basically, to customize or create you own box it's create or modify directory
with Packer JSON file. Scripts and Debian-Intstaller Preseeds are in the common
directories: *scripts*, *http*.

* **PackerDir** - Directory has Packer JSON file to build a Vagrant Box, create
another directory and customize the packer.son.

* **scripts** - To put shell scripts to install or modify behavior. This is a
common repository for reutilize to any box image creation.

* **http** - Repository for all [preseed](https://wiki.debian.org/DebianInstaller/Preseed)

## Manager Atlas box repository

### Configuration

Each packer image directory has a Atlas directory configuration to manage box images and metadata. Basically, it's yaml file and files to use Markdown editor.

* atlas.yml - metadata configuration to use for create, upload or delete box.

```
box:
  username: fike
  boxname: sid
  atlas_token:
  short_description: Debian Sid image for developing
  private: 0
  provider: virtualbox
  version: 20170103
```
* description_box.md - Description to use into Atlas box repository

* description_version.md - Description to use any change version

### Atlas Waiter

This is a Ruby script to manager metadata and box on Atlas. Requirements to run
is Ruby (tested 2.3 version).


```
vagrant@contrib-jessie:/vagrant$ ./atlaswaiter.rb
Usage: atlaswaiter.rb [options] PackerDir
    -c, --create PackerDir           Create Atlas Box Repository
    -d, --delete PackerDIr           Atlas box name to delete
    -m, --up-desc PackerDIr          Update the description of Atlas
    -s, --up-short-desc PackerDIr    Update the Short Description of Atlas Repository
    -u, --upload-box PackerDIr       Upload box to Atlas
    -h, --help
```

####

The atlaswaiter.rb

P.S.: Probably Atlas Waiter'll move for another its own repository if there is demand for more developing. ;)

Thanks [@gutocarvalho](https://twitter.com/gutocarvalho) for helped to do that. :)
