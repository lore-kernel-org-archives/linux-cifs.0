From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Dir List Across Network - Slow from one machine, fast from
 another
Date: Tue, 28 Sep 2010 13:24:02 -0400
Message-ID: <20100928132402.44637254@tlielax.poochiereds.net>
References: <AANLkTim0jDLqVVsT2WropqDu30=OWmqQyUK4tmsG=x_M@mail.gmail.com>
	<AANLkTi=ELucgtRA=7FW1-04DrsBN=KqvsSc81bjeYVNG@mail.gmail.com>
	<20100924094145.1f465ca0@tlielax.poochiereds.net>
	<AANLkTik77ENc_ATkccRc-Q4NJ0gdNVCC0tT0YSSrz7kR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Tonks <fluffymike-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik77ENc_ATkccRc-Q4NJ0gdNVCC0tT0YSSrz7kR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 28 Sep 2010 17:56:21 +0100
Mike Tonks <fluffymike-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:

> Hi Jeff,
> 
> Thanks for the response - you gave me an excuse to download the new
> ubuntu 10.10 beta and fire it up.
> 
> So I now have a VirtualBox vm on the same network running
> 2.6.36-19-generic.  Is that recent enough to have the fix you
> mentioned?
> 

Yes, it went in a few releases ago.

> The result is odd / interesting.  The first time I run the 'ls -la' it
> is quick (4 seconds) as per the older machine, but on subsequent calls
> it slow again (4 minutes) like the production box.
> 
> If I umount then mount again, I get one fast lookup, then slow again
> for any further calls.  Totally repeatable, I've been repeating on and
> off all day and scratching my head in bewilderment.
> 
> I checked the 2.6.31 machine and the umount trick does not work there.
> 
> Any ideas?
> 

Nothing I can think of right offhand. You'll probably have to do some
debugging to track down the cause. Maybe look at captures in wireshark
and see if you can discern the difference in behavior between the two
runs.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
