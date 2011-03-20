From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Sun, 20 Mar 2011 09:41:21 -0400
Message-ID: <20110320094121.39be555c@tlielax.poochiereds.net>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
	<20110317164446.GA26600@infradead.org>
	<AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
	<20110318185154.GA8028@infradead.org>
	<20110319171735.429915b0@corrin.poochiereds.net>
	<AANLkTi==ojddc91ruaLHJvY85_tHvNe1J+YVZi7fsj8n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi==ojddc91ruaLHJvY85_tHvNe1J+YVZi7fsj8n-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 19 Mar 2011 22:05:43 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Mar 19, 2011 at 4:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 18 Mar 2011 14:51:54 -0400
> > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >
> >> On Thu, Mar 17, 2011 at 12:17:24PM -0500, Steve French wrote:
> >> > If others feel strongly about this, I don't mind changing it as
> >> > Christoph suggests but
> >> > - to samba people, "incrementing the rfc1001 length" would be mo=
re
> >> > recognizable (than opencoding the be32_add_cpu macro), and the
> >> > function name was
> >> > actually Jeff's suggestion which I liked.
> >>
> >> I don't mind the rfc1001 length per se. =A0What's totally braindea=
d about
> >> this is having an absolutely trivial wrapper for incrementing a fi=
eld,
> >> which has a different name than the field it increments.
> >>
> >> If you feel strongly about the rfc1001 length just rename the fiel=
d.
> >>
> >
> > FWIW, the MS-SMB doc calls this value the "Stream Protocol Length".=
 It
> > also mentions that this is actually a 24 bit field and the upper 8 =
bits
> > are supposed to be zeroed out.
> >
> > Should this wrapper check for values that violate that? A little
> > defensive coding in this area wouldn't hurt.
>=20
> I agree, defensive code wouldn't hurt here. We do actually check IIRC
> the first byte of it (which acts as an "rfc1001" command code, where
> zero is what we want for most, in cifs_demultiplex_thread).   Of the
> next 3 bytes, which serve as a length field, old servers had a small
> maximum smb size, and thus only read two bytes, eventually some
> servers allowed you to use just over 64K, and Samba has allowed more
> than that for years.
>=20

cifs_demultiplex_thread checks the first byte of data that is
*received*. It cannot check that what we're sending is within spec.
Perhaps this wrapper should.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
