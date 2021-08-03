# Log Parser
A simple log parser written in ruby that summarises the server log in terminal

## Installation
- Go to the project directory
  - Install Ruby `3.0.2` and latest `bundler` gem by either `rbenv` or by `rvm` 
  - Hit command `bundle install`
  - You might want to change the `ruby` path if you do not have system level `ruby` install, in that case, from terminal
    - You have to hit `which ruby` from terminal and then copy the path and then replace the pat mentioned in the first line of `parser.rb`  

## Running the application
- From application root directory
  - Run command `./parser.rb <log_path>`

You should see an output like below<img width="1786" alt="Screenshot 2021-08-04 at 2 28 43 AM" src="https://user-images.githubusercontent.com/6723284/128085294-ffbacef6-ab7c-46c2-af21-c1c8ee273163.png">

## Testing the application
- From application root directory
  - Run command `bundle exec rspec`
- The above command will create a directry named `coverage` in the aplication folder with an `index.html` file in it
- Open the generated `index.html` file in browser and you should see an output like below

<img width="1791" alt="Screenshot 2021-08-04 at 2 32 08 AM" src="https://user-images.githubusercontent.com/6723284/128085747-508582b7-c8c8-4759-b47b-a843b7b80d95.png">

# Limitation
- This application is tested for log format which is available at `resources` directory. Any other log format might break the application. Generic `Exception` handler was not placed because that would defeat the purpose of this application.
