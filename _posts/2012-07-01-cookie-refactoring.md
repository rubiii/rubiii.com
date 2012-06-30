---
title: Cookie refactoring
layout: default
---

Cookie refactoring
------------------

<time datetime="2012-07-01">July 1, 2012</time>

I recently found [pelusa](https://github.com/codegram/pelusa) and decided to give it a try.
Pelusa is a static analysis tool that benefits from [Rubinius’](http://rubini.us) advanced support
for working with an abstract syntax tree. I ran pelusa against [Savon](https://github.com/rubiii/savon)
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

What I noticed is, that the code reads the “Set-Cookie” header from the response and sets the
“Cookie” header on the request. Both request and response are not part of Savon. They are
provided by [HTTPI](https://github.com/rubiii/httpi) which is a wrapper for various HTTP clients.

Also cookie handling sounds like something that should be handled by the HTTP library, so I
[removed the code from Savon](https://github.com/rubiii/savon/commit/92f15f) and cleaned up the
specs. Instead of calling `set_cookie`, Savon now simply passes the last response to a new
`set_cookies` method on the next request:

``` ruby
request.set_cookies(response)
```

I added the `set_cookies` method to the HTTPI request object and changed some receivers to
make it work in the new environment. Looking at the method again, you will notice that it
knows how to extract both the name and the “name and value” from a cookie String:

``` ruby
# use the cookie name as the key to the hash to allow for cookie updates and seperation
# set the value to name=value (for easy joining), stopping when we hit the Cookie options
@cookies[set_cookie.split('=').first] = set_cookie.split(';').first
```

The fact that there’s a comment to explain the code indicates that something’s wrong.
So I moved the code that operates on the cookie String to a Cookie object:

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

After changing the line of code, I was able to remove the comment because now you can
actually read it and understand what it does:

``` ruby
@cookies[cookie.name] = cookie.name_and_value
```

To get the cookie Strings, the method directly accesses the “Set-Cookie” header.
Now to use the new Cookie object instead of the Strings, I added a `cookies` method to
the response to return exactly what I need:

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
It’s all about responsibilities and asking yourself the question “why is this code here?”
until you’re [happy with the result](https://github.com/rubiii/httpi/commit/a9e449).


Ps. I slightly modified some examples for this context and the final commit contains
some additional refactorings.
