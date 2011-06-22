# Alexa Web Information Service #

## Installation ##

```
  gem install alexa
```

## Usage ##

``` ruby
  Alexa.url_info(:access_key_id => "key", :secret_access_key => "secret", :host => "site.com")

  returns object with methods:
  :xml_response, :rank, :data_url, :site_title, :site_description, :language_locale, :language_encoding,
  :links_in_count, :keywords, :related_links, :speed_median_load_time, :speed_percentile,
  :rank_by_country, :rank_by_city, :usage_statistics
```

NOTE: You can specify option `:response_group => "Rank,ContactInfo"` or any other valid group.
See: [Docs](http://docs.amazonwebservices.com/AlexaWebInfoService/latest/)
Default response group takes all the available options.

You can set configuration in block like this:

``` ruby
  Alexa.config do |c|
    c.access_key_id = "key"
    c.secret_access_key = "secret"
  end
```

## Contributors ##

* [rmoriz](https://github.com/rmoriz)

## Copyright ##

Copyright (c) 2011 Wojciech Wnętrzak. See LICENSE for details.
