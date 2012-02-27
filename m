From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/11] CIFS: Count blocking lock command
Date: Mon, 27 Feb 2012 17:23:07 -0600
Message-ID: <CAH2r5mujUbTEe0xtk_sfM1xokCk7FnX=6JKO539ut88Z+RS7wA@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I don't think we can do this for the cifs case - 49 blocking locks and
we would deadlock our system (a pending write could block forever) -
for smb2.2 it makes more sense.  I don't think it actually causes a
problem to exceed 50 blocks locks - but if we want to count blocking
locks we will have to limit the maximum number of blocking locks to 2
or 3 less than maxmpx and not allow blocking locks if maxmpx is lower
than 3.

On Wed, Feb 22, 2012 at 1:32 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> to make sure we don't exceed the number of credits we have in this ca=
se.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/transport.c | =A0 32 +++++++++++++++++++++-----------
> =A01 files changed, 21 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 44ac0aa..fa93720 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -279,15 +279,8 @@ wait_for_free_request(struct TCP_Server_Info *se=
rver, const int long_op)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_u=
nlock(&server->req_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 -ENOENT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* can not count lockin=
g commands against total
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0as they are allo=
wed to block on server */
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update # of requests=
 on the wire to server */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_B=
LOCKING_OP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>credits--;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>in_flight++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->credits--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&server->r=
eq_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -816,7 +809,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING=
_OP);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, 0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -829,6 +822,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0rc =3D allocate_mid(ses, in_buf, &midQ);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -836,6 +831,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -848,6 +845,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
>
> =A0 =A0 =A0 =A0if (rc < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete_mid(midQ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> @@ -869,6 +868,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D send_nt_cancel(=
ses->server, in_buf, midQ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete=
_mid(midQ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up=
(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> @@ -881,6 +882,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 already been remo=
ved. Don't exit in this case. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc && rc !=3D -ENO=
LCK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete=
_mid(midQ);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up=
(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -893,6 +896,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no =
longer considered to be "in-flight" */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->=
callback =3D DeleteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_u=
nlock(&GlobalMid_Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up=
(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> @@ -903,8 +908,11 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> - =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 if (rc !=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* rcvd frame is ok */
> =A0 =A0 =A0 =A0if (out_buf =3D=3D NULL || midQ->midState !=3D MID_RES=
PONSE_RECEIVED) {
> @@ -918,6 +926,8 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> + =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0if (rstart && rc =3D=3D -EACCES)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ERESTARTSYS;
> =A0 =A0 =A0 =A0return rc;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
