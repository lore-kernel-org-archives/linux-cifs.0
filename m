From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Fri, 24 Sep 2010 15:08:26 -0400
Message-ID: <20100924150826.1819f930@tlielax.poochiereds.net>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
	<AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
	<20100924141137.4cb03197@tlielax.poochiereds.net>
	<AANLkTinunozFdg9S+pBrNLpcgZKoAzVg2a4QXBOBi--u@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinunozFdg9S+pBrNLpcgZKoAzVg2a4QXBOBi--u-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 Sep 2010 13:43:40 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> It don't think it is a correctness issue - if close wants to do an
> fsync why do we have a flush routine at all? close is the only place
> flush is called.  This seems very wrong to require additional
> semantics beyond Unix semantics here (and slows close performance way
> down unnecessarily).  Even if we go async we would initiate i/o on
> these before we return close to the user - and we are not going to
> close the network handle of course until all network writes complete.
> 
> At a minimum, we don't need to do an fsync (flush with wait) on close
> if there is more than one handle to that inode open - and should be
> able to just do flush
> 

What does this have to do with fsync? The flush operation is to flush
out data to the server prior to close. CIFS is not like a local fs or
even NFS. We have to have an open filehandle in order to write out
data.

So, we have no choice but to ensure that all of the data is written out
to the server prior to allowing the filehandle to be closed. Waiting
for writeback to complete is mandatory here. If not, then there is no
place for that data to go but into the bit-bucket.

You also can't reasonably try to get clever and only wait for the
"last" filehandle to be closed. Any check you do there will be racy.
Suppose we have 2 filps being closed simultaneously and they're both
in .flush at the same time? How do you ensure that one of them will
stick around and wait for the flush to complete?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
