From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 06:56:09 -0500
Message-ID: <20101129065609.27592711@tlielax.poochiereds.net>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-3-git-send-email-piastryyy@gmail.com>
	<20101129073555.GA4573@infradead.org>
	<AANLkTimcVhP10LSn5+F+AY+ppnrhKmp_VCsjkKf04cQr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimcVhP10LSn5+F+AY+ppnrhKmp_VCsjkKf04cQr-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 29 Nov 2010 13:41:13 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/29 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>:
> >
> > Your patch arbitrarily shortens the read to the first vector. =A0Wh=
ile
> > short reads for regular files are fine with Posix, it will break a =
lot
> > of userspace applications.
> >
>=20
> cifs_user_read returns the number of bytes we read from the server an=
d
> it, of course, can be different with requested number. Could you
> explain carefully what do you mean, please? Where is a problem here?
>=20
>=20

Gah...good catch, Christoph. I'll need to rescind my ack for this patch
too.

Pavel, note that the aio_read prototype has a "nr_segs" argument. Your
patch ignores that argument in the strictcache case. If someone passes
in an array of iovecs, then you're ignoring all but the first.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
