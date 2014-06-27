From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH v2 01/16] CIFS: Fix async reading on reconnects
Date: Fri, 27 Jun 2014 09:14:26 -0500
Message-ID: <CAH2r5mukT9bruy+n=xcFfhzQpeMDYOwJ2RRtyw0mPpEWeDwbSg@mail.gmail.com>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
 <1403863073-19526-2-git-send-email-pshilovsky@samba.org> <20140627065222.434cd5ea@tlielax.poochiereds.net>
 <CAH2r5mvWfmgZb=7oGqbqbRDKv4xPP3RszHXpe-rxGv5FbGBerw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvWfmgZb=7oGqbqbRDKv4xPP3RszHXpe-rxGv5FbGBerw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Jun 27, 2014 at 9:12 AM
Subject: Re: [PATCH v2 01/16] CIFS: Fix async reading on reconnects
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>





On Fri, Jun 27, 2014 at 5:52 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
>
> On Fri, 27 Jun 2014 13:57:38 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> > If we get into read_into_pages() from cifs_readv_receive() and then
> > loose a network, we issue cifs_reconnect that moves all mids to
> > a private list and issue their callbacks. The callback of the async
> > read request sets a mid to retry, frees it and wakes up a process
> > that waits on the rdata completion.
> >
> > After the connection is established we return from read_into_pages()
> > with a short read, use the mid that was freed before and try to read
> > the remaining data from the a newly created socket. Both actions are
> > not what we want to do. In reconnect cases (-EAGAIN) we should not
> > mask off the error with a short read but should return the error
> > code instead.
> >
>
> I'm not sure I understand what problem this solves. Why is returning a
> short read wrong here?
>

It will oops since the mid has already been freed and the caller uses
the mid (cifs_readv_receive calls dequeue_mid with the mid).
rdata->read_into_pages succeeded with a short read so length > 0 but
the mid was freed due to the reconnect

-- 
Thanks,

Steve



-- 
Thanks,

Steve
