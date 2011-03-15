From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: add entry for strictcache option
Date: Tue, 15 Mar 2011 13:31:47 -0400
Message-ID: <20110315133147.3b38df15@tlielax.poochiereds.net>
References: <1299747318-8164-1-git-send-email-piastry@etersoft.ru>
	<AANLkTimKtXgwTbW9gacyaA8WnroUMbq=+WeRnUXbj5i+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimKtXgwTbW9gacyaA8WnroUMbq=+WeRnUXbj5i+-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Mar 2011 10:17:51 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/3/10 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > ---
> > =A0mount.cifs.8 | =A0 =A05 +++++
> > =A01 files changed, 5 insertions(+), 0 deletions(-)
> >
> > diff --git a/mount.cifs.8 b/mount.cifs.8
> > index d8ad9f0..2ebe19d 100644
> > --- a/mount.cifs.8
> > +++ b/mount.cifs.8
> > @@ -220,6 +220,11 @@ directio
> > =A0Do not do inode data caching on files opened on this mount\&. Th=
is precludes mmaping files on this mount\&. In some cases with fast net=
works and little or no caching benefits on the client (e\&.g\&. when th=
e application is doing large sequential reads bigger than page size wit=
hout rereading the same data) this can provide better performance than =
the default behavior which caches reads (readahead) and writes (writebe=
hind) through the local Linux client pagecache if oplock (caching token=
) is granted and held\&. Note that direct allows write operations large=
r than page size to be sent to the server\&. On some kernels this requi=
res the cifs\&.ko module to be built with the CIFS_EXPERIMENTAL configu=
re option\&.
> > =A0.RE
> > =A0.PP
> > +strictcache
> > +.RS 4
> > +Use for switching on strict cache mode\&. In this mode the client =
reads from the cache all the time it has Oplock Level II, otherwise - r=
ead from the server\&. As for write - the client stores a data in the c=
ache in Exclusive Oplock case, otherwise - write directly to the server=
\&.
> > +.RE
> > +.PP
> > =A0mapchars
> > =A0.RS 4
> > =A0Translate six of the seven reserved characters (not backslash, b=
ut including the colon, question mark, pipe, asterik, greater than and =
less than characters) to the remap range (above 0xF000), which also all=
ows the CIFS client to recognize files created with such characters by =
Windows\'s POSIX emulation\&. This can also be useful when mounting to =
most versions of Samba (which also forbids creating and opening files w=
hose names contain any of these seven characters)\&. This has no effect=
 if the server does not support Unicode on the wire\&. Please note that=
 the files created with mapchars mount option may not be accessible if =
the share is mounted without that option\&.
> > --
> > 1.7.1
> >
> >
>=20
> Jeff, what's about this?
>=20

Merged.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
