From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] CIFS: Make read call work with strict cache mode (try #3)
Date: Tue, 30 Nov 2010 10:43:42 +0300
Message-ID: <AANLkTikTYD-_Mz-3f_ZeBkfZxh2UKErtTj+GwO6u1_yF@mail.gmail.com>
References: <1291037804-4000-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291037804-4000-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/29 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Add cifs_file_aio_read where we read from the cache if we have at lea=
st
> Level II oplock - otherwise read from the server.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 42 ++++++++++++++++++++++++++++++++++++++++=
--
> =A01 files changed, 40 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 9c37897..431c46e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -568,6 +568,44 @@ cifs_do_mount(struct file_system_type *fs_type,
> =A0 =A0 =A0 =A0return dget(sb->s_root);
> =A0}
>
> +static ssize_t cifs_file_aio_read(struct kiocb *iocb, const struct i=
ovec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uns=
igned long nr_segs, loff_t pos)
> +{
> + =A0 =A0 =A0 struct inode *inode;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> + =A0 =A0 =A0 ssize_t read =3D 0, retval;
> + =A0 =A0 =A0 unsigned long i;
> +
> + =A0 =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
> + =A0 =A0 =A0 cifs_sb =3D CIFS_SB(iocb->ki_filp->f_path.dentry->d_sb)=
;
> +
> + =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) =3D=
=3D 0 ||
> + =A0 =A0 =A0 =A0 =A0 CIFS_I(inode)->clientCanCacheRead)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_read(iocb, iov,=
 nr_segs, pos);
> +
> + =A0 =A0 =A0 /* In strict cache mode we need to read from the server=
 all the time
> + =A0 =A0 =A0 =A0* if we don't have level II oplock because the serve=
r can delay mtime
> + =A0 =A0 =A0 =A0* change - so we can't make a decision about inode i=
nvalidating.
> + =A0 =A0 =A0 =A0* And we can also fail with pagereading if there are=
 mandatory locks
> + =A0 =A0 =A0 =A0* on pages affected by this read but not on the regi=
on from pos to
> + =A0 =A0 =A0 =A0* pos+len-1. */
> +
> + =A0 =A0 =A0 for (i =3D 0; i < nr_segs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D cifs_user_read(iocb->ki_filp=
, iov[i].iov_base,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 iov[i].iov_len, &pos);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retval < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read =3D read ? read : =
retval;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 read +=3D retval;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 iocb->ki_pos =3D pos;
> +
> + =A0 =A0 =A0 return read;
> +}
> +
> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u=
nsigned long nr_segs, loff_t pos)
> =A0{
> @@ -690,7 +728,7 @@ const struct inode_operations cifs_symlink_inode_=
ops =3D {
> =A0const struct file_operations cifs_file_ops =3D {
> =A0 =A0 =A0 =A0.read =3D do_sync_read,
> =A0 =A0 =A0 =A0.write =3D do_sync_write,
> - =A0 =A0 =A0 .aio_read =3D generic_file_aio_read,
> + =A0 =A0 =A0 .aio_read =3D cifs_file_aio_read,
> =A0 =A0 =A0 =A0.aio_write =3D cifs_file_aio_write,
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> @@ -727,7 +765,7 @@ const struct file_operations cifs_file_direct_ops=
 =3D {
> =A0const struct file_operations cifs_file_nobrl_ops =3D {
> =A0 =A0 =A0 =A0.read =3D do_sync_read,
> =A0 =A0 =A0 =A0.write =3D do_sync_write,
> - =A0 =A0 =A0 .aio_read =3D generic_file_aio_read,
> + =A0 =A0 =A0 .aio_read =3D cifs_file_aio_read,
> =A0 =A0 =A0 =A0.aio_write =3D cifs_file_aio_write,
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> --
> 1.7.3.2
>
>

Just found out that comment style don't match CodingStyle again. Let's
drop with version. The same for write patch.

--=20
Best regards,
Pavel Shilovsky.
