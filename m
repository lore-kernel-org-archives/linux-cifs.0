From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 1/8] cifs: add pid field to cifs_writedata
Date: Tue, 21 Feb 2012 11:42:51 +0400
Message-ID: <CAKywueTpGWBB2uUfqLDf+qReFgOT1cgz9s-KuCPYX_ajxd8_GA@mail.gmail.com>
References: <1328279581-21889-1-git-send-email-jlayton@redhat.com>
	<1328279581-21889-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1328279581-21889-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We'll need this to handle rwpidforward option correctly when we use
> async writes in the aio_write op.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsproto.h | =A0 =A01 +
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 ++--
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A01 +
> =A03 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index a81549d..2778605 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -477,6 +477,7 @@ struct cifs_writedata {
> =A0 =A0 =A0 =A0struct work_struct =A0 =A0 =A0 =A0 =A0 =A0 =A0work;
> =A0 =A0 =A0 =A0struct cifsFileInfo =A0 =A0 =A0 =A0 =A0 =A0 *cfile;
> =A0 =A0 =A0 =A0__u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 offset;
> + =A0 =A0 =A0 pid_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 pid;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0by=
tes;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 result;
> =A0 =A0 =A0 =A0unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nr=
_pages;
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index cf12c0c..9525ae3 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -2122,8 +2122,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto async_writev_out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 smb->hdr.Pid =3D cpu_to_le16((__u16)wdata->cfile->pid);
> - =A0 =A0 =A0 smb->hdr.PidHigh =3D cpu_to_le16((__u16)(wdata->cfile->=
pid >> 16));
> + =A0 =A0 =A0 smb->hdr.Pid =3D cpu_to_le16((__u16)wdata->pid);
> + =A0 =A0 =A0 smb->hdr.PidHigh =3D cpu_to_le16((__u16)(wdata->pid >> =
16));
>
> =A0 =A0 =A0 =A0smb->AndXCommand =3D 0xFF; =A0 =A0 =A0 =A0/* none */
> =A0 =A0 =A0 =A0smb->Fid =3D wdata->cfile->netfid;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4dd9283..ffbb2b4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1758,6 +1758,7 @@ retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wdata->pid =3D wdata->c=
file->pid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_async_writ=
ev(wdata);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (wbc->sync_mode =3D=3D WB_SYNC=
_ALL && rc =3D=3D -EAGAIN);
>
> --
> 1.7.7.6
>

Looks good.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
