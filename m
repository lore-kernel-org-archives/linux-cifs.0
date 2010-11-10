From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
Date: Wed, 10 Nov 2010 07:04:20 -0500
Message-ID: <20101110070420.74daca64@tlielax.poochiereds.net>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
	<1288945777-9197-4-git-send-email-piastryyy@gmail.com>
	<20101109131001.56a40c86@corrin.poochiereds.net>
	<AANLkTik-0k-p_XeWjd79-Popa57g-BFcLtB-XY55mktw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik-0k-p_XeWjd79-Popa57g-BFcLtB-XY55mktw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 9 Nov 2010 21:16:44 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/9 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> > On Fri, =A05 Nov 2010 11:29:34 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On strict cache mode if we don't have Exclusive oplock we write a =
data to
> >> the server through cifs_user_write. Then if we Level II oplock sto=
re it in
> >> the cache, otherwise - invalidate inode pages affected by this wri=
ting.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsfs.c | =A0 51 +++++++++++++++++++++++++++++++++++++=
+++++++++-----
> >> =A0fs/cifs/file.c =A0 | =A0 14 ++++++++++++--
> >> =A02 files changed, 58 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index bb7f36e..fbcd219 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -596,12 +596,53 @@ static ssize_t cifs_file_aio_read(struct kio=
cb *iocb, const struct iovec *iov,
> >> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const st=
ruct iovec *iov,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
unsigned long nr_segs, loff_t pos)
> >> =A0{
> >> - =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_=
inode;
> >> - =A0 =A0 ssize_t written;
> >> + =A0 =A0 struct inode *inode;
> >> + =A0 =A0 struct cifs_sb_info *cifs_sb;
> >> + =A0 =A0 ssize_t written, cache_written;
> >> + =A0 =A0 loff_t saved_pos;
> >> +
> >> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
> >> +
> >> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov,=
 nr_segs, pos);
> >> +
> >> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
> >> +
> >> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=
=3D 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 int rc;
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb,=
 iov, nr_segs, pos);
> >> +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mappi=
ng);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_file_aio_w=
rite: %d rc on %p inode",
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc, inode);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 saved_pos =3D pos;
> >> + =A0 =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_base=
,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov-=
>iov_len, &pos);
> >> +
> >> + =A0 =A0 if (written > 0 && CIFS_I(inode)->clientCanCacheRead) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* we have data written to the server an=
d at least oplock
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for reading - store the date in t=
he cache */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cache_written =3D generic_file_aio_write=
(iocb, iov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_segs, saved_pos);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (cache_written !=3D written)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Cache written=
 and server written data "
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"lengths =
are different");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
> >> + =A0 =A0 }
> >> +
> >> + =A0 =A0 if (written > 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 invalidate_mapping_pages(inode->i_mappin=
g,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 saved_pos >> PAGE_CACHE_SHIFT,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 (saved_pos+iov->iov_len-1)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 >> PAGE_CACHE_SHIFT);
> >> +
> >> + =A0 =A0 iocb->ki_pos =3D pos;
> >>
> >> - =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, p=
os);
> >> - =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
> >> =A0 =A0 =A0 return written;
> >> =A0}
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index b36de2e..85824c0 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1537,7 +1537,11 @@ static int cifs_write_end(struct file *file=
, struct address_space *mapping,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *page, voi=
d *fsdata)
> >> =A0{
> >> =A0 =A0 =A0 int rc;
> >> - =A0 =A0 struct inode *inode =3D mapping->host;
> >> + =A0 =A0 struct inode *inode;
> >> + =A0 =A0 struct cifs_sb_info *cifs_sb;
> >> +
> >> + =A0 =A0 inode =3D mapping->host;
> >> + =A0 =A0 cifs_sb =3D CIFS_SB(inode->i_sb);
> >>
> >> =A0 =A0 =A0 cFYI(1, "write_end for page %p from pos %lld with %d b=
ytes",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0page, pos, copied);
> >> @@ -1570,7 +1574,13 @@ static int cifs_write_end(struct file *file=
, struct address_space *mapping,
> >> =A0 =A0 =A0 } else {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D copied;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pos +=3D copied;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* if we have strict cache switched on a=
nd don't have Exclusive
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock for the inode, we don't ha=
ve to set_page_dirty
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0because we flushed the data to th=
e server in
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file_aio_write before */
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_STRICT_IO) =3D=3D 0 ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->clientCanCacheAll=
)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> >
> > Is there a potential for a race here? Suppose I have clientCanCache=
All
> > set, I write to the cache, but before I get to cifs_write_end, an
> > oplock break is processed and clientCanCacheAll is cleared. Now I h=
ave
> > dirty data in cache but the dirty flag doesn't get set. Does anythi=
ng
> > prevent that?
>=20
> Yes, you are right. In the case of clientCanCacheAll and STRICT_IO se=
t
> - can we call set_page_dirty for every page affected by our write in
> cifs_file_aio_write? It should prevent races, I think.
>=20

Hmm...setting the dirty bit before the data has actually been copied to
the page? I'm not sure that's a good idea. If you want to do that you
may want to run it by linux-fsdevel first.

Maybe you could do something instead with the fsdata pointer in
write_begin and write_end?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
