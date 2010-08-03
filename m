From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Problems with CVS on CIFS since kernel 2.6.30
Date: Tue, 3 Aug 2010 08:35:14 -0400
Message-ID: <20100803083514.1179c92c@corrin.poochiereds.net>
References: <AANLkTingdjU-KKW3=KboAnR0pNeiE7aEje0nXhM6bYbe@mail.gmail.com>
	<4C56DBDD.4070501@suse.de>
	<AANLkTin9uwwDaw+nvAiDKnPxPbbBXycVS3rLvhCaoJxQ@mail.gmail.com>
	<4C56E564.3020508@suse.de>
	<AANLkTikqgFHX=9quJmJyQvkX-3ZreLGoF0k5YKCFq+WW@mail.gmail.com>
	<20100802131440.5b16a86b@tlielax.poochiereds.net>
	<AANLkTim=gnAh4G_JeRCEcCkfXb5pQwTTKh6+-7yAyyHu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim=gnAh4G_JeRCEcCkfXb5pQwTTKh6+-7yAyyHu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 3 Aug 2010 13:23:30 +0100
Jon Bramley <brammers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I've posted the dmesg output with cifsFYI set to 7, for the failed cvs
> update command here:
> 
> http://paste.org/pastebin/view/21123
> 
> One strange thing I notice, is that at one point it seems to be doing
> something with /home/jbramley/cvs_src/appserv/lib/ix86, but that folder is
> not in any of my env vars (PATH, LD_LIBRARY_PATH etc.) so I can see no
> reason for it to be looking there. Could this be some kind of inode
> confusion on the cifs share?
> 


*shrug* -- maybe...

Without a clear description of what the actual problem is it's
anybody's guess. All you've really told us so far is that cvs doesn't
work right. We need to understand what's wrong at the system call level
before we can really do much to help you.

I'd not bother with debugging output and such at this point. You need
to focus on the application. What's going wrong with it? Once you
understand that, then we can look at what's happening in the kernel.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
