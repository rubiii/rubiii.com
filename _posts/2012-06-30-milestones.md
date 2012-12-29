---
title: Milestones
layout: post
---

Milestones
----------

{% excerpt %}
<time datetime="2012-06-30">June 30, 2012</time>

The recent release of Savon version 1.0 was quite a big milestone for me. Savon was
born [3 years ago](https://github.com/savonrb/savon/commit/d9d471) on July 2, 2009 and
I'm more than happy that people are actually using it. The library was born out of my
need to talk to services in a service oriented architecture and it started with a
very basic set of features.
{% endexcerpt %}

Compared to today, the initial interface was dead simple. And one of the reasons for
today's complexity is, that Savon was build to be hackable. Almost everything can be
accessed and changed. SOAP and all its non-standard implementations are rather difficult
to get right, so I decided to allow you to tweak everything.

As it turns out, this decision makes it hard to refactor the code and add new features,
because Savon exposes way too much internal state.

So here's my plan to change the current situation:

1. Version 1.0 basically freezes the current interface. Savon now follows
   [Semantic Versioning](http://semver.org/) for future releases.

2. Version 1.1 limits Savon's core dependencies to bug fix updates. Every major
   or minor change to these dependencies requires a release of Savon and those
   changes will be documented in the [Changelog](https://github.com/savonrb/savon/blob/master/CHANGELOG.md).

3. Starting with version 1.2, I'm building a new interface and I'm shipping it while
   maintaining the current one.

If you're using Savon, I need you to try the new interface and to give me feedback
about how it works for you. If it doesn't work for some reason, please open a ticket.
I'm going to explain the new interface in another article soon.
