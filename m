From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: broken mandatory locking behavior
Date: Tue, 4 Oct 2011 12:27:58 -0400
Message-ID: <20111004162758.GA11682@fieldses.org>
References: <CAKywueSgXNhmoA7V82U5Y0=N+DQWysekAwDdsiLMPt6L0OV55Q@mail.gmail.com>
 <20111001083636.247525dc@tlielax.poochiereds.net>
 <CAKywueTN=QTBA+tqT79ObfXYmKmA4Rcx9N-XBDoJCURk0JPu+g@mail.gmail.com>
 <20111004065451.41bc3d2f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111004065451.41bc3d2f-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 04, 2011 at 06:54:51AM -0400, Jeff Layton wrote:
> I think this is tantamount to insisting that applications be specially
> written for cifs.ko if they want to do locking.
> 
> The larger goal for cifs.ko (as I see it) is to allow applications to
> mostly run unchanged on top of windows servers. Naturally, this is
> impossible since windows doesn't follow POSIX semantics, so the best we
> can do is closely approximate it.
> 
> There's certainly room for improvement here, but what you're proposing
> sounds like a step backward from that goal. It will break a lot of
> existing applications that run successfully on top of cifs.ko today.

Right.  You can tell which kind of locking the application wants by the
interface it's using.  If the application is using fcntl F_GETLK,
F_SETLK, F_SETLKW, then chances are it was written assuming posix
semantics, so all we can do is emulate those as best as possible.

If there are applications that need want the Windows semantics, then
we'd need to provide a new lock interface which promises them exactly
that.

--b.
