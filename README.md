# Alexa Web Information Service

Ruby client for [AWIS](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)

## Installation

```
gem install alexa
```

## Usage

``` ruby
client = Alexa::Client.new(access_key_id: "key", secret_access_key: "secret")
url_info = client.url_info(host: "site.com")

returns object with methods:
:rank, :data_url, :site_title, :site_description, :language_locale, :language_encoding,
:links_in_count, :keywords, :related_links, :speed_median_load_time, :speed_percentile,
:rank_by_country, :rank_by_city, :usage_statistics
```

NOTE: You can specify option `response_group: "Rank,ContactInfo"` or any other valid group.
See: [Docs](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)
Default response group takes all the available options.

alexa is using `multi_xml` to parse XML documents. Tested with:

* rexml
* nokogiri
* libxml

Currently alexa wont work with `ox` gem

## TODO

Support following:

* Traffic History
* Category Browse
* Category Listings
* Sites Linking In

## Contributors

* [rmoriz](https://github.com/rmoriz)

## Continuous Integration
[![Build Status](https://secure.travis-ci.org/morgoth/alexa.png)](http://travis-ci.org/morgoth/alexa)

## Copyright

Copyright (c) Wojciech Wnętrzak. See LICENSE for details.
