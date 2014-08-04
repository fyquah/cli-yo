# Introduction

A ruby gem, which allows you to yo! your friends from the command line automatically.
And if you want to, you can always include it in your code.

## Support
* Should work fine on all Unix based operating systems with Ruby installed

## Installing
* Install the gem with `gem install cli_yo`
* Get the Yo API Token from the Yo's developers page 
* Update the file in $HOME/.bashrc with the following line:
`export YO_TOKEN="<YO-API-TOKEN>"`
* You are good to go!

## Optional Configuration
* in case you prefer typing yo .. than cli-yo .. , add the following line to your ~/.bashrc
```bash
function yo {
	cli-yo $@
}
```
* Then , run the following command in your terminal `source ~/.bashrc`
* use yo instead of cli-yo!

## Usage
### Format:
```
cli-yo <usernames> [options]
```
### Yo your friend
```bash
cli-yo my_good_friend
```

### Tired of messages in the terminal?
```bash
cli-yo my_good_friend --silent
```

### Want to annoy someone continously every minute?
```bash
cli-yo my_good_friend --times 10
```

### Perhaps every minute is a little too bad
```bash
cli-yo my_good_friend --times 10 --interval 3
```

### Want to use another api token to yo! ?
```bash
cli-yo my_good_friend --api_token <some_other_token>
```

## Who says you can yo only one person at a time ?
```bash
cli-yo bill john adam 
```

### Want to get yo!-ed when someone visits your site?
Add the following lines to your site's server side source:
```ruby
# Inside part of your code that gets trigger whenever someone visits the site
require "cli_yo"
Cli_Yo.yo! {usernames: [your_user_name , your_other_user_name] , api_token: your_api_token}
# Next part of your code
```

## Command Line Options
`-s, --silent `
silently yo your friend while you proceed with your work! You won't be disturbed even in the terminal!

`-t COUNT, --times COUNT`
how many times do you want to yo! your friend, defaults to 1

`-i INTERVAL, --interval INTERVAL `
how often do you want to yo! your friend (in minutes) , defaults to 1

`-a TOKEN, --api_token TOKEN`
Write your api_token (or add it inside .bashrc file [refer above])

`-h, --help`
Show this message

`-v, --version`
Print the name and version

## Arguments for Cli_Yo.yo! method

```ruby
require "cli_yo" #loads the Cli_Yo module
Cli_Yo.yo!(arguments_hash)
```

* `silent` boolean true or false/nil to indicate whether the process runs in the background
* `times` integer specifying the number of times
* `interval` Fixed Number specifying the interval between each Yo-es (in minutes)!
* `api_token` String specifying the API token. defaults to `echo $YO_TOKEN`
* `usernames` array containing the usernames of the users you wish to yo!

# Licence
MIT