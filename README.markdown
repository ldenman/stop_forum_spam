# stop_forum_spam

http://github.com/ldenman/stop_forum_spam

### DESCRIPTION:

Small api wrapper for querying a spammer based on ip, email, or username information stored on http://stopforumspam.com

**Thanks to Russ Jackson for providing an api into stopforumspam.com.**


### SYNOPSIS:
    # query and post to stopforumspam.com
    # to post, you will need to register for an api key here: http://www.stopforumspam.com/signup

    # is so and so a spammer?
    StopForumSpam::Spammer.is_spammer?('12@42up.com') # by email
    StopForumSpam::Spammer.is_spammer?('broocorkidica') # by username
    StopForumSpam::Spammer.is_spammer?('212.235.107.199') # by IP

    # or use the finder method
    StopForumSpam::Spammer.find('212.235.107.199') # => Spammer or nil

    # you can query by multiple parameters for multiple records using where
    StopForumSpam::Spammer.where(:ip_address => '212.235.107.199', :email => '12@42up.com') # => [ Spammer, Spammer ]

    # so and so _is_ a spammer!
    client = StopForumSpam::Client.new(:api_key => '12346789')
    client.post(:ip_address => "127.0.0.1", :email => "spam@ru.com", :username => "iSpam")

### REQUIREMENTS:

* httparty

### INSTALL:

* gem install stop_forum_spam

### LICENSE:

(The MIT License)

Copyright (c) 2009 Lake Denman

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
