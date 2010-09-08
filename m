From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Wed, 8 Sep 2010 06:32:24 -0400
Message-ID: <20100908063224.240b0419@corrin.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 8 Sep 2010 10:49:13 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello!
> 
> I faced with a problem of the wrong cifs cache behavior while adapting
> CIFS VFS client for working with the application which uses file
> system as a mechanism for storing data and organizing paralell access
> from several client. If we look at CIFS code, we can see that it uses
> kernel cache mechanism all the time (do_sync_read, do_sync_write, etc)
> and delegate all the checking for validating data to cifs_revalidate
> call.
> 
> cifs_revalidate call uses QueryInfo protocol command for checking
> mtime and file size. I noticed that the server doesn't update mtime
> every time we writng to the server - that's why we can't use it.
> 

What sort of server were you working with here?

> On another hand CIFS spec says that the client can't use cache for if
> it doesn't have an oplock - if we don't follow the spec, we can faced
> with other problems.
> 
> Even more: if we use a Windows server and the mandatory locking style,
> now we can read from locking by other clients range (if we have this
> data in cache) - it's not right.
> 
> As the solution, I suggest to follow the spec in every it's part: to
> do cache write/read if we have Exclusive oplock, to do cache read if
> we have Oplock Level II and as for other cases - use direct operations
> with the server.
> 
> I attached the test (cache_problem.py) that shows the problem.
> 
> What do you think about it? I have the code that do read/write
> according to the spec but I want to discuss this question before
> posting the patch because I think it's rather important
> 

At the very least, we should consider a "strict" caching model like you
describe as an option. If it has a large performance impact then we may
want to allow people to use the existing caching model as well. OTOH,
maintaining multiple caching models may be too cumbersome to support.

If you're saying however that the spec says this, then it would
also be helpful to point out the place in the spec that outlines this
so we can go back and read over that part.

There's no need to hesitate in sending the patches however. Doing so
gives us a starting point for discussing the change. If you're not sure
about them, just declare them an "RFC".

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
