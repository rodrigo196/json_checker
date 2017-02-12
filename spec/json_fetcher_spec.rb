require "spec_helper"
require "json_checker/json_fetcher"

RSpec.describe JsonChecker::JSONFetcher do

  it "return nil for a invalid path" do
  	json = JsonChecker::JSONFetcher.json_from_path("/invalid.json")
    expect(json).to be nil
  end

  it "return nil for a nil path" do
  	json = JsonChecker::JSONFetcher.json_from_path(nil)
    expect(json).to be nil
  end

  it "return nil for a integer path" do
    json = JsonChecker::JSONFetcher.json_from_path(1)
    expect(json).to be nil
  end

  it "return nil for a array path" do
    json = JsonChecker::JSONFetcher.json_from_path([1, 2])
    expect(json).to be nil
  end

  it "return nil for a nil url" do
  	json = JsonChecker::JSONFetcher.json_from_url(nil)
    expect(json).to be nil
  end

  it "return nil for a invalid url" do
  	json = JsonChecker::JSONFetcher.json_from_url("invalid url")
    expect(json).to be nil
  end

  it "return nil for a integer" do
    json = JsonChecker::JSONFetcher.json_from_url(1)
    expect(json).to be nil
  end

  it "return nil for a array" do
    json = JsonChecker::JSONFetcher.json_from_url([1, 2])
    expect(json).to be nil
  end

  it "return nil for a invalid json" do
  	json = JsonChecker::JSONFetcher.json_from_content("{invalid json}")
    expect(json).to be nil
  end

  it "return nil for a json nil" do
  	json = JsonChecker::JSONFetcher.json_from_content(nil)
    expect(json).to be nil
  end

  it "return nil for a array" do
    json = JsonChecker::JSONFetcher.json_from_content([1, 2])
    expect(json).to be nil
  end

  it "return nil for a integer" do
    json = JsonChecker::JSONFetcher.json_from_content(2)
    expect(json).to be nil
  end

  it "return nil for a boolean" do
    json = JsonChecker::JSONFetcher.json_from_content(true)
    expect(json).to be nil
  end

  it "return json for a valid path" do
    json = JsonChecker::JSONFetcher.json_from_path("json-config.json")
    expect(json).not_to be nil
  end

  it "return json for a valid json" do
  	json = JsonChecker::JSONFetcher.json_from_content("{\"name\":\"test\"}")
    expect(json).not_to be nil
  end
end