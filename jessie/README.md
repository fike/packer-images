# Docker on Vagrant image

Why to create a Docker Vagrant image if Docker Machine does the same thing?

Right! Docker Machine is awesome project and it really cool for firsts test to
study Docker Engine and Swarm Mode. But, I made this to test in the scenario
more closer to real production. So, I hope you enjoy it.

## How to use it?

Here is a Vagrantfile that you might use as reference or example, this Vagrantfile
is support to play Docker Engine, Compose and Swarm Mode.

```
curl -LO https://raw.githubusercontent.com/fike/packer-images/master/docker/Vagrantfile
vagrant up
```

It has a variable that you up N virtual machine. For example: Up 4 servers,
just change VM variable to **4**.

```
VM=4

```
### What're IP to communicate among Docker servers?

The first server has its IP **192.168.40.11**, the second has IP
**192.168.40.11** and etc.
