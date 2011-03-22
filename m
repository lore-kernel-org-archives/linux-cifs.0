From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Tue, 22 Mar 2011 12:35:49 -0400
Message-ID: <20110322123549.022e590e@corrin.poochiereds.net>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
	<20110322080409.23461155@corrin.poochiereds.net>
	<AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
	<20110322111711.55365655@corrin.poochiereds.net>
	<AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 22 Mar 2011 11:24:02 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Mar 22, 2011 at 10:17 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Tue, 22 Mar 2011 09:50:43 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Mar 22, 2011 at 7:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Tue, 22 Mar 2011 15:01:11 +0300
> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >
> >> >> 2011/3/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> >> > On Wed, 16 Mar 2011 01:55:32 +0300
> >> >> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >> >> >
> >> >> >> Use invalidate_inode_pages2 that don't leave pages even if s=
hrink_page_list()
> >> >> >> has a temp ref on them. It prevents a data coherency problem=
 when
> >> >> >> cifs_invalidate_mapping didn't invalidate pages but the clie=
nt thinks that a data
> >> >> >> from the cache is uptodate according to an oplock level (exc=
lusive or II).
> >> >> >>
> >> >> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> >> >> ---
> >> >> >> =C2=A0fs/cifs/inode.c | =C2=A0 10 ++++++++--
> >> >> >> =C2=A01 files changed, 8 insertions(+), 2 deletions(-)
> >> >> >>
> >> >> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> >> >> index 41e5651..adb6324 100644
> >> >> >> --- a/fs/cifs/inode.c
> >> >> >> +++ b/fs/cifs/inode.c
> >> >> >> @@ -1691,12 +1691,18 @@ cifs_invalidate_mapping(struct inode=
 *inode)
> >> >> >>
> >> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_i->invalid_mapping =3D false;
> >> >> >>
> >> >> >> - =C2=A0 =C2=A0 /* write back any cached data */
> >> >> >> =C2=A0 =C2=A0 =C2=A0 if (inode->i_mapping && inode->i_mappin=
g->nrpages !=3D 0) {
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* write back an=
y cached data */
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D file=
map_write_and_wait(inode->i_mapping);
> >> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping_set=
_error(inode->i_mapping, rc);
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D invalidat=
e_inode_pages2(inode->i_mapping);
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cERROR(1, "%s: could not invalidate inode %p", __func__,
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inode);
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_i->invalid_mapping =3D true;
> >> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >> >> - =C2=A0 =C2=A0 invalidate_remote_inode(inode);
> >> >> >> +
> >> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_fscache_reset_inode_cookie(inode);
> >> >> >> =C2=A0}
> >> >> >>
> >> >> >
> >> >> > Hi Pavel,
> >> >> >
> >> >> > I noticed that Steve has merged this patch, but it doesn't se=
em like
> >> >> > you ever made the change to have EBUSY percolate up to usersp=
ace. Are
> >> >> > you still planning to fix that?
> >> >> >
> >> >>
> >> >> Steve NACK'ed this and we came to agreement to mark a mapping a=
s
> >> >> invalid in this case for now and let the client try invalidate =
it
> >> >> again when it needs. Of course, it can bring problems with a da=
ta
> >> >> coherency if you need to use a cache very strictly.
> >> >>
> >> >
> >> > Ahh, I must have missed the discussion around that NAK, and I do=
n't see
> >> > any record of it in the list archives. Steve, can you clarify wh=
y you
> >> > didn't think that approach was acceptible?
> >>
> >> Pavel and I discussed the code paths in detail via IRC or chat. =C2=
=A0I
> >> would have to go back and look through the code again, but I thoug=
ht
> >> the issue was that returning
> >> EBUSY (from invalidate_inode_pages2) doesn't make any sense to
> >> revalidate_file (e.g. why would a seek return EBUSY even though we
> >> successfully updated the correct file size?) who can't use the rc,=
 but
> >> by resetting the mapping to invalid_mapping invalidate_inode_pages=
2
> >> will still get invoked again later (which is all we would do in th=
e
> >> caller if we passed it back).
> >>
> >> In practice it probably doesn't make much difference for cifs anyw=
ay
> >> (passing the return code back from invalidate_inode_pages2) becaus=
e we
> >> don't have a "launder_page" operation for cifs and therefore don't
> >> return an error, and for the other case it doesn't seem correct to
> >> fail a seek because of (page_has_private(page))
> >>
> >
> > It does however make sense to return an error if you're going to
> > invalidate a page and can't because the page is dirty:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0ret2 =3D do_launder_page(mapping, page);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (ret2 =3D=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!invalidate_complete_page=
2(mapping, page))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r=
et2 =3D -EBUSY;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0}
> >
> > do_launder_page returns 0 if there is no launder_page op...
> >
> > invalidate_complete_page does this:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (PageDirty(page))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto failed;
> >
> > ...so the fact that we don't have a launder_page operation doesn't =
mean
> > that we'll never return an error here.
> >
> > It makes no sense at all to do a cERROR printk for this. It'll make
> > users go "huh?", and won't help us to debug anything.
>=20
> but how could we have PageDirty?  We just did filemap_write_and_wait
> (unless some private mmap case where it may be ok?).
>=20

Nothing prevents the page from being redirtied after writeback.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
