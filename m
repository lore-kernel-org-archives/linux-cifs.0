From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 3/8] cifs: rename pTcon to tcon in cifs_iovec_write
Date: Tue, 21 Feb 2012 11:44:04 +0400
Message-ID: <CAKywueS0AB9kQAw5CBt7CdNTY8+tFCLRdTZmiomCaj5Hyb0vYA@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A09 ++++-----
> =A01 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5e758d8..febf32e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2051,9 +2051,8 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0struct iov_iter it;
> =A0 =A0 =A0 =A0struct inode *inode;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> - =A0 =A0 =A0 struct cifs_tcon *pTcon;
> + =A0 =A0 =A0 struct cifs_tcon *tcon;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifs_io_parms io_parms;
> =A0 =A0 =A0 =A0int xid, rc;
> =A0 =A0 =A0 =A0__u32 pid;
>
> @@ -2093,7 +2092,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D current->tgid;
>
> - =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
> + =A0 =A0 =A0 tcon =3D tlink_tcon(open_file->tlink);
> =A0 =A0 =A0 =A0inode =3D file->f_path.dentry->d_inode;
>
> =A0 =A0 =A0 =A0iov_iter_init(&it, iov, nr_segs, len, 0);
> @@ -2121,7 +2120,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io_parms.netfid =3D op=
en_file->netfid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io_parms.pid =3D pid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D pTcon=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 io_parms.tcon =3D tcon;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io_parms.offset =3D *p=
offset;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0io_parms.length =3D cu=
r_len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBWrite2(x=
id, &io_parms, &written, to_send,
> @@ -2153,7 +2152,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&inode->i_lock);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 cifs_stats_bytes_written(pTcon, total_written);
> + =A0 =A0 =A0 cifs_stats_bytes_written(tcon, total_written);
> =A0 =A0 =A0 =A0mark_inode_dirty_sync(inode);
>
> =A0 =A0 =A0 =A0for (i =3D 0; i < num_pages; i++)
> --
> 1.7.7.6
>

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
