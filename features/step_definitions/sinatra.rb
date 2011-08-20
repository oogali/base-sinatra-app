Given /^I am viewing "(.+)"$/ do |url|
  visit url
end

Then /^I should see "(.*)"$/ do |text|
  page.has_content? text
end
