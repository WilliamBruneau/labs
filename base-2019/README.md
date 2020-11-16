Base lab
=

This lab contains:
* DC: Windows 2019 server, DC of a domain "windomain.local"
* SRV: Windows 2019 server, joined to the domain
* Client: Windows 10 client, joined to the domain

This lab does not need an Internet connection (once the box have been retrieved).

Setup
-

The DC must be created before the others:
```
$ vagrant up dc2019 --provision
```

The SRV and the Client can be created in parralell:
```
$ vagrant up srv2019 client --provision
```

Usage
-

The user `windomain.local\vagrant:vagrant` is able to RDP.
For instance, one can log-in on the Client, then `mstsc` on `srv2019`, with the `vagrant` account.
