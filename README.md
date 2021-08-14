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

You should see an output like below
<img width="1792" alt="Screenshot 2021-08-15 at 1 22 59 AM" src="https://user-images.githubusercontent.com/6723284/129458664-7e8e6879-b0c2-4905-88bc-eb4e3c55bacf.png">


## Testing the application
- From application root directory
  - Run command `bundle exec rspec`
- The above command will create a directry named `coverage` in the aplication folder with an `index.html` file in it
- Open the generated `index.html` file in browser and you should see an output like below

<img width="1792" alt="Screenshot 2021-08-15 at 1 24 25 AM" src="https://user-images.githubusercontent.com/6723284/129458687-ed950b62-860c-44fb-b054-4f61527fceae.png">


# Limitation
- This application is tested for log format which is available at `resources` directory. Any other log format might break the application. Generic `Exception` handler was not placed because that would defeat the purpose of this application.
