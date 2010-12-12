From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/13] cifs: move mid result processing into common function
Date: Sun, 12 Dec 2010 17:29:58 -0600
Message-ID: <AANLkTimGiESxGU4qnQ2fX+xTJw94BR5PspMp981VKKe-@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Dec 10, 2010 at 9:44 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0131 ++++++++++++++++++-------------------=
-------------
> =A01 files changed, 47 insertions(+), 84 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 9763f89..2d21bbd 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -382,6 +382,46 @@ SendReceiveNoRsp(const unsigned int xid, struct =
cifsSesInfo *ses,
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +static int
> +handle_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *s=
erver)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> +
> + =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> +
> + =A0 =A0 =A0 if (mid->resp_buf) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 cERROR(1, "No response to cmd %d mid %d", mid->command,=
 mid->mid);
> + =A0 =A0 =A0 if (mid->midState =3D=3D MID_REQUEST_SUBMITTED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsExitin=
g)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EHOSTDOWN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->tcpStatus =3D C=
ifsNeedReconnect;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid->midState =3D MID_R=
ETRY_NEEDED;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (rc !=3D -EHOSTDOWN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid->midState =3D=3D MID_RETRY_NEED=
ED) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "marking reques=
t for retry");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;

I think this else part is redundant.  If rc is not EHOSTDOWN,
which means it is 0, midState will always be MID_RETRY_NEEDED.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> +
> + =A0 =A0 =A0 DeleteMidQEntry(mid);
> + =A0 =A0 =A0 /* Update # of requests on wire to server */
> + =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 wake_up(&server->request_q);
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int
> =A0SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, int n_vec, int *pRespBufTyp=
e /* ret */,
> @@ -485,37 +525,10 @@ SendReceive2(const unsigned int xid, struct cif=
sSesInfo *ses,
> =A0 =A0 =A0 =A0/* No user interrupts in wait - wreaks havoc with perf=
ormance */
> =A0 =A0 =A0 =A0wait_for_response(ses, midQ, timeout, 10 * HZ);
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> -
> - =A0 =A0 =A0 if (midQ->resp_buf =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No response to cmd %d mid %d=
",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->command, midQ->mi=
d);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D MID_REQUEST_S=
UBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tcpSta=
tus =3D=3D CifsExiting)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
rver->tcpStatus =3D CifsNeedReconnect;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->m=
idState =3D MID_RETRY_NEEDED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D -EHOSTDOWN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D=
 MID_RETRY_NEEDED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EAGAIN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "marking request for retry");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 DeleteMidQEntry(midQ);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serv=
er */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> + =A0 =A0 =A0 rc =3D handle_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0receive_len =3D midQ->resp_buf->smb_buf_length;
>
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> @@ -677,36 +690,10 @@ SendReceive(const unsigned int xid, struct cifs=
SesInfo *ses,
> =A0 =A0 =A0 =A0/* No user interrupts in wait - wreaks havoc with perf=
ormance */
> =A0 =A0 =A0 =A0wait_for_response(ses, midQ, timeout, 10 * HZ);
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 if (midQ->resp_buf =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No response for cmd %d mid %=
d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->command, midQ=
->mid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D MID_REQUEST_S=
UBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tcpSta=
tus =3D=3D CifsExiting)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
rver->tcpStatus =3D CifsNeedReconnect;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->m=
idState =3D MID_RETRY_NEEDED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D -EHOSTDOWN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D=
 MID_RETRY_NEEDED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EAGAIN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "marking request for retry");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 DeleteMidQEntry(midQ);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serv=
er */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> + =A0 =A0 =A0 rc =3D handle_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0receive_len =3D midQ->resp_buf->smb_buf_length;
>
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> @@ -926,35 +913,11 @@ SendReceiveBlockingLock(const unsigned int xid,=
 struct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 if (midQ->resp_buf) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 receive_len =3D midQ->resp_buf->smb_buf=
_length;
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "No response for cmd %d mid %=
d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->command, midQ=
->mid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D MID_REQUEST_S=
UBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->server->tcpSta=
tus =3D=3D CifsExiting)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
rver->tcpStatus =3D CifsNeedReconnect;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->m=
idState =3D MID_RETRY_NEEDED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D -EHOSTDOWN) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D=
 MID_RETRY_NEEDED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EAGAIN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "marking request for retry");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
-EIO;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 DeleteMidQEntry(midQ);
> + =A0 =A0 =A0 rc =3D handle_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> - =A0 =A0 =A0 }
>
> + =A0 =A0 =A0 receive_len =3D midQ->resp_buf->smb_buf_length;
> =A0 =A0 =A0 =A0if (receive_len > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "Frame too large received. =A0=
Length: %d =A0Xid: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0receive_len, xid);
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
