From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] CIFS: New write logic
Date: Wed, 3 Nov 2010 07:34:03 -0400
Message-ID: <20101103073403.04e8fc02@tlielax.poochiereds.net>
References: <AANLkTinegdugrKiMn4rErSyfp-t7HK6pYxumAS5DDiya@mail.gmail.com>
	<20101102114350.59f41db2@tlielax.poochiereds.net>
	<AANLkTi=HMTsqLXoVPkE=0CitmyXTV110KPDNSZ6fOp=w@mail.gmail.com>
	<20101103071456.27ed871b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103071456.27ed871b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 3 Nov 2010 07:14:56 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 2 Nov 2010 20:59:00 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > 2010/11/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > > On Tue, 2 Nov 2010 12:02:24 +0300
> > > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > >> Modify cifs_file_aio_write and cifs_write_end to let the client =
works with
> > >> strict cache mode.
> > >>
> > >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >> ---
> > >> =A0fs/cifs/cifsfs.c | =A0 35 ++++++++++++++++++++++++++++++-----
> > >> =A0fs/cifs/file.c =A0 | =A0 14 ++++++++++++--
> > >> =A02 files changed, 42 insertions(+), 7 deletions(-)
> > >>
> > >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > >> index 1b44a92..e1ecd35 100644
> > >> --- a/fs/cifs/cifsfs.c
> > >> +++ b/fs/cifs/cifsfs.c
> > >> @@ -602,12 +602,37 @@ static ssize_t cifs_file_aio_read(struct k=
iocb
> > >> *iocb, const struct iovec *iov,
> > >> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const =
struct iovec *iov,
> > >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0unsigned long nr_segs, loff_t pos)
> > >> =A0{
> > >> - =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->=
d_inode;
> > >> - =A0 =A0 ssize_t written;
> > >> + =A0 =A0 struct inode *inode;
> > >> + =A0 =A0 struct cifs_sb_info *cifs_sb;
> > >> + =A0 =A0 ssize_t written, cache_written;
> > >> + =A0 =A0 loff_t saved_pos;
> > >> +
> > >> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
> > >> +
> > >> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, io=
v, nr_segs, pos);
> > >> +
> > >> + =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb=
);
> > >> +
> > >> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=
=3D 0) {
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(ioc=
b, iov, nr_segs, pos);
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(inode->i_mappin=
g);
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^^^^
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0You can't ignore the return code f=
rom this. That function
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0may return an error if writeback f=
ails. Also, I don't
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0see any need to wait on the result=
 in this case. Why
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0not just kick off the I/O and retu=
rn (do a
> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0filemap_fdatawrite, IOW).
> >=20
> > I don't change non-strict variant for writing - we have this code n=
ow
> > in the git tree. But I agree - we should think about return value i=
n
> > this case.
> >=20
> > >
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 return written;
> > >> + =A0 =A0 }
> > >> +
> > >> + =A0 =A0 saved_pos =3D pos;
> > >> + =A0 =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_ba=
se,
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io=
v->iov_len, &pos);
> > >> +
> > >> + =A0 =A0 if (written > 0) {
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 cache_written =3D generic_file_aio_wri=
te(iocb, iov,
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_segs, saved_pos);
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 if (cache_written !=3D written)
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Cache writt=
en and server written data "
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"length=
s are different");
> > >> + =A0 =A0 } else
> > >> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
> > >>
> > > =A0 =A0 =A0 =A0^^^^^
> > > This seems awfully complicated. Why not just do a
> > > generic_file_aio_write to get this into the cache and then just d=
o a
> > > filemap_write_and_wait and deal with the result?
> >=20
> > The main reason of doing this is mandatory byte-range locks. If we
> > simply do generic_file_aio_write and then filemap_write_and_wait we
> > can fail in the following situation:
> > 1) process1 opens file and sets a mandatory lock from 0 to 1.
> > 2) process2 opens file and writes a data from 1 to 2.
> >=20
> > If we do like you suggest we fail on page writing (on
> > filemap_write_and_wait which writes whole page - from 0 to 2). That=
's
> > why I do cifs_user_write which writes the data from 1 to 2 (it's wh=
at
> > we need) and then store it in the cache by generic_file_aio_write
> > (with the little change in cifs_write_end that doesn't write the sa=
me
> > data twice to the server). So, right working of write and read ops
> > with mandatory locks is one of the reasons to provide srict cache
> > semantic.
> >=20
>=20
> Why store it in the cache at all at that point then? Is that for mmap=
?
>=20
> This seems really ugly and doesn't pass the "sniff test" -- something
> smells foul here. There must be a better way to handle this sort of
> thing...
>=20

To elaborate...

Rather than calling down into generic_file_aio_write, I think you'd be
better served by simply invalidating the pages in the range that the
write touched, or possibly just invalidating the entire cached inode.

Also, I still haven't seen a description of what the semantics for mmap
will be in this case. If I'm using strict caching and mmap a file, it
obviously isn't going to read/write through every time userspace
touches the memory. What can I expect to happen when I read or write to
that mmap? How can I ensure that new data will be faulted in or data
that I write will be synced out?

This needs to be settled before we can consider merging this code.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
