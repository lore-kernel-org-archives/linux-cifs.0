From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove bogus call to cifs_cleanup_volume_info
Date: Tue, 5 Jul 2011 22:14:02 -0500
Message-ID: <CAH2r5mtL-PhyxbG2_8+kxBnJD0Jn33ynH7KF3oDUo3Do8Uy1eA@mail.gmail.com>
References: <1309901857-32016-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309901857-32016-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Tue, Jul 5, 2011 at 4:37 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This call to cifs_cleanup_volume_info is clearly wrong. As soon as it=
's
> called the following call to cifs_get_tcp_session will oops as the
> volume_info pointer will then be NULL.
>
> The caller of cifs_mount should clean up this data since it passed it
> in. There's no need for us to call this here.
>
> Regression introduced by commit 724d9f1cfba.
>
> Reported-by: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A01 -
> =A01 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c8cb83e..545e854 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3012,7 +3012,6 @@ try_mount_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else if (pSesInfo)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_put_smb_ses(pSesI=
nfo);
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0}
> =A0#endif
> --
> 1.7.6
>
>



--=20
Thanks,

Steve
