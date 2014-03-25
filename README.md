# Alexa Web Information Service

Ruby client for [AWIS](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)

## Installation

```
gem install alexa
```

## Usage

All success response objects contain `response_id` method.

### Url Info

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
url_info = client.url_info(url: "site.com")
```

Returns object that contains methods:

* rank
* data_url
* site_title
* site_description
* language_locale
* language_encoding
* links_in_count
* keywords
* related_links
* speed_median_load_time
* speed_percentile
* rank_by_country
* rank_by_city
* usage_statistics
* categories

You can specify options:

* url - address to be measured
* response_group - which data to include in response (i.e. ["rank", "contact_info"]) - defaults to all available

See: [Docs](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/) for valid groups.

### Sites Linking In

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
sites_linking_in = client.sites_linking_in(url: "site.com")
```

Returns object that contains method:

* sites

You can specify options:

* url - address to be measured
* count - how many results to retrieve - defaults to max value that is 20
* start - offset of results - defaults to 0

### Traffic History

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
traffic_history = client.traffic_history(url: "site.com")
```

Returns object that contains methods:

* site
* range
* start
* data

You can specify options:

* url - address to be measured
* range - how many days to retrieve - defaults to max value 31
* start - start date (i.e. "20120120", 4.days.ago) - defaults to range number days ago

### Category Browse

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
category_browse = client.category_browse(path: "Top/Games/Card_Games")
```

Returns object that contains methods:

* categories
* language_categories
* related_categories
* letter_bars

You can specify options:

* path - category to be measured (i.e. "Top/Games/Card_Games") - valid paths can be found on [dmoz](http://www.dmoz.org/)
* response_group - any of: categories, related_categories, language_categories, letter_bars - defaults to all
* descriptions - should response include descriptions (i.e. false) - defaults to true

### Category Listings

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
category_listings = client.category_listings(path: "Top/Games/Card_Games")
```

Returns object that contains methods:

* count
* recursive_count
* listings

You can specify options:

* path - category to be measured (i.e. "Top/Games/Card_Games") - valid paths can be found on [dmoz](http://www.dmoz.org/)
* sort_by - sort results by one of: popularity, title, average_review - defaults to popularity
* recursive - should result include subcategories (i.e. false)- defaults to true
* count - how many results to retrieve - defaults to max value, that is 20
* start - offset of results - defaults to 0
* descriptions - should response include descriptions (i.e. false) - defaults to true

## Caveats

### Status Code

You can retrieve Alexa status code calling `status_code` method.

It happens (so far in TrafficHistory) that Alexa returns response `200` with `AlexaError` status.

### Parsers

Alexa is using `multi_xml` to parse XML documents. Tested with:

* rexml
* nokogiri
* libxml

Currently alexa will not work with `ox` gem

## Contributors

* [rmoriz](https://github.com/rmoriz)
* [jasongill](https://github.com/jasongill)
* [sporkmonger](https://github.com/sporkmonger)
* [pelf](https://github.com/pelf)
* [tyler-smith](https://github.com/tyler-smith)

## Continuous Integration

[![Build Status](https://travis-ci.org/morgoth/alexa.svg?branch=master)](https://travis-ci.org/morgoth/alexa)

## Copyright

Copyright (c) Wojciech Wnętrzak. See LICENSE for details.
