# Alexa Web Information Service

Ruby client for [AWIS](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)

## Installation

```
gem install alexa
```

## Usage

### Url Info

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
url_info = client.url_info(url: "site.com")

returns object with methods:
:rank, :data_url, :site_title, :site_description, :language_locale, :language_encoding,
:links_in_count, :keywords, :related_links, :speed_median_load_time, :speed_percentile,
:rank_by_country, :rank_by_city, :usage_statistics
```

NOTE: You can specify option `response_group: ["rank", "contact_info"]` or any other valid group.
See: [Docs](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)
Default response group takes all the available options.

### Sites Linking In

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
sites_linking_in = client.sites_linking_in(url: "site.com")

# returns object with `sites` method
```

NOTE: You can specify options:

* count (how many results to retrieve - default to max value 20)
* start (offset of results - default to 0)

### Traffic History

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
traffic_history = client.traffic_history(url: "site.com")

# returns object with `data` method
```

NOTE: You can specify options:

* range (how many days to retrieve - default to max value 31)
* start (start date - default to range days ago)

### Category Browse

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
category_browse = client.category_browse(path: "Top/Games/Card_Games")

# returns object with `categories`, `language_categories`, `related_categories`, `letter_bars` methods.
```

NOTE:

You can find valid paths on [dmoz](http://www.dmoz.org/) site

You can specify options:

* response_group (any of: categories, related_categories, language_categories, letter_bars)
* descriptions (include descriptions - boolean, true by default)

## Caveats

Alexa is using `multi_xml` to parse XML documents. Tested with:

* rexml
* nokogiri
* libxml

Currently alexa wont work with `ox` gem

## TODO

Support following:

* Category Listings

## Contributors

* [rmoriz](https://github.com/rmoriz)

## Continuous Integration

[![Build Status](https://secure.travis-ci.org/morgoth/alexa.png?branch=master)](http://travis-ci.org/morgoth/alexa)

## Copyright

Copyright (c) Wojciech Wnętrzak. See LICENSE for details.
