From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Possible slab memory corruption while updating
 extended stats (repost)
Date: Fri, 4 Feb 2011 07:39:25 -0500
Message-ID: <20110204073925.3a21a048@tlielax.poochiereds.net>
References: <1296765078-25531-1-git-send-email-shirishpargaonkar@gmail.com>
	<AANLkTi=_HAQfH2oGvBrd2gBLa05EFndnpFGOny0NGCgW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=_HAQfH2oGvBrd2gBLa05EFndnpFGOny0NGCgW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 3 Feb 2011 21:18:18 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Good catch.
>=20
> But doesn't this belong in stable?
>=20

No, it's a recent regression from the call timeout patches.

> On Thu, Feb 3, 2011 at 2:31 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> >
> > Updating extended statistics here can cause slab memory corruption
> > if a callback function frees slab memory (mid_entry).
> >
> >
> > Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> > =A0fs/cifs/connect.c | =A0 =A04 ++--
> > =A01 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 945b220..1f32a28 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -633,11 +633,11 @@ incomplete_rcv:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_=
entry->largeBuf =3D isLargeBuf;
> > =A0multi_t2_fnd:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_=
entry->midState =3D MID_RESPONSE_RECEIVED;
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_=
del_init(&mid_entry->qhead);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_e=
ntry->callback(mid_entry);
> > =A0#ifdef CONFIG_CIFS_STATS2
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_=
entry->when_received =3D jiffies;
> > =A0#endif
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_=
del_init(&mid_entry->qhead);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_e=
ntry->callback(mid_entry);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brea=
k;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D NULL;
> > --
> > 1.6.0.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
