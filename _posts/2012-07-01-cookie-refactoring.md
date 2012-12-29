---
title: Cookie refactoring
layout: default
---

Cookie refactoring
------------------

<time datetime="2012-07-01">July 1, 2012</time>

I recently found [pelusa](https://github.com/codegram/pelusa) and decided to give it a try.
Pelusa is a static analysis tool that benefits from [Rubinius’](http://rubini.us) advanced support
for working with an abstract syntax tree. I ran pelusa against [Savon](https://github.com/savonrb/savon)
and decided to look into one of the problems from the report:

> lib/savon/client.rb:  
> Doesn’t use more than one indentation level inside methods  
> &nbsp; &nbsp; There’s too much indentation in lines 111.

The code it complained about persists cookies and adds them to the next request:

``` ruby
def set_cookie(headers)
  if headers['Set-Cookie']
    @cookies ||= {}
    # handle single or multiple Set-Cookie Headers as returned by Rack::Utils::HeaderHash in HTTPI
    set_cookies = [headers['Set-Cookie']].flatten
    set_cookies.each do |set_cookie|
      # use the cookie name as the key to the hash to allow for cookie updates and seperation
      # set the value to name=value (for easy joining), stopping when we hit the Cookie options
      @cookies[set_cookie.split('=').first] = set_cookie.split(';').first
    end

    request.headers['Cookie'] = @cookies.values.join(';')
  end
end
```

The method is called after every SOAP request and it receives the HTTP response headers:

``` ruby
set_cookie(response.headers)
```

### Why does Savon know about cookies?

Savon reads the “Set-Cookie” header from the response and sets the “Cookie” header on the request.
But both request and response are not part of Savon. They are provided by [HTTPI](https://github.com/savonrb/httpi)
which is a wrapper for various HTTP clients.

And cookie handling sounds like something that should be handled by the HTTP layer. So I
[removed the code from Savon](https://github.com/savonrb/savon/commit/92f15f) and cleaned up the
specs. Instead of working with cookies, Savon now simply passes the last response to a new
method on the request:

``` ruby
request.set_cookies(response)
```

I added the method to the HTTPI request object and changed some receivers to make it work in
the new environment. 

### Why does the method know how to read a cookie?

Looking at the method again, you will notice that it knows how to extract both the name and
the “name and value” from a cookie String:

``` ruby
# use the cookie name as the key to the hash to allow for cookie updates and seperation
# set the value to name=value (for easy joining), stopping when we hit the Cookie options
@cookies[set_cookie.split('=').first] = set_cookie.split(';').first
```

The fact that there’s a comment to explain what this code does indicates that something’s
wrong. So I moved the code that operates on the cookie String to a Cookie object:

``` ruby
class Cookie

  def initialize(cookie)
    @cookie = cookie
  end

  def name
    @cookie.split('=').first
  end

  def name_and_value
    @cookie.split(';').first
  end

end
```

After changing the line of code, I removed the comment because now you can actually
understand what it does:

``` ruby
@cookies[cookie.name] = cookie.name_and_value
```

### Why does the code ask the response for its headers?

To get the cookie Strings, the method accesses the “Set-Cookie” header through the
response object which looks like a [Law of Demeter](http://www.clean-code-developer.de/Law-of-Demeter.ashx)
violation. What I needed was a method that returns a list of Cookie objects and
adding a `cookies` method to the response solved this issue:

``` ruby
def cookies
  Array(headers['Set-Cookie']).map { |cookie| Cookie.new(cookie) }
end
```

After these changes, here’s what the new `set_cookies` method looks like:

``` ruby
def set_cookies(http_response)
  @cookies ||= {}

  http_response.cookies.each do |cookie|
    @cookies[cookie.name] = cookie.name_and_value
  end

  headers['Cookie'] = @cookies.values.join(';')
end
```

The reason for me to share this refactoring story, is that it was a great lesson for me.
It’s all about responsibilities. Question your code and you will eventually be
[happy with the result](https://github.com/savonrb/httpi/commit/a9e449).


Ps. I slightly modified some examples for this context and the final commit contains
some additional refactorings.
