From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/7] cifs: Allow directIO read/write during cache=strict
Date: Thu, 21 Aug 2014 11:56:08 -0400
Message-ID: <20140821115608.494fb1f9@tlielax.poochiereds.net>
References: <003501cfbc62$fac9f4b0$f05dde10$@samsung.com>
	<20140821072656.372e613c@tlielax.poochiereds.net>
	<CAH2r5mu6LH1YLqWhi4-1dgJH0BQ2CS5Lbym1mGP9EuvgtCP1Wg@mail.gmail.com>
	<20140821110254.4f2dcc95@tlielax.poochiereds.net>
	<CAH2r5mvAhxXXzG-Rgt2BD4a8EYsdGRcfUeEZC=AF5XTNO6ZXeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvAhxXXzG-Rgt2BD4a8EYsdGRcfUeEZC=AF5XTNO6ZXeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Aug 2014 10:18:37 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 21, 2014 at 10:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > On Thu, 21 Aug 2014 08:24:35 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> If you are opening O_DIRECT why wouldn't you use oplock, ie still
> >> request oplock, simply to minimize metadata traffic (you don't have to
> >> send stat across the wire).  The reads and writes aren't cached but
> >> the inode metadata would be.
> >>
> >
> > What updates the i_size if a DIO write extends the file?
> 
> Doesn't direct writes call cifs_user_writev which calls
> cifs_iovec_write which calls cifs_write_from_iter which calls
> cifs_uncached_writev_complete
> 
> so looks like i_size should get set
> 
> 

Ok, fair enough then. I still think it's a little silly to request an
oplock that you won't really be using, but I suppose there's no reason
to specifically forbid it.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
