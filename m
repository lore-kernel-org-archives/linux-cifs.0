From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #2)
Date: Mon, 29 Nov 2010 14:55:48 +0300
Message-ID: <AANLkTinE+YY3CsamL==hFwY3R3ZCCXU-mF7gc7x=g94B@mail.gmail.com>
References: <1290931972-2770-1-git-send-email-piastryyy@gmail.com>
	<1290931972-2770-4-git-send-email-piastryyy@gmail.com>
	<20101128063604.7d9cdded@tlielax.poochiereds.net>
	<20101128065100.51c8a404@tlielax.poochiereds.net>
	<AANLkTimO9t_wXPZRWXx856-wkG-EwRWTizrCKSo4e2SY@mail.gmail.com>
	<20101129063713.0b71ac09@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-l3A5Bk7waGM@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101129063713.0b71ac09-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Mon, 29 Nov 2010 13:58:05 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/11/28 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > On Sun, 28 Nov 2010 06:36:04 -0500
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> >> On Sun, 28 Nov 2010 11:12:49 +0300
>> >> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >> > On strict cache mode if we don't have Exclusive oplock we write=
 a data to
>> >> > the server through cifs_user_write. Then if we Level II oplock =
store it in
>> >> > the cache, otherwise - invalidate inode pages affected by this =
writing.
>> >> >
>> >> > Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> > ---
>> >> > =A0fs/cifs/cifsfs.c | =A0 40 ++++++++++++++++++++++++++++++++++=
++----
>> >> > =A01 files changed, 36 insertions(+), 4 deletions(-)
>> >> >
>> >> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> >> > index bbb5294..901c82b 100644
>> >> > --- a/fs/cifs/cifsfs.c
>> >> > +++ b/fs/cifs/cifsfs.c
>> >> > @@ -598,12 +598,44 @@ static ssize_t cifs_file_aio_read(struct =
kiocb *iocb, const struct iovec *iov,
>> >> > =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const=
 struct iovec *iov,
>> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
unsigned long nr_segs, loff_t pos)
>> >> > =A0{
>> >> > - =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d_i=
node;
>> >> > + =A0 struct inode *inode;
>> >> > + =A0 struct cifs_sb_info *cifs_sb;
>> >> > =A0 =A0 ssize_t written;
>> >> >
>> >> > - =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, po=
s);
>> >> > - =A0 if (!CIFS_I(inode)->clientCanCacheAll)
>> >> > - =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
>> >> > + =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
>> >> > +
>> >> > + =A0 if (CIFS_I(inode)->clientCanCacheAll)
>> >> > + =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov, =
nr_segs, pos);
>> >> > +
>> >> > + =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb);
>> >> > +
>> >> > + =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=3D=
 0) {
>> >> > + =A0 =A0 =A0 =A0 =A0 int rc;
>> >> > +
>> >> > + =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, =
iov, nr_segs, pos);
>> >> > +
>> >> > + =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mappin=
g);
>> >> > + =A0 =A0 =A0 =A0 =A0 if (rc)
>> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_file_aio_wr=
ite: %d rc on %p inode",
>> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc, inode);
>> >> > + =A0 =A0 =A0 =A0 =A0 return written;
>> >> > + =A0 }
>> >> > +
>> >> > + =A0 /* in strict cache mode we need to write the data to the =
server exactly
>> >> > + =A0 =A0 =A0from the pos to pos+len-1 rather than flush all af=
fected pages
>> >> > + =A0 =A0 =A0because it may cause a error with mandatory locks =
on these pages but
>> >> > + =A0 =A0 =A0not on the region from pos to ppos+len-1 */
>> >>
>> >> =A0 =A0 =A0 Again, please fix the comment style. Here: ^^^^
>> >>
>> >> > + =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_base,
>> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov->=
iov_len, &pos);
>> >> > +
>> >> > + =A0 iocb->ki_pos =3D pos;
>> >> > +
>> >> > + =A0 /* if we were successful - invalidate inode pages the wri=
te affected */
>> >> > + =A0 if (written > 0)
>> >> > + =A0 =A0 =A0 =A0 =A0 invalidate_mapping_pages(inode->i_mapping=
,
>> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 (pos-written) >> PAGE_CACHE_SHIFT,
>> >> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 (pos-1) >> PAGE_CACHE_SHIFT);
>> >> > +
>> >> > =A0 =A0 return written;
>> >> > =A0}
>> >> >
>> >>
>> >> May god have mercy on anyone who tries to mix strictcache and mma=
p.
>> >>
>> >> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>> > (cc'ing Suresh so he can comment)
>> >
>> > Actually...I'm going to withdraw my Reviewed-by tag here for now. =
This
>> > bare invalidate_mapping_pages doesn't deal with fscache.
>> >
>> > I think I need to understand what's intended when someone specifie=
s
>> > strictcache and fsc before I can ack this. The simple answer would=
 be
>> > that they are mutually exclusive, but if that's the case then the =
patch
>> > that adds the mount option needs to deal with that appropriately.
>>
>>
>> I don't think they can live together. I think we should do smth like=
 a
>> following in mount options parsing:
>>
>> ...
>> if (opt =3D=3D fscache) {
>> =A0 =A0vol->fscahe =3D 1;
>> =A0 =A0vol->strictcache =3D 0;
>> }
>> ...
>> if (opt =3D=3D strictcache) {
>> =A0 vol->strictcache =3D 1;
>> =A0 vol->fscache =3D 0;
>> }
>>
>> So, if user specify both only the last will affect the client
>> behavior. Also we should add this information into cifs manpage.
>> Thoughts?
>>
>
> That would one way to deal with it.
>
> On the other hand though...fscache allows you to keep more data cache=
d
> than you have RAM. This could be useful in a strictcache situation as
> well. Consider the case of an application on a client that has a lot =
of
> large files open for read. The server may grant oplocks on all of the=
m.
> fscache would allow for fewer round trips to the server in such a cas=
e.
>
> So, another way to deal with it would be to simply invalidate the
> fscache whenever you'd invalidate the in-ram cache. I'm not sure what
> to do for the cifs_file_aio_write case where you're invalidating just=
 a
> small range however.
>

According to the idea that we can't keep read oplock and writing to
the server in the same time, I think we can simply call
cifs_invalidate_mapping or even set invalidate_mapping flag on inode.

--=20
Best regards,
Pavel Shilovsky.
