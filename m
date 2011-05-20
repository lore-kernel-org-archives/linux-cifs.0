From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/7] cifs: don't call mid_q_entry->callback under the Global_MidLock
Date: Fri, 20 May 2011 13:32:10 -0500
Message-ID: <BANLkTimzEy+GxOjiC3yhjUD2ynoiRDRkag@mail.gmail.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
	<1305836578-26333-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, May 19, 2011 at 3:22 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Holding the spinlock while we call this function means that it can't
> sleep, which really limits what it can do. Taking it out from under
> the spinlock also means less contention for this global lock.
>
> Change the semantics such that the Global_MidLock is not held when
> the callback is called. To do this requires that we take extra care
> not to have sync_mid_result remove the mid from the list when the
> mid is in a state where that has already happened. This prevents
> list corruption when the mid is sitting on a private list for
> reconnect or when cifsd is coming down.
>
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsglob.h =A0| =A0 =A06 +++---
> =A0fs/cifs/connect.c =A0 | =A0 30 ++++++++++++++++++++++++------
> =A0fs/cifs/transport.c | =A0 23 ++++++++---------------
> =A03 files changed, 35 insertions(+), 24 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 76b4517..fd877c1 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -543,9 +543,8 @@ struct mid_q_entry;
> =A0* This is the prototype for the mid callback function. When creati=
ng one,
> =A0* take special care to avoid deadlocks. Things to bear in mind:
> =A0*
> - * - it will be called by cifsd
> - * - the GlobalMid_Lock will be held
> - * - the mid will be removed from the pending_mid_q list
> + * - it will be called by cifsd, with no locks held
> + * - the mid will be removed from any lists
> =A0*/
> =A0typedef void (mid_callback_t)(struct mid_q_entry *mid);
>
> @@ -656,6 +655,7 @@ static inline void free_dfs_info_array(struct dfs=
_info3_param *param,
> =A0#define =A0 MID_RESPONSE_RECEIVED 4
> =A0#define =A0 MID_RETRY_NEEDED =A0 =A0 =A08 /* session closed while =
this request out */
> =A0#define =A0 MID_RESPONSE_MALFORMED 0x10
> +#define =A0 MID_SHUTDOWN =A0 =A0 =A0 =A0 =A00x20
>
> =A0/* Types of response buffer returned from SendReceive2 */
> =A0#define =A0 CIFS_NO_BUFFER =A0 =A0 =A0 =A00 =A0 =A0/* Response buf=
fer not returned */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index da284e3..ccb3ff8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -138,6 +138,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0struct cifsSesInfo *ses;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> + =A0 =A0 =A0 struct list_head retry_list;
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0if (server->tcpStatus =3D=3D CifsExiting) {
> @@ -189,16 +190,23 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
>
> =A0 =A0 =A0 =A0/* mark submitted MIDs for retry and issue callback */
> - =A0 =A0 =A0 cFYI(1, "%s: issuing mid callbacks", __func__);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&retry_list);
> + =A0 =A0 =A0 cFYI(1, "%s: moving mids to private list", __func__);
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp2, &server->pending_mid_q) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_entry(tmp, struct m=
id_q_entry, qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry->midState =3D=3D MID_REQ=
UEST_SUBMITTED)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->midState =3D=
 MID_RETRY_NEEDED;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(&mid_entry->qhead, &retry_lis=
t);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> +
> + =A0 =A0 =A0 cFYI(1, "%s: moving mids to private list", __func__);

Does this comment repeat here?

> + =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &retry_list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct mi=
d_q_entry, qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&mid_entry->qhead);

And if we called list_move on this entry earlier, does this entry exist
on the qhead list anymore i.e. did not list_move that care of list_del =
part?

> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(mid_entry);
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_to_freeze();
> @@ -672,12 +680,12 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->when_receiv=
ed =3D jiffies;
> =A0#endif
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&mid_ent=
ry->qhead);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid=
_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid=
_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Was previous buf pu=
t in mpx struct for multi-rsp? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!isMultiRsp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* smb=
 buffer will be freed by user thread */
> @@ -741,15 +749,25 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(smallbuf);
>
> =A0 =A0 =A0 =A0if (!list_empty(&server->pending_mid_q)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct list_head dispose_list;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_LIST_HEAD(&dispose_list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_safe(tmp, tmp2, &server-=
>pending_mid_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_ent=
ry(tmp, struct mid_q_entry, qhead);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Clearing Mid 0=
x%x - issuing callback",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0mid_entry->mid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Clearing mid 0=
x%x", mid_entry->mid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState =3D=
 MID_SHUTDOWN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(&mid_entry->q=
head, &dispose_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* now walk dispose list and issue call=
backs */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &dispose_=
list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entr=
y(tmp, struct mid_q_entry, qhead);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Callback mid 0=
x%x", mid_entry->mid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del_init(&mid_ent=
ry->qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->callback(mi=
d_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* 1/8th of sec is more than enough ti=
me for them to exit */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0msleep(125);
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 67f59c7..b3c3c6d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -425,7 +425,7 @@ SendReceiveNoRsp(const unsigned int xid, struct c=
ifsSesInfo *ses,
> =A0}
>
> =A0static int
> -sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *ser=
ver)
> +cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info=
 *server)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
>
> @@ -433,28 +433,21 @@ sync_mid_result(struct mid_q_entry *mid, struct=
 TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->mid, mid->midState);
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 /* ensure that it's no longer on the pending_mid_q */
> - =A0 =A0 =A0 list_del_init(&mid->qhead);
> -
> =A0 =A0 =A0 =A0switch (mid->midState) {
> =A0 =A0 =A0 =A0case MID_RESPONSE_RECEIVED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> - =A0 =A0 =A0 case MID_REQUEST_SUBMITTED:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* socket is going down, reject all cal=
ls */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=3D CifsExitin=
g) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: cancelin=
g mid=3D%d cmd=3D0x%x state=3D%d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__func__=
, mid->mid, mid->command, mid->midState);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EHOSTDOWN;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0case MID_RETRY_NEEDED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case MID_RESPONSE_MALFORMED:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 case MID_SHUTDOWN:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EHOSTDOWN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(&mid->qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: invalid mid state mid=3D=
%d state=3D%d", __func__,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->mid, mid->midStat=
e);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO;
> @@ -617,7 +610,7 @@ SendReceive2(const unsigned int xid, struct cifsS=
esInfo *ses,
>
> =A0 =A0 =A0 =A0cifs_small_buf_release(in_buf);
>
> - =A0 =A0 =A0 rc =3D sync_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_dec(&ses->server->inFlight);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> @@ -738,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifsSe=
sInfo *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D sync_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_dec(&ses->server->inFlight);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> @@ -913,7 +906,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifsTconInfo *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rstart =3D 1;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D sync_mid_result(midQ, ses->server);
> + =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
