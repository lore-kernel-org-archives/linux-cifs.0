From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: New write logic
Date: Tue, 2 Nov 2010 10:56:37 +0300
Message-ID: <AANLkTikUUQ4WkdGOoZsrCtMF0=faf-sARKgCd04q7S8k@mail.gmail.com>
References: <AANLkTik_nAUgsEXC6q2rRnSgbE3_L--zVcmWOWyVY578@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik_nAUgsEXC6q2rRnSgbE3_L--zVcmWOWyVY578-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/31 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Modify cifs_file_aio_write and cifs_write_end to let the client works=
 with
> strict cache mode.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 35 ++++++++++++++++++++++++++++++-----
> =A0fs/cifs/file.c =A0 | =A0 14 ++++++++++++--
> =A02 files changed, 42 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 21e0f47..85042e4 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -603,12 +603,37 @@ static ssize_t cifs_file_aio_read(struct kiocb
> *iocb, const struct iovec *iov,
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
> + =A0 =A0 =A0 ssize_t written, cache_written;
> + =A0 =A0 =A0 loff_t saved_pos;
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written =3D generic_file_aio_write(iocb=
, iov, nr_segs, pos);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_write_and_wait(inode->i_mapping=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return written;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 saved_pos =3D pos;
> + =A0 =A0 =A0 written =3D cifs_user_write(iocb->ki_filp, iov->iov_bas=
e,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov=
->iov_len, &pos);
> +
> + =A0 =A0 =A0 if (written > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cache_written =3D generic_file_aio_writ=
e(iocb, iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr_segs, saved_pos);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cache_written !=3D written)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Cache writte=
n and server written data "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"lengths=
 are different");
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
>
> - =A0 =A0 =A0 written =3D generic_file_aio_write(iocb, iov, nr_segs, =
pos);
> - =A0 =A0 =A0 if (!CIFS_I(inode)->clientCanCacheAll)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 filemap_fdatawrite(inode->i_mapping);
> =A0 =A0 =A0 =A0return written;
> =A0}
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0f63978..b580f71 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1550,7 +1550,11 @@ static int cifs_write_end(struct file *file,
> struct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct page *page, voi=
d *fsdata)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> - =A0 =A0 =A0 struct inode *inode =3D mapping->host;
> + =A0 =A0 =A0 struct inode *inode;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> +
> + =A0 =A0 =A0 inode =3D mapping->host;
> + =A0 =A0 =A0 cifs_sb =3D CIFS_SB(inode->i_sb);
>
> =A0 =A0 =A0 =A0cFYI(1, "write_end for page %p from pos %lld with %d b=
ytes",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 page, pos, copied);
> @@ -1583,7 +1587,13 @@ static int cifs_write_end(struct file *file,
> struct address_space *mapping,
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D copied;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pos +=3D copied;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if we have strict cache switched on =
and don't have Exclusive
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock for the inode, we don't h=
ave to set_page_dirty
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0because we flushed the data to t=
he server in
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file_aio_write before */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_STRICT_IO) =3D=3D 0 ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->clientCanCacheAl=
l)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_page_dirty(page);
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (rc > 0) {
> --
> 1.7.2.3
>

What's about it?

--=20
Best regards,
Pavel Shilovsky.
