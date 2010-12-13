From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/13] cifs: don't fail writepages on -EAGAIN errors
Date: Mon, 13 Dec 2010 15:05:56 -0500
Message-ID: <20101213150556.7f0cf2f1@tlielax.poochiereds.net>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-2-git-send-email-jlayton@redhat.com>
	<AANLkTinzyPMq79aXmzARLpm1+X_GZho38AYR=zuyXKCi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinzyPMq79aXmzARLpm1+X_GZho38AYR=zuyXKCi-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 13 Dec 2010 23:01:41 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > If CIFSSMBWrite2 returns -EAGAIN, then the error should be consider=
ed
> > temporary. CIFS should retry the write instead of setting an error =
on
> > the mapping and returning.
> >
> > For WB_SYNC_ALL, just retry the write immediately.
> >
> > In the WB_SYNC_NONE case, call redirty_page_for_writeback on all of=
 the
> > pages that didn't get written out and then move on.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =A0fs/cifs/file.c | =A0 23 +++++++++++------------
> > =A01 files changed, 11 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index fe16f6d..8e57370 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1430,6 +1430,7 @@ retry:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0brea=
k;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (n_iov) {
> > +retry_write:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0open_file =3D find_w=
ritable_file(CIFS_I(mapping->host),
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0false);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!open_file) {
> > @@ -1445,22 +1446,20 @@ retry:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs=
_update_eof(cifsi, offset, bytes_written);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || bytes_writt=
en < bytes_to_write) {
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERRO=
R(1, "Write2 ret %d, wrote %d",
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 rc, bytes_written);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mappi=
ng_set_error(mapping, rc);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry on data-inte=
grity flush */
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN=
 && wbc->sync_mode =3D=3D WB_SYNC_ALL)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto =
retry_write;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs=
_stats_bytes_written(tcon, bytes_written);
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (rc !=3D -EAG=
AIN)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mappi=
ng_set_error(mapping, rc);
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < n_=
iov; i++) {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page=
 =3D pvec.pages[first + i];
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Sh=
ould we also set page error on
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 succe=
ss rc but too little data written? */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB=
 investigate retry logic on temporary
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 serve=
r crash cases and how recovery works
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 when =
page marked as error */
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r=
c)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (r=
c =3D=3D -EAGAIN)
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 redirty_page_for_writepage(wbc, page);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else =
if (rc !=3D 0)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0SetPageError(page);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kunm=
ap(page);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unlo=
ck_page(page);
> > --
> > 1.7.3.2
> >
>=20
> Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I actually sent a later version of this patch with the unfortunate
subject of:

[PATCH 00/13] cifs: don't fail writepages on -EAGAIN errors (try #2)

Mind reviewing that one instead? I think it fixes some cases that this
one doesn't...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
