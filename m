From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add missing initialization of server->req_lock
Date: Wed, 2 May 2012 09:02:07 +0400
Message-ID: <CAKywueRYg55-3LjwEVH_gDNY-hbwBzhpLoSgL5pQnfNbJ7CUFg@mail.gmail.com>
References: <1335908324-16593-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1335908324-16593-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/5/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index f4d381e..18c5d52 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2183,6 +2183,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0tcp_ses->session_estab =3D false;
> =A0 =A0 =A0 =A0tcp_ses->sequence_number =3D 0;
> =A0 =A0 =A0 =A0tcp_ses->lstrp =3D jiffies;
> + =A0 =A0 =A0 spin_lock_init(&tcp_ses->req_lock);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
> =A0 =A0 =A0 =A0INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> --
> 1.7.7.6
>

That's my fault. Thanks for fixing this!
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
