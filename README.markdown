# Usage Guide

## Installing
* Install the gem with `gem install cli_yo`
* Get the Yo API Token from the Yo's developers page 
* Update the file in $HOME/.bashrc with the following line:
`export YO_TOKEN="<YO-API-TOKEN>"`
* You are good to go!

## Usage
### Yo your friend
`cli-yo my_good_friend`

### Tired of messages in the terminal?
`cli-yo my_good_friend --silent` or `cli-yo my_good_friend -s`

### Want to annoy someone continously every minute?
`cli-yo my_good_friend --times 10`

### Perhaps every minute is a little too bad
`cli-yo my_good_friend --times 10 --interval 3`

### Want to use another api token to yo! ?
`cli-yo my_good_friend --api_token <some_other_token> `