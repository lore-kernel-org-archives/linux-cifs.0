From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS data coherency problem
Date: Thu, 9 Sep 2010 22:34:22 +0400
Message-ID: <AANLkTikOR_HU934L6FKq8q2ZwcaTTOTPfaSofimK6OFH@mail.gmail.com>
References: <AANLkTin2iSc=Ob3DkhARJRV7CzwRUBJSGRMUJNJM+82k@mail.gmail.com>
	<AANLkTi=_eMSC99K1a2zWpgW5nc8UArzKj2MWHaRmCXzK@mail.gmail.com>
	<20100908063224.240b0419@corrin.poochiereds.net>
	<AANLkTinYFe6O-4ANt1VYcvEMukiis-11cDuMP2GSKZ7j@mail.gmail.com>
	<AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin+qiQsF_hOCvdBKtCh0n0bcd82RDOUz=h3K6gu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/9/9 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Note that metadata caching is common for most network file systems
> (not unique to cifs or nfs) - and is usually done on a timer.
>
> NFSv3 data caching is unsafe - no guarantees data makes it to server
> until sync or close. =A0Generally if a file has not changed between
> close and open - seems reasonable to keep the cached copy. =A0 If we

As I mentioned in the first email, CIFS servers doesn't update mtime
of a file every time and that brings complexity. So we can't be sure
that we have actual data of a file in a cache.

> have two opens of the same file from different clients we won't be
> caching anyway.

But now CIFS kernel client does it - it uses cache. As for SMB2 - it's =
the same.

>
> In SMB2 we will be doing batch oplock.
>

--=20
Best regards,
Pavel Shilovsky.
