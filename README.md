# Panda TikTok API Client

## Overview

panda-tiktok is a Ruby gem that provides a client for interacting with the TikTok Ads API. It simplifies making authenticated requests to retrieve advertiser details, campaigns, ad groups, and ads while handling errors gracefully.

## Features

- Authentication and request handling for the TikTok Ads API.
- Retrieve advertisers, campaigns, ad groups, and ads.
- Fetch advertising reports with specified dimensions.
- Handle API errors with custom exceptions.
- Configuration support for API keys and base URLs.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'panda-tiktok'
```
Then, run:
```sh
bundle install
```
Alternatively, install it manually using:
```sh
gem install panda-tiktok
```

## Configuration

To configure the client, use the Panda.configure block:
```ruby
require 'panda'

Panda.configure do |config|
  config.app_id = 'your_app_id'
  config.app_secret = 'your_app_secret'
  config.api_version = 'v1.3'
end
```

## Usage

### Creating a Client

To interact with the TikTok Ads API, initialize the client with an access token:
```ruby
client = Panda::Client.new('your_access_token')
```

### Retrieving Advertisers

Fetch the list of advertisers associated with the access token:
```ruby
advertisers = client.advertisers
```

### Fetching Advertiser Information

Retrieve details about specific advertisers:
```ruby
advertiser_info = client.advertiser_info(['advertiser_id_1', 'advertiser_id_2'])
```

### Retrieving Campaigns

Get all campaigns for an advertiser:
```ruby
campaigns = client.campaigns('advertiser_id')
```

### Retrieving Ad Groups

Fetch all ad groups for an advertiser:
```ruby
ad_groups = client.ad_groups('advertiser_id')
```

### Retrieving Ads

Get all ads for an advertiser:
```ruby
ads = client.ads('advertiser_id')
```

### Fetching Reports

Retrieve advertising performance reports with specified dimensions:
```ruby
report = client.report('advertiser_id', 'BASIC', ['campaign_id', 'adgroup_id'])
```

### Fetching User Information

Retrieve the user profile associated with the access token:
```ruby
user_info = client.user_info
```

### Validating Token

Validate the current access token:
```ruby
token_info = client.token_info
```

### Listing Apps

Retrieve the list of apps for an advertiser:
```ruby
apps = client.app_list('advertiser_id')
```

## Error Handling

The gem raises custom exceptions for different error responses from the API:
- `Panda::APIError`: Generic API error.
- `Panda::NoPermissionsError`: Raised when the user lacks the required permissions.
- `Panda::NotAuthorizedError`: Raised for authentication failures.
- `Panda::TooManyRequestsError`: Raised when rate limits are exceeded.

Example usage:
```ruby
begin
  campaigns = client.campaigns('advertiser_id')
rescue Panda::NotAuthorizedError => e
  puts "Authorization error: #{e.message}"
rescue Panda::APIError => e
  puts "API error: #{e.message}"
end
```

## Development

To contribute to the gem, clone the repository and install dependencies:
```sh
git clone https://github.com/revealbot/panda-tiktok.git
cd panda-tiktok
bundle install
```

Run tests:
```sh
bundle exec rspec
```

## License

This gem is licensed under the MIT License. See the LICENSE file for more details.
