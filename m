From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/11] CIFS: Simplify inFlight logic
Date: Mon, 27 Feb 2012 16:53:15 -0600
Message-ID: <CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I got a chance to look through this patch set in more detail on the way
to the SMB2.2 test event.  I liked many of the patches, but this one
seems to complicate, rather than simplify by adding a spinlock
to what used to be an atomic_inc.  There is also a possibility that thi=
s
spinlock will become hot.  I don't mind moving the atomic_inc inside th=
e
new dec_in_flight macro though to make it easier in the future.

On Wed, Feb 22, 2012 at 1:32 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> by making it as unsigned integer and surround access with req_lock
> from server structure.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifs_debug.c | =A0 =A03 +--
> =A0fs/cifs/cifsglob.h =A0 | =A0 21 ++++++++++++++++++++-
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 =A06 +++---
> =A0fs/cifs/connect.c =A0 =A0| =A0 10 +++++-----
> =A0fs/cifs/transport.c =A0| =A0 45 +++++++++++++++++++++++-----------=
-----------
> =A05 files changed, 52 insertions(+), 33 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 24b3dfc..573b899 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -171,8 +171,7 @@ static int cifs_debug_data_proc_show(struct seq_f=
ile *m, void *v)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(m, "TCP sta=
tus: %d\n\tLocal Users To "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "=
Server: %d SecMode: 0x%x Req On Wire: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
erver->tcpStatus, server->srv_count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->sec_mode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
atomic_read(&server->inFlight));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->sec_mode, in_flight(server));
>
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(m, " In Sen=
d: %d In MaxReq Wait: %d",
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 76e7d8b..44cfc9a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -255,7 +255,8 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0bool noblocksnd; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* use=
 blocking sendmsg */
> =A0 =A0 =A0 =A0bool noautotune; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do =
not autotune send buf sizes */
> =A0 =A0 =A0 =A0bool tcp_nodelay;
> - =A0 =A0 =A0 atomic_t inFlight; =A0/* number of requests on the wire=
 to server */
> + =A0 =A0 =A0 unsigned int in_flight; =A0/* number of requests on the=
 wire to server */
> + =A0 =A0 =A0 spinlock_t req_lock; /* protect the value above */
> =A0 =A0 =A0 =A0struct mutex srv_mutex;
> =A0 =A0 =A0 =A0struct task_struct *tsk;
> =A0 =A0 =A0 =A0char server_GUID[16];
> @@ -307,6 +308,24 @@ struct TCP_Server_Info {
> =A0#endif
> =A0};
>
> +static inline unsigned int
> +in_flight(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 unsigned int num;
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 num =3D server->in_flight;
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> + =A0 =A0 =A0 return num;
> +}
> +
> +static inline void
> +dec_in_flight(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 server->in_flight--;
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> +}
> +
> =A0/*
> =A0* Macros to allow the TCP_Server_Info->net field and related code =
to drop out
> =A0* when CONFIG_NET_NS isn't set.
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 8b7794c..0b50551 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -716,7 +716,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server =3D mid->callback_data;
>
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(server);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0}
>
> @@ -1669,7 +1669,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>
> =A0 =A0 =A0 =A0queue_work(system_nrt_wq, &rdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(server);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0}
>
> @@ -2110,7 +2110,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>
> =A0 =A0 =A0 =A0queue_work(system_nrt_wq, &wdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 atomic_dec(&tcon->ses->server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(tcon->ses->server);
> =A0 =A0 =A0 =A0wake_up(&tcon->ses->server->request_q);
> =A0}
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 602f77c..12286d0 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -647,14 +647,14 @@ static void clean_demultiplex_info(struct TCP_S=
erver_Info *server)
> =A0 =A0 =A0 =A0 * cifs_max_pending is normally 50, but can be set at =
module install
> =A0 =A0 =A0 =A0 * time to as little as two.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D cifs_max_pendin=
g)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->inFlight, cifs_max_=
pending - 1);
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 if (server->in_flight >=3D cifs_max_pending)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight =3D cifs_max_pending =
- 1;
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We do not want to set the max_pending too low or we=
 could end up
> =A0 =A0 =A0 =A0 * with the counter going negative.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Although there should not be any requests blocked o=
n this queue it
> =A0 =A0 =A0 =A0 * can not hurt to be paranoid and try to wake up requ=
ests that may
> @@ -1909,7 +1909,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0tcp_ses->noblocksnd =3D volume_info->noblocksnd;
> =A0 =A0 =A0 =A0tcp_ses->noautotune =3D volume_info->noautotune;
> =A0 =A0 =A0 =A0tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_node=
lay;
> - =A0 =A0 =A0 atomic_set(&tcp_ses->inFlight, 0);
> + =A0 =A0 =A0 tcp_ses->in_flight =3D 0;
> =A0 =A0 =A0 =A0init_waitqueue_head(&tcp_ses->response_q);
> =A0 =A0 =A0 =A0init_waitqueue_head(&tcp_ses->request_q);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 0cc9584..fc1904f 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -254,28 +254,29 @@ smb_send(struct TCP_Server_Info *server, struct=
 smb_hdr *smb_buffer,
> =A0 =A0 =A0 =A0return smb_sendv(server, &iov, 1);
> =A0}
>
> -static int wait_for_free_request(struct TCP_Server_Info *server,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t int long_op)
> +static int
> +wait_for_free_request(struct TCP_Server_Info *server, const int long=
_op)
> =A0{
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> +
> =A0 =A0 =A0 =A0if (long_op =3D=3D CIFS_ASYNC_OP) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* oplock breaks must not be held up *=
/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->req_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0while (1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D=
 cifs_max_pending) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_=
Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->in_flight >=3D cifs_max_pen=
ding) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->re=
q_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_num_waiters_inc(s=
erver);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wait_event(server->req=
uest_q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
atomic_read(&server->inFlight)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0< cifs_max_pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
in_flight(server) < cifs_max_pending);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_num_waiters_dec(s=
erver);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lo=
ck);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&server->req_=
lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus =
=3D=3D CifsExiting) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&GlobalMid_Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&server->req_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 -ENOENT;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -284,8 +285,8 @@ static int wait_for_free_request(struct TCP_Serve=
r_Info *server,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* update # of request=
s on the wire to server */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (long_op !=3D CIFS_=
BLOCKING_OP)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
inc(&server->inFlight);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_=
Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>in_flight++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->re=
q_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> @@ -359,7 +360,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> =A0 =A0 =A0 =A0mid =3D AllocMidQEntry(hdr, server);
> =A0 =A0 =A0 =A0if (mid =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0}
> @@ -392,7 +393,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> =A0 =A0 =A0 =A0return rc;
> =A0out_err:
> =A0 =A0 =A0 =A0delete_mid(mid);
> - =A0 =A0 =A0 atomic_dec(&server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(server);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -564,7 +565,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Update # of requests on wire to ser=
ver */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -601,7 +602,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->callback =3D Del=
eteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release=
(in_buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server=
->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->serv=
er);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->=
request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -612,7 +613,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -637,7 +638,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->resp_buf =3D NULL;
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
>
> =A0 =A0 =A0 =A0return rc;
> @@ -688,7 +689,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Update # of requests on wire to ser=
ver */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -721,7 +722,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no longer considere=
d to be "in-flight" */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->callback =3D Del=
eteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server=
->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->serv=
er);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->=
request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -730,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -747,7 +748,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
> + =A0 =A0 =A0 dec_in_flight(ses->server);
> =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
>
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
