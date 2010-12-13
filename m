From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 04/13] cifs: wait indefinitely for responses
Date: Mon, 13 Dec 2010 23:04:47 +0300
Message-ID: <AANLkTinTDOx5D1svNrBhtnw0kOgchJ1ZSpgxCUdXxM=s@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> The client should not be timing out on individual SMB requests. Too m=
uch
> of the state between client and server is tied to the state of the
> socket. If we time out requests and issue spurious disconnects then t=
hat
> comprimises data integrity.
>
> Instead of doing this complicated dance where we try to decide how lo=
ng
> to wait for a response for particular requests, have the client inste=
ad
> wait indefinitely for a response. Also, use a TASK_KILLABLE sleep her=
e
> so that fatal signals will break out of this waiting.
>
> Later patches will add support for detecting dead peers and forcing
> reconnects based on that.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0110 ++++++++-----------------------------=
--------------
> =A01 files changed, 17 insertions(+), 93 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 2d21bbd..989674c 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -311,48 +311,17 @@ static int allocate_mid(struct cifsSesInfo *ses=
, struct smb_hdr *in_buf,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static int wait_for_response(struct cifsSesInfo *ses,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entry *mid=
Q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long timeout,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long time_to_w=
ait)
> +static int
> +wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry=
 *midQ)
> =A0{
> - =A0 =A0 =A0 unsigned long curr_timeout;
> -
> - =A0 =A0 =A0 for (;;) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 curr_timeout =3D timeout + jiffies;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event_timeout(ses->server->respons=
e_q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->midState !=3D MID=
_REQUEST_SUBMITTED, timeout);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies, curr_timeout) &=
&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (midQ->midState =3D=3D =
MID_REQUEST_SUBMITTED) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((ses->server->tcpStatu=
s =3D=3D CifsGood) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(ses->server->tcpSta=
tus =3D=3D CifsNew))) {
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long lrt;
> + =A0 =A0 =A0 int error;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* We timed out. Is the=
 server still
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sending replies =
? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lo=
ck);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrt =3D ses->server->ls=
trp;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_=
Lock);
> + =A0 =A0 =A0 error =3D wait_event_killable(server->response_q,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 midQ->midState !=3D MID_REQUEST_SUBMITTED);
> + =A0 =A0 =A0 if (error < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ERESTARTSYS;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Calculate time_to_wa=
it past last receive time.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Although we prefer n=
ot to time out if the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server is still resp=
onding - we will time
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out if the server ta=
kes more than 15 (or 45
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0or 180) seconds to r=
espond to this request
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and has not responde=
d to any request from
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0other threads on the=
 client within 10 seconds */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrt +=3D time_to_wait;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies,=
 lrt)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* No r=
eplies for time_to_wait. */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(=
1, "server not responding");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-1;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> =A0}
>
>
> @@ -430,7 +399,6 @@ SendReceive2(const unsigned int xid, struct cifsS=
esInfo *ses,
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int long_op;
> =A0 =A0 =A0 =A0unsigned int receive_len;
> - =A0 =A0 =A0 unsigned long timeout;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
> =A0 =A0 =A0 =A0struct smb_hdr *in_buf =3D iov[0].iov_base;
>
> @@ -497,33 +465,12 @@ SendReceive2(const unsigned int xid, struct cif=
sSesInfo *ses,
> =A0 =A0 =A0 =A0if (rc < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 if (long_op =3D=3D CIFS_STD_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 15 * HZ;
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_VLONG_OP) /* e.g. slow wri=
tes past EOF */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 180 * HZ;
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_LONG_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 45 * HZ; /* should be great=
er than
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 servers oplock break ti=
meout (about 43 seconds) */
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_ASYNC_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_BLOCKING_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 0x7FFFFFFF; /* =A0large, bu=
t not so large as to wrap */
> - =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "unknown timeout flag %d", lo=
ng_op);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> + =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* wait for 15 seconds or until woken up due to respons=
e arriving or
> - =A0 =A0 =A0 =A0 =A0due to last connection to this server being unmo=
unted */
> - =A0 =A0 =A0 if (signal_pending(current)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if signal pending do not hold up use=
r for full smb timeout
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 but we still give response a chance to =
complete */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 2 * HZ;
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 /* No user interrupts in wait - wreaks havoc with perfo=
rmance */
> - =A0 =A0 =A0 wait_for_response(ses, midQ, timeout, 10 * HZ);
> + =A0 =A0 =A0 rc =3D wait_for_response(ses->server, midQ);
> + =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> =A0 =A0 =A0 =A0rc =3D handle_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0)
> @@ -598,7 +545,6 @@ SendReceive(const unsigned int xid, struct cifsSe=
sInfo *ses,
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0unsigned int receive_len;
> - =A0 =A0 =A0 unsigned long timeout;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
>
> =A0 =A0 =A0 =A0if (ses =3D=3D NULL) {
> @@ -662,33 +608,12 @@ SendReceive(const unsigned int xid, struct cifs=
SesInfo *ses,
> =A0 =A0 =A0 =A0if (rc < 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> - =A0 =A0 =A0 if (long_op =3D=3D CIFS_STD_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 15 * HZ;
> - =A0 =A0 =A0 /* wait for 15 seconds or until woken up due to respons=
e arriving or
> - =A0 =A0 =A0 =A0 =A0due to last connection to this server being unmo=
unted */
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_ASYNC_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_VLONG_OP) /* writes past E=
OF can be slow */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 180 * HZ;
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_LONG_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 45 * HZ; /* should be great=
er than
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 servers oplock break ti=
meout (about 43 seconds) */
> - =A0 =A0 =A0 else if (long_op =3D=3D CIFS_BLOCKING_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 0x7FFFFFFF; /* large but no=
 so large as to wrap */
> - =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "unknown timeout flag %d", lo=
ng_op);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
> + =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> - =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (signal_pending(current)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if signal pending do not hold up use=
r for full smb timeout
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 but we still give response a chance to =
complete */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D 2 * HZ;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 /* No user interrupts in wait - wreaks havoc with perfo=
rmance */
> - =A0 =A0 =A0 wait_for_response(ses, midQ, timeout, 10 * HZ);
> + =A0 =A0 =A0 rc =3D wait_for_response(ses->server, midQ);
> + =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> =A0 =A0 =A0 =A0rc =3D handle_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0)
> @@ -906,8 +831,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Wait 5 seconds for the response. */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait_for_response(ses, midQ, 5 * HZ=
, 5 * HZ) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (wait_for_response(ses->server, midQ=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* We got the response=
 - restart system call. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rstart =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> --
> 1.7.3.2
>


Reviewed-by:  Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--=20
Best regards,
Pavel Shilovsky.
