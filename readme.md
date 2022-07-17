## About

This repository contains bash scripts to switch between AWS IAM profiles and manage / assume roles in via the CLI using aliases (removing the need to remember long arns)

# Getting started

### Pre-reqs

jq - https://stedolan.github.io/jq/manual/

Installing MacOs
```shell
brew install jq
```

Installing on Ubuntu
```shell
sudo apt install jq
```
<br>

### Install using mkcommand (optional)

Clone the repository and cd into ```src``` directory

```shell
mkcommand switch.sh
mkcommand role.sh
```

<br>

### How to install mkcommand

Source code for mkcommand is here
```shell
https://github.com/jearle10/mkcommand
```

Helper script to install
```shell
curl -s https://raw.githubusercontent.com/jearle10/command/main/install.sh | bash
```

### Manual installation

There are two scripts located in the ```src``` folder of this repo 

```switch.sh```

```role.sh```

You can clone this repo and run the scripts the traditional way

```. ./switch <profile>```

```. ./role <username> <role_alias>```

NOTE: Both scripts need to be sourced as they modify shell env variables

<br>

If you want to be able to execute the scripts as commands from anywhere on your machine you will need to
- Add their location to your $PATH variable
- Make them executable (chmod +x)
- Create an alias in your ```.bashrc``` or ```.zshrc``` 

```
alias switch='source switch.sh
alias role='source role.sh'   
```

### Switching IAM profiles

e.g You have a IAM profile setup in your ``` ~/.aws/config```  that looks like the below

```shell
[default]
region = eu-west-1
output = json

[profile another_iam_user]
region = eu-west-1
output = json


[profile different_iam_user]
region = eu-west-1
output = json
```


To switch between each user you can use the switch script 

```shell
switch another_iam_user
```

Then commands issued with the aws cli will be made using "another_iam_user"

### Assuming roles

Create a roles.json file in your ```$HOME/bin``` directory and add the arns of any roles you want

The ```role.sh``` script allows you to manage a list of roles using a ```role.json``` file

```json
{
  "my_role": "arn:aws:iam::<ACCOUNT_NUMBER>:role/<ROLE_NAME>",
  "other_role": "arn:aws:iam::<ACCOUNT_NUMBER>:role/<ROLE_NAME>"
}
```

Then to assume a role via the cli. Use role aliases that are defined in config.json

```shell
role <username> my_role # Pass the aws username that should be used to assume the role and the role alias from config.json
```