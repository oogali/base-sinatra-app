require 'spec_helper'

describe 'User can get the home page' do
  it 'Should get an OK when requesting /' do
    get '/'
    last_response.status.should == 200
  end
end
