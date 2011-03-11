From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: directio read/write cleanups
Date: Thu, 10 Mar 2011 20:42:34 -0600
Message-ID: <AANLkTikKr9Zkn0oD1DK=PN23QFR2wRg4UXh90mky+d36@mail.gmail.com>
References: <1299751865-2741-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299751865-2741-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Seems useful/promising - any informal before/after performance data.
Do you expect it to affect performance?

On Thu, Mar 10, 2011 at 4:11 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> Recently introduced strictcache mode brought a new code that can be
> efficiently used by directio part. That's let us add vectored operati=
ons
> and break unnecessary cifs_user_read and cifs_user_write.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 18 +++++----
> =A0fs/cifs/cifsfs.h | =A0 =A08 ++--
> =A0fs/cifs/file.c =A0 | =A0103 +-------------------------------------=
---------------
> =A03 files changed, 16 insertions(+), 113 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 120a9cf..77c2989 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -763,10 +763,11 @@ const struct file_operations cifs_file_strict_o=
ps =3D {
> =A0};
>
> =A0const struct file_operations cifs_file_direct_ops =3D {
> - =A0 =A0 =A0 /* no aio, no readv -
> - =A0 =A0 =A0 =A0 =A0BB reevaluate whether they can be done with dire=
ctio, no cache */
> - =A0 =A0 =A0 .read =3D cifs_user_read,
> - =A0 =A0 =A0 .write =3D cifs_user_write,
> + =A0 =A0 =A0 /* BB reevaluate whether they can be done with directio=
, no cache */
> + =A0 =A0 =A0 .read =3D do_sync_read,
> + =A0 =A0 =A0 .write =3D do_sync_write,
> + =A0 =A0 =A0 .aio_read =3D cifs_user_readv,
> + =A0 =A0 =A0 .aio_write =3D cifs_user_writev,
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> =A0 =A0 =A0 =A0.lock =3D cifs_lock,
> @@ -818,10 +819,11 @@ const struct file_operations cifs_file_strict_n=
obrl_ops =3D {
> =A0};
>
> =A0const struct file_operations cifs_file_direct_nobrl_ops =3D {
> - =A0 =A0 =A0 /* no mmap, no aio, no readv -
> - =A0 =A0 =A0 =A0 =A0BB reevaluate whether they can be done with dire=
ctio, no cache */
> - =A0 =A0 =A0 .read =3D cifs_user_read,
> - =A0 =A0 =A0 .write =3D cifs_user_write,
> + =A0 =A0 =A0 /* BB reevaluate whether they can be done with directio=
, no cache */
> + =A0 =A0 =A0 .read =3D do_sync_read,
> + =A0 =A0 =A0 .write =3D do_sync_write,
> + =A0 =A0 =A0 .aio_read =3D cifs_user_readv,
> + =A0 =A0 =A0 .aio_write =3D cifs_user_writev,
> =A0 =A0 =A0 =A0.open =3D cifs_open,
> =A0 =A0 =A0 =A0.release =3D cifs_close,
> =A0 =A0 =A0 =A0.fsync =3D cifs_fsync,
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 371d021..bb64313 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -80,12 +80,12 @@ extern const struct file_operations cifs_file_str=
ict_nobrl_ops;
> =A0extern int cifs_open(struct inode *inode, struct file *file);
> =A0extern int cifs_close(struct inode *inode, struct file *file);
> =A0extern int cifs_closedir(struct inode *inode, struct file *file);
> -extern ssize_t cifs_user_read(struct file *file, char __user *read_d=
ata,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t read=
_size, loff_t *poffset);
> +extern ssize_t cifs_user_readv(struct kiocb *iocb, const struct iove=
c *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned=
 long nr_segs, loff_t pos);
> =A0extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct =
iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsig=
ned long nr_segs, loff_t pos);
> -extern ssize_t cifs_user_write(struct file *file, const char __user =
*write_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t w=
rite_size, loff_t *poffset);
> +extern ssize_t cifs_user_writev(struct kiocb *iocb, const struct iov=
ec *iov,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigne=
d long nr_segs, loff_t pos);
> =A0extern ssize_t cifs_strict_writev(struct kiocb *iocb, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0un=
signed long nr_segs, loff_t pos);
> =A0extern int cifs_lock(struct file *, int, struct file_lock *);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9293ff2..b9731c9 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -855,95 +855,6 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, lof=
f_t offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsi->server_eof =3D end_of_write;
> =A0}
>
> -ssize_t cifs_user_write(struct file *file, const char __user *write_=
data,
> - =A0 =A0 =A0 size_t write_size, loff_t *poffset)
> -{
> - =A0 =A0 =A0 struct inode *inode =3D file->f_path.dentry->d_inode;
> - =A0 =A0 =A0 int rc =3D 0;
> - =A0 =A0 =A0 unsigned int bytes_written =3D 0;
> - =A0 =A0 =A0 unsigned int total_written;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifs_tcon *pTcon;
> - =A0 =A0 =A0 int xid;
> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
> - =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> -
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> -
> - =A0 =A0 =A0 /* cFYI(1, " write %d bytes to offset %lld of %s", writ=
e_size,
> - =A0 =A0 =A0 =A0 =A0*poffset, file->f_path.dentry->d_name.name); */
> -
> - =A0 =A0 =A0 if (file->private_data =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EBADF;
> -
> - =A0 =A0 =A0 open_file =3D file->private_data;
> - =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
> -
> - =A0 =A0 =A0 rc =3D generic_write_checks(file, poffset, &write_size,=
 0);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> -
> - =A0 =A0 =A0 xid =3D GetXid();
> -
> - =A0 =A0 =A0 for (total_written =3D 0; write_size > total_written;
> - =A0 =A0 =A0 =A0 =A0 =A0total_written +=3D bytes_written) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (rc =3D=3D -EAGAIN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (file->private_data =
=3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* file=
 has been closed on us */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid=
(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if we have gotten he=
re we have written some data
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and blocked, and=
 the file has been freed on us while
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0we blocked so re=
turn what we managed to write */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
total_written;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (open_file->invalidH=
andle) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we c=
ould deadlock if we called
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
filemap_fdatawait from here so tell
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
reopen_file not to flush data to server
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
now */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
cifs_reopen_file(open_file, false);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =
!=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid=
, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_fi=
le->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 min_t(c=
onst int, cifs_sb->wsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 write_size - total_written),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffse=
t, &bytes_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, w=
rite_data + total_written, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_written =3D=3D 0)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_written)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid=
(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rc;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_update_eof(cifsi, =
*poffset, bytes_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D bytes_wri=
tten;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 cifs_stats_bytes_written(pTcon, total_written);
> -
> -/* Do not update local mtime - server will set its actual value on w=
rite
> - * =A0 =A0 inode->i_ctime =3D inode->i_mtime =3D
> - * =A0 =A0 =A0 =A0 =A0 =A0 current_fs_time(inode->i_sb);*/
> - =A0 =A0 =A0 if (total_written > 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&inode->i_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*poffset > inode->i_size)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_size_write(inode, *po=
ffset);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&inode->i_lock);
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 mark_inode_dirty_sync(inode);
> -
> - =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 return total_written;
> -}
> -
> =A0static ssize_t cifs_write(struct cifsFileInfo *open_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *write_=
data, size_t write_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t *poffset)
> @@ -1772,7 +1683,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0return total_written;
> =A0}
>
> -static ssize_t cifs_user_writev(struct kiocb *iocb, const struct iov=
ec *iov,
> +ssize_t cifs_user_writev(struct kiocb *iocb, const struct iovec *iov=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsign=
ed long nr_segs, loff_t pos)
> =A0{
> =A0 =A0 =A0 =A0ssize_t written;
> @@ -1895,17 +1806,7 @@ cifs_iovec_read(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0return total_read;
> =A0}
>
> -ssize_t cifs_user_read(struct file *file, char __user *read_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t read_size, loff_t=
 *poffset)
> -{
> - =A0 =A0 =A0 struct iovec iov;
> - =A0 =A0 =A0 iov.iov_base =3D read_data;
> - =A0 =A0 =A0 iov.iov_len =3D read_size;
> -
> - =A0 =A0 =A0 return cifs_iovec_read(file, &iov, 1, poffset);
> -}
> -
> -static ssize_t cifs_user_readv(struct kiocb *iocb, const struct iove=
c *iov,
> +ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned =
long nr_segs, loff_t pos)
> =A0{
> =A0 =A0 =A0 =A0ssize_t read;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
