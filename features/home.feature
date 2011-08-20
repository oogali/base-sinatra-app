Feature: Home page
  In order to ensure our base Sinatra configuration is working
  I should see the index page of our project
  
  Scenario: Go to the home page
    Given I am viewing "/"
    Then I should see "hello world"
