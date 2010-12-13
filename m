From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 02/13] cifs: make wait_for_free_request take a
 TCP_Server_Info pointer
Date: Mon, 13 Dec 2010 23:03:05 +0300
Message-ID: <AANLkTim-uJSgf0Z2J333QZ6UKtFWZGfBKyq41rcYoa0n@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The cifsSesInfo pointer is only used to get at the server.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0 26 +++++++++++++-------------
> =A01 files changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e0588cd..9763f89 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -244,31 +244,31 @@ smb_send(struct TCP_Server_Info *server, struct=
 smb_hdr *smb_buffer,
> =A0 =A0 =A0 =A0return smb_sendv(server, &iov, 1);
> =A0}
>
> -static int wait_for_free_request(struct cifsSesInfo *ses, const int =
long_op)
> +static int wait_for_free_request(struct TCP_Server_Info *server,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t int long_op)
> =A0{
> =A0 =A0 =A0 =A0if (long_op =3D=3D CIFS_ASYNC_OP) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* oplock breaks must not be held up *=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->inFlight);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0while (1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&ses->server->inFlight)=
 >=3D
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_ma=
x_pending){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D=
 cifs_max_pending) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0#ifdef CONFIG_CIFS_STATS2
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server=
->num_waiters);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->num=
_waiters);
> =A0#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(ses->server-=
>request_q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
atomic_read(&ses->server->inFlight)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->requ=
est_q,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
atomic_read(&server->inFlight)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 < cifs_max_pending);
> =A0#ifdef CONFIG_CIFS_STATS2
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server=
->num_waiters);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->num=
_waiters);
> =A0#endif
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_L=
ock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tcpSta=
tus =3D=3D CifsExiting) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=
=3D CifsExiting) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_u=
nlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 -ENOENT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -278,7 +278,7 @@ static int wait_for_free_request(struct cifsSesIn=
fo *ses, const int long_op)
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* update # of request=
s on the wire to server */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (long_op !=3D CIFS_=
BLOCKING_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
inc(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
inc(&server->inFlight);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -413,7 +413,7 @@ SendReceive2(const unsigned int xid, struct cifsS=
esInfo *ses,
> =A0 =A0 =A0 =A0 =A0 to the same server. We may make this configurable=
 later or
> =A0 =A0 =A0 =A0 =A0 use ses->maxReq */
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses, long_op);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> @@ -610,7 +610,7 @@ SendReceive(const unsigned int xid, struct cifsSe=
sInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses, long_op);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -845,7 +845,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses, CIFS_BLOCKING_OP);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING=
_OP);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> --
> 1.7.3.2


Good cleanup.
Reviewed-by:  Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
