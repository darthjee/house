Bidu House
==========

This gem tries to make server monitoring easier and more reliable by adding an easly configurable
report and making it avaliable in a controller

Getting started
---------------
1. Add JsonParser to your `Gemfile` and `bundle install`:

    ```ruby
    gem 'json_parser'
    ```


2. Include in your health check controller passing the configuration to fetch your Documents
with error and render the report

  ```ruby
  class HealthCheckController < ApplicationController
    include Bidu::House

    status_report :failures, clazz: Document
    status_report :failures, clazz: Schedules, on: :schedules
    status_report :delays, clazz: Schedules, scope: :late, on: :schedules

    def status
      render_status
    end

    def late_status
      render_status(:schedules)
    end
  end
  ```

3. Add a route to your controller

  ```ruby
  scope path: 'health-check', controller: :health_check do
    get '/status' => :status
    get '/late-status' => :late_status
  end
  ```

3. Set the correct options on your status report to achieve a perfect report
- clazz: Class of the object that might contain error
- scope: scope to be fetched when trying to find objects with error (default: :with_error)
- external_key: column to be exposed as id for the objects with error
- threshold: default report threshold (default: 0.02)
- period: default search period (default: 1 day)
- on: report bucket (default: :default)

4. Run the server and hit the health-check routes

 ```
 wget http://localhost:3000/health-check/status
 wget http://localhost:3000/health-check/late-status
 ```

5. Customize your request for multiple reports
 ```
 wget http://localhost:3000/health-check/status?period=3.days&threshold=0.005
 wget http://localhost:3000/health-check/late-status?period=1.hours&threshold=0.1
 ```
