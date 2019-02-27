require 'spec_helper'
describe 'cloud' do
  context 'with default values for all parameters' do
    it { should contain_class('cloud') }
  end
end
