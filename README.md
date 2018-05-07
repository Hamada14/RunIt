# RunIt
RunIt is an event-driven, serverless computing platform. It is a compute service that runs code in response to events and automatically manages the compute resources required by that code. It's also responsible for sand-boxing the running code.

## Building the DB
Use the below commands to migrate the DB schema.
```
bundler exec rake db:create
bundler exec rake db:migrate
```
## Running the Application:
Currently running the application is only using `rackup -p #{PORT}`, remember to use the required port.
To access the server use https://0.0.0.0:3000

In case of running the application in development mode, to avoid the need of restarting the server to reload changes `Shotgun` was added.
Launch the server using `bundle exec shotgun config.ru`
