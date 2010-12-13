From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 05/13] cifs: don't reconnect server when we don't get a response
Date: Mon, 13 Dec 2010 23:06:05 +0300
Message-ID: <AANLkTi=dSWHbG7whfqo=c5p6C9496A1kQf_3pwRPVYvE@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-6-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-6-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> We only want to force a reconnect to the server under very limited an=
d
> specific circumstances. Now that we have processes waiting indefinite=
ly
> for responses, we shouldn't reach this point unless a reconnect is
> already in process. Thus, there's no reason to re-mark the server for
> reconnect here.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0 =A04 +---
> =A01 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 989674c..0c0dadd 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -367,10 +367,8 @@ handle_mid_result(struct mid_q_entry *mid, struc=
t TCP_Server_Info *server)
> =A0 =A0 =A0 =A0if (mid->midState =3D=3D MID_REQUEST_SUBMITTED) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus =3D=3D CifsExiti=
ng)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D C=
ifsNeedReconnect;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->midState =3D MID_=
RETRY_NEEDED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (rc !=3D -EHOSTDOWN) {
> --
> 1.7.3.2
>


Reviewed-by:  Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
