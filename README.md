# tfenv deb and rpm package builder

To build the packages you will need docker installed.

```sh
make docker_build
```

## Notes on usage

Since tfenv is installing terraform versions into /usr/lib/tfenv, it needs
root permissions to install new terraform versions.

So installing a new version requires sudo permissions.
Using a new version does not.

```sh
sudo tfenv install 0.12.28
```

For this to change tfenv needs to be changed so the directory it stores
downloaded versions in is under the users own home directory and not a system
directory.
