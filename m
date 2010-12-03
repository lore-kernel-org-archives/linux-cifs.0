From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/6] CIFS: Make write call work with strict cache mode
 (try #4)
Date: Fri, 3 Dec 2010 10:01:15 +0300
Message-ID: <AANLkTikgXCMh8Ny00Y3NKQ3M=ffkts9LR2aKHqpH-QV0@mail.gmail.com>
References: <1291103671-2983-1-git-send-email-piastryyy@gmail.com>
	<1291103671-2983-2-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291103671-2983-2-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/30 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On strict cache mode if we don't have Exclusive oplock we write a dat=
a to
> the server through cifs_user_write. Then if we Level II oplock store =
it in
> the cache, otherwise - invalidate inode pages affected by this writin=
g.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 51 ++++++++++++++++++++++++++++++++++++++++=
++++++-----
> =A01 files changed, 46 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 370acdc..df17261 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -611,12 +611,53 @@ static ssize_t cifs_file_aio_read(struct kiocb =
*iocb, const struct iovec *iov,
> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u=
nsigned long nr_segs, loff_t pos)
> =A0{
> - =A0 =A0 =A0 struct inode *inode =3D iocb->ki_filp->f_path.dentry->d=
_inode;
> - =A0 =A0 =A0 ssize_t written;
> + =A0 =A0 =A0 struct inode *inode;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> + =A0 =A0 =A0 ssize_t written =3D 0, retval;
> + =A0 =A0 =A0 unsigned long i;
> +
> + =A0 =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
> +
> + =A0 =A0 =A0 if (CIFS_I(inode)->clientCanCacheAll)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_write(iocb, iov=
, nr_segs, pos);
> +
> + =A0 =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb)=
;
> +
> + =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=
=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int rc;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb=
, iov, nr_segs, pos);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mapp=
ing);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_file_aio_=
write: %d rc on %p inode",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc, inode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return written;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* In strict cache mode we need to write the data to =
the server exactly
> + =A0 =A0 =A0 =A0* from the pos to pos+len-1 rather than flush all af=
fected pages
> + =A0 =A0 =A0 =A0* because it may cause a error with mandatory locks =
on these pages but
> + =A0 =A0 =A0 =A0* not on the region from pos to ppos+len-1.
> + =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 for (i =3D 0; i < nr_segs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_user_write(iocb->ki_fil=
p, iov[i].iov_base,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0iov[i].iov_len, &pos);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 written =3D written ? w=
ritten : retval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written +=3D retval;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 iocb->ki_pos =3D pos;
> +
> + =A0 =A0 =A0 if (written > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->invalid_mapping =3D true=
;
>
> - =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, =
pos);
> - =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
> =A0 =A0 =A0 =A0return written;
> =A0}
>
> --
> 1.7.3.2
>
>

What's about this one and read patch #4? fsync and mmap patches #3?


--=20
Best regards,
Pavel Shilovsky.
