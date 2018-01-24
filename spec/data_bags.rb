# Right now the data bags are picked up from the chef_repo/data_bags path which is configured in the knife.rb file.
# In the future, to maintain independence of the unit tests from our global data bags, the tests should pick up
# the data bag values from the test/fixtures/data_bags path using the code below.
def environment
  'dev'
end

def data_bag_base
  "test/fixtures/data_bags/kitchen"
end
