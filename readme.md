# BNNVARA CLI Tool

---

## Commands

### bnnvara config
#### Setup
```shell
bnnvara config setup
```
Setup command for this tool.

Wil ask you where your main project folder starting from your home directory.

Only run once unless you append the `--force` flag like:
```shell
bnnvara config setup --force
```

#### Read
```shell
bnnvara config read
```
List all setting stored in config file

#### Check
```shell
bnnvara config check
```
Check if setup is been called and checks if it can find the external cli executables.
