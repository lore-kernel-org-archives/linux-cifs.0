From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix offset handling in cifs_iovec_write
Date: Thu, 19 Apr 2012 22:22:25 -0500
Message-ID: <CAH2r5mvT99z8tEX=Fw0pYwb0EcKWjHr+nhBb0njvm5bsUg3yzA@mail.gmail.com>
References: <1334351819-29402-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1334351819-29402-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Fri, Apr 13, 2012 at 4:16 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> In the recent update of the cifs_iovec_write code to use async writes=
,
> the handling of the file position was broken. That patch added a loca=
l
> "offset" variable to handle the offset, and then only updated the
> original "*poffset" before exiting.
>
> Unfortunately, it copied off the original offset from the beginning,
> instead of doing so after generic_write_checks had been called. Fix
> this by moving the initialization of "offset" after that in the
> function.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index fae765d..81725e9 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2178,7 +2178,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0unsigned long nr_pages, i;
> =A0 =A0 =A0 =A0size_t copied, len, cur_len;
> =A0 =A0 =A0 =A0ssize_t total_written =3D 0;
> - =A0 =A0 =A0 loff_t offset =3D *poffset;
> + =A0 =A0 =A0 loff_t offset;
> =A0 =A0 =A0 =A0struct iov_iter it;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> @@ -2200,6 +2200,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(open_file->tlink);
> + =A0 =A0 =A0 offset =3D *poffset;
>
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D open_file->pid;
> --
> 1.7.7.6
>



--=20
Thanks,

Steve
