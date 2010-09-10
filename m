From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Fri, 10 Sep 2010 18:50:02 -0400
Message-ID: <20100910185002.73e61b8b@tlielax.poochiereds.net>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
	<AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
	<AANLkTi=zc7G847VHqVjO7LRfLkzzSGsJURvJmH1C8gOQ@mail.gmail.com>
	<AANLkTikXWGNtuOjPbG0wAdHLuVQOVuouaUaBi4HRwSR-@mail.gmail.com>
	<20100910081549.41de32d1@corrin.poochiereds.net>
	<AANLkTi=5YgKzG=rXJ5MuV+R_MGkEd+2ERouUiEc8K5B8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=5YgKzG=rXJ5MuV+R_MGkEd+2ERouUiEc8K5B8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 11 Sep 2010 00:16:41 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/9/10 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > filemap_fdatawrite starts up a flush of the writes but doesn't wait for
> > it to complete. The data is cached however. If there's a problem
> > writing out the data to the server that gets reported at fsync or
> > close. That's consistent with POSIX. We're not required to report
> > errors flushing the data until that time.
> 
> In this case we are not flushing all the cached data - we are doing
> write (via call from the userspace) and the application wants to know
> the right results of it. As I mentioned above, if we have mandatory
> byte-range lock from another client on this range of the file, the
> writing fails but the application won't know about it!
> 

So what? Why should the writer know anything about whether it succeeds
before a flush or close occurs? POSIX does not mandate that. If you are
able to report an error at write time, then that's fine. It's not
required however.

> > I see both oplocks being broken:
> >
> > 0x0001: frames 57 and 60
> > 0x0002: frames 65 and 66
> >
> 
> The first it is downgrading client1's oplock to Level II when client2
> opens the same file (client2 gets Oplock Level II) too), but the
> second - downgrading to None - I think it should be for every client
> opened the same file. But it the capture:
> 
> client2 writes to the file and gets Oplock break to None, but client1
> doesn't get it and still think that it can read from a cache (because
> it has Oplock Level II).
> 
> It is with Samba-4.0.0-alpha11. I tested it with Samba 3.4 and got
> another results (the capture is in attachment) - the server downgrades
> the oplock of client1 to None when client2 opens the file (client2
> gets Oplock None too) - it's right!
> 

That's not how I read this:

57: server downgrades oplock on 0x0001 to level 2
60: client drops oplock altogether for 0x0001 (note that it replies
    with oplock level 0)

65: server revokes oplock on 0x0002 altogether
66: client "acks" the oplock break

At that point there are no more oplocks held. Why would the server need
to send another oplock break?
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
