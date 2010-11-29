From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 13:58:05 +0300
Message-ID: <AANLkTimO9t_wXPZRWXx856-wkG-EwRWTizrCKSo4e2SY@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-4-git-send-email-piastryyy@gmail.com>
	<20101128063604.7d9cdded@tlielax.poochiereds.net>
	<20101128065100.51c8a404@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101128065100.51c8a404-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sun, 28 Nov 2010 06:36:04 -0500
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Sun, 28 Nov 2010 11:12:49 +0300
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > On strict cache mode if we don't have Exclusive oplock we write a =
data to
>> > the server through cifs_user_write. Then if we Level II oplock sto=
re it in
>> > the cache, otherwise - invalidate inode pages affected by this wri=
ting.
>> >
>> > Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsfs.c | =A0 40 ++++++++++++++++++++++++++++++++++++-=
---
>> > =A01 files changed, 36 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> > index bbb5294..901c82b 100644
>> > --- a/fs/cifs/cifsfs.c
>> > +++ b/fs/cifs/cifsfs.c
>> > @@ -598,12 +598,44 @@ static ssize_t cifs_file_aio_read(struct kio=
cb *iocb, const struct iovec *iov,
>> > =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const st=
ruct iovec *iov,
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uns=
igned long nr_segs, loff_t pos)
>> > =A0{
>> > - =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_inod=
e;
>> > + =A0 struct inode *inode;
>> > + =A0 struct cifs_sb_info *cifs_sb;
>> > =A0 =A0 ssize_t written;
>> >
>> > - =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, pos);
>> > - =A0 if (!CIFS_I(inode)->clientCanCacheAll)
>> > - =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
>> > + =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> > +
>> > + =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> > + =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov, nr_=
segs, pos);
>> > +
>> > + =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> > +
>> > + =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=3D =
0) {
>> > + =A0 =A0 =A0 =A0 =A0 int rc;
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, iov=
, nr_segs, pos);
>> > +
>> > + =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mapping);
>> > + =A0 =A0 =A0 =A0 =A0 if (rc)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_file_aio_write=
: %d rc on %p inode",
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc, inode);
>> > + =A0 =A0 =A0 =A0 =A0 return written;
>> > + =A0 }
>> > +
>> > + =A0 /* in strict cache mode we need to write the data to the ser=
ver exactly
>> > + =A0 =A0 =A0from the pos to pos+len-1 rather than flush all affec=
ted pages
>> > + =A0 =A0 =A0because it may cause a error with mandatory locks on =
these pages but
>> > + =A0 =A0 =A0not on the region from pos to ppos+len-1 */
>>
>> =A0 =A0 =A0 Again, please fix the comment style. Here: ^^^^
>>
>> > + =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_base,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov->iov=
_len, &pos);
>> > +
>> > + =A0 iocb->ki_pos =3D pos;
>> > +
>> > + =A0 /* if we were successful - invalidate inode pages the write =
affected */
>> > + =A0 if (written > 0)
>> > + =A0 =A0 =A0 =A0 =A0 invalidate_mapping_pages(inode->i_mapping,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 (pos-written) >> PAGE_CACHE_SHIFT,
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 (pos-1) >> PAGE_CACHE_SHIFT);
>> > +
>> > =A0 =A0 return written;
>> > =A0}
>> >
>>
>> May god have mercy on anyone who tries to mix strictcache and mmap.
>>
>> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> (cc'ing Suresh so he can comment)
>
> Actually...I'm going to withdraw my Reviewed-by tag here for now. Thi=
s
> bare invalidate_mapping_pages doesn't deal with fscache.
>
> I think I need to understand what's intended when someone specifies
> strictcache and fsc before I can ack this. The simple answer would be
> that they are mutually exclusive, but if that's the case then the pat=
ch
> that adds the mount option needs to deal with that appropriately.


I don't think they can live together. I think we should do smth like a
following in mount options parsing:

=2E..
if (opt =3D=3D fscache) {
   vol->fscahe =3D 1;
   vol->strictcache =3D 0;
}
=2E..
if (opt =3D=3D strictcache) {
  vol->strictcache =3D 1;
  vol->fscache =3D 0;
}

So, if user specify both only the last will affect the client
behavior. Also we should add this information into cifs manpage.
Thoughts?

--=20
Best regards,
Pavel Shilovsky.
