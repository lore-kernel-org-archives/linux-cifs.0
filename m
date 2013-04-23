From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: add support for IPv6 addresses in brackets V2
Date: Tue, 23 Apr 2013 10:40:55 -0400
Message-ID: <CAFB9KM2BKfk3-EkxeG+bcPLoxAFdihKcGn+nFNAW5rWaH49wBw@mail.gmail.com>
References: <1365963558-20082-1-git-send-email-scott.lovenberg@gmail.com>
	<1366075789-23137-1-git-send-email-scott.lovenberg@gmail.com>
	<CAFB9KM00JWSUSP28LrzJsgQ0po6ZtTpK9enbwv3-N5y2+E5G0A@mail.gmail.com>
	<20130422110907.4e684579@tlielax.poochiereds.net>
	<CAFB9KM2QWUZrF-Bj5gkKqHiybYcFB5gskqGqRRsOQ8aGQC6WBw@mail.gmail.com>
	<20130423100114.2146f72a@tlielax.poochiereds.net>
	<CAH2r5ms4pcD--VzekvfoOL9WU-hS1KEFB2OZVmkb1z8aekhwGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms4pcD--VzekvfoOL9WU-hS1KEFB2OZVmkb1z8aekhwGg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Apr 23, 2013 at 10:26 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Apr 23, 2013 at 9:01 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>> > I guess I don't quite understand why we need this patch. For NFS it's
>>> > pretty clear that we would since ':' has always served as the delimiter
>>> > between the hostname and the pathname.
>
> I am ok with the idea of adding additional support that looks more
> like what an NFS user is comfortable with.   Ideally a user should be
> able to type very similar mount commands for cifs/smb3 and NFSv3/v4
> etc.
>
> Scott,
> Can you give a list of an example of these - mounts with each of the
> IPv6 formats that work (and what doesn't work) along with the one you
> propose?

I can get that together.

--
Peace and Blessings,
-Scott.
