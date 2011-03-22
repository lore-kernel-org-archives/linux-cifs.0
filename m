From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Tue, 22 Mar 2011 08:04:09 -0400
Message-ID: <20110322080409.23461155@corrin.poochiereds.net>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 22 Mar 2011 15:01:11 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/3/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Wed, 16 Mar 2011 01:55:32 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Use invalidate_inode_pages2 that don't leave pages even if shrink_=
page_list()
> >> has a temp ref on them. It prevents a data coherency problem when
> >> cifs_invalidate_mapping didn't invalidate pages but the client thi=
nks that a data
> >> from the cache is uptodate according to an oplock level (exclusive=
 or II).
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =A0fs/cifs/inode.c | =A0 10 ++++++++--
> >> =A01 files changed, 8 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> index 41e5651..adb6324 100644
> >> --- a/fs/cifs/inode.c
> >> +++ b/fs/cifs/inode.c
> >> @@ -1691,12 +1691,18 @@ cifs_invalidate_mapping(struct inode *inod=
e)
> >>
> >> =A0 =A0 =A0 cifs_i->invalid_mapping =3D false;
> >>
> >> - =A0 =A0 /* write back any cached data */
> >> =A0 =A0 =A0 if (inode->i_mapping && inode->i_mapping->nrpages !=3D=
 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* write back any cached data */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode->i=
_mapping);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mapping_set_error(inode->i_mapping, rc=
);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D invalidate_inode_pages2(inode->i_=
mapping);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: could not=
 invalidate inode %p", __func__,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->invalid_mapping =
=3D true;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 }
> >> - =A0 =A0 invalidate_remote_inode(inode);
> >> +
> >> =A0 =A0 =A0 cifs_fscache_reset_inode_cookie(inode);
> >> =A0}
> >>
> >
> > Hi Pavel,
> >
> > I noticed that Steve has merged this patch, but it doesn't seem lik=
e
> > you ever made the change to have EBUSY percolate up to userspace. A=
re
> > you still planning to fix that?
> >
>=20
> Steve NACK'ed this and we came to agreement to mark a mapping as
> invalid in this case for now and let the client try invalidate it
> again when it needs. Of course, it can bring problems with a data
> coherency if you need to use a cache very strictly.
>=20

Ahh, I must have missed the discussion around that NAK, and I don't see
any record of it in the list archives. Steve, can you clarify why you
didn't think that approach was acceptible?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
