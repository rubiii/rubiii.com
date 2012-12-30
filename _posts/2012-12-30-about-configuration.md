---
title: About configuration
layout: post
---

About configuration
-------------------

{% excerpt %}
<time datetime="2012-12-30">December 30, 2012</time>

Prior to version 2, Savon featured a neat little method for configuring one-off options.

``` ruby
Savon.configure do |config|
  config.logger = Rails.logger
  config.raise_errors = false
end
```
{% endexcerpt %}

When I added this method [two years ago](https://github.com/savonrb/savon/commit/bb1543f056a4ce0022c751c59fafb261d166115e),
the goal was to move all class-level settings sprinkled throughout the library to a single location. I don't know for sure,
but it was probably inspired by [RSpec's configuration](https://github.com/rspec/rspec-core/blob/v2.12.2/lib/rspec/core/configuration.rb).

``` ruby
RSpec.configure do |config|
  config.mock_with :mocha
end
```

Following this "pattern" makes it really easy for users to quickly figure out how to configure any library,
which is probably the reason why it was adopted by quite a few popular gems.
But if you don't carefully choose which options to support, this will cause problems sooner or later.


### Global state

The problem of course is global state. It's the reason why it was not possible to configure Savon to use a
[logger per SOAP service](https://github.com/savonrb/savon/issues/84) and to
[connect to two elasticsearch clusters](https://github.com/karmi/tire/issues/318) when using Tire (sorry Karel).

So even though it might be convenient to slap a `.configure` method on a Class or Module, please think twice
about whether your options are safe to be used globally. From my experience, it's almost always better to
just pass those options to some object's initializer. Don't even get me started on threading.

Hindsight is 20/20. Happy new year :)
