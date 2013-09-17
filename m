From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: dmesg: "CIFS VFS: Unexpected lookup error -26"
Date: Tue, 17 Sep 2013 07:08:49 -0400
Message-ID: <20130917070849.6c9b9356@tlielax.poochiereds.net>
References: <op.w295luvq07ery2@nmr100.nioch.nsc.ru>
	<20130912055839.5ca8e8c3@tlielax.poochiereds.net>
	<20130914073847.075b1921@tlielax.poochiereds.net>
	<op.w3h5getf07ery2@nmr100.nioch.nsc.ru>
	<20130916081653.1567cf04@corrin.poochiereds.net>
	<op.w3jhe3yi07ery2@nmr100.nioch.nsc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <op.w3jhe3yi07ery2-pBYy1DuGxBzUS83QA+KWFijHesifYMBh@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 Sep 2013 11:58:05 +0700
"Andrey Shernyukov" <andreysh-0G7livjLyD/FOEHFb8W2jw@public.gmane.org> wrote:

> On Mon, 16 Sep 2013 19:16:53 +0700, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
>=20
> > No, sorry -- that doesn't tell me much. I had pretty much inferred =
that
> > from the info before. What would be more interesting is the capture=
 of
> > the FIND_FIRST/NEXT calls, in binary format so I can open them with
> > wireshark and see what it's sending.
> >
>=20
> =D0=9E.=D0=9A. Capture packets are in attachment (except first packet=
s with =20
> authorization information) as "libpcap" wireshark format.
>=20

Ok, based on this and the previous text dumps of the QUERY_PATH_INFO
packets, it looks like FIND_FIRST/NEXT is able to fetch this info
without issue, but the QUERY_PATH_INFO call gets back an error. There's
not much we can do about that without some major reworking of the
lookup code.

I think we really ought to convert the lookup code to use a FIND_FIRST
call with a specific name instead of QUERY_PATH_INFO. It seems to
"perturb" things less, plus it also gives us the index number which
we use as an inode number. That allows us to do lookups on unknown
dentries without a second call to fetch the UniqueID.

Additionally, I think we ought to make that error not print by default.
I'll send a patch to tone that down in a bit.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
