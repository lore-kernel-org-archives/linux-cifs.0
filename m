From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: New read cache mechanism
Date: Tue, 28 Sep 2010 13:55:48 -0400
Message-ID: <20100928135548.3c9b1f50@tlielax.poochiereds.net>
References: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=U-4Go7jzMJWQ61j+2v1GXJoMFn5MLUNA4MZ-U-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 27 Sep 2010 22:31:54 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add cifs_sync_read call to provide reading from the cache if we have =
at least
> Level II oplock and otherwise - reading from the server.
>=20
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   26 ++++++++++++++++++++++++--
>  1 files changed, 24 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 898d2a5..a7361ee 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -549,6 +549,28 @@ cifs_get_sb(struct file_system_type *fs_type,
>  	return 0;
>  }
>=20
> +static ssize_t cifs_sync_read(struct file *filp, char __user *buf,
> +			      size_t len, loff_t *ppos)
> +{
> +	ssize_t read;
> +	struct cifsInodeInfo *cinode;
> +	struct cifs_sb_info *cifs_sb;
> +
> +	cifs_sb =3D CIFS_SB(filp->f_path.dentry->d_inode->i_sb);
> +
> +	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO))
> +		return do_sync_read(filp, buf, len, ppos);
> +
> +	cinode =3D CIFS_I(filp->f_path.dentry->d_inode);
> +
> +	if (cinode->clientCanCacheRead)
> +		read =3D do_sync_read(filp, buf, len, ppos);
> +	else
> +		read =3D cifs_user_read(filp, buf, len, ppos);
> +
> +	return read;
> +}
> +
>  static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct =
iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
> @@ -668,7 +690,7 @@ const struct inode_operations cifs_symlink_inode_=
ops =3D {
>  };
>=20
>  const struct file_operations cifs_file_ops =3D {
> -	.read =3D do_sync_read,
> +	.read =3D cifs_sync_read,
>  	.write =3D do_sync_write,
>  	.aio_read =3D generic_file_aio_read,
>  	.aio_write =3D cifs_file_aio_write,
> @@ -705,7 +727,7 @@ const struct file_operations cifs_file_direct_ops=
 =3D {
>  	.setlease =3D cifs_setlease,
>  };
>  const struct file_operations cifs_file_nobrl_ops =3D {
> -	.read =3D do_sync_read,
> +	.read =3D cifs_sync_read,
>  	.write =3D do_sync_write,
>  	.aio_read =3D generic_file_aio_read,
>  	.aio_write =3D cifs_file_aio_write,

Ok, so suppose you make this change and don't change
cifs_file_aio_write at all, and at some point in the future, we make
cifs do async writes...

I go and do a buffered write to a file, cifs_file_aio_write then calls
filemap_fdatawrite to flush out the data, but doesn't necessarily wait
for it to complete before returning.

Now, I do I read from that file descriptor, which ends up being
satisfied before the write I just did got flushed out. I see old
data in the read.

According to the write(2) manpage:

POSIX  requires  that  a  read(2)  which can be proved to occur after a
write() has returned returns the new data.  Note that not all file sys=E2=
=80=90
tems are POSIX conforming.

It's arguable that CIFS isn't POSIX conforming, but we do our best with
it. I think we ought to conform to POSIX in this regard. If you want
to do this, you probably also need to ensure that the dirty data gets
flushed to the server prior to returning from a write call.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
