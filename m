From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 07/13] cifs: allow for different handling of received response
Date: Mon, 13 Dec 2010 23:21:29 +0300
Message-ID: <AANLkTin_P1xk8VE4D2uHonX5mU_-wu2tBfKV0MjtM7r5@mail.gmail.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-8-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-8-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> In order to incorporate async requests, we need to allow for a more
> general way to do things on receive, rather than just waking up a
> process.
>
> Turn the task pointer in the mid_q_entry into a callback function and=
 a
> generic data pointer. When a response comes in, or the socket is
> reconnected, cifsd can call the callback function in order to wake up
> the process.
>
> The default is to just wake up the current process which should mean =
no
> change in behavior for existing code.
>
> Also, clean up the locking in cifs_reconnect. There doesn't seem to b=
e
> any need to hold both the srv_mutex and GlobalMid_Lock when walking t=
he
> list of mids.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_debug.c | =A0 =A08 +++---
> =A0fs/cifs/cifsglob.h =A0 | =A0 =A07 +++++-
> =A0fs/cifs/connect.c =A0 =A0| =A0 54 ++++++++++++++++++++++++++++----=
-----------------
> =A0fs/cifs/transport.c =A0| =A0 15 +++++++++++++-
> =A04 files changed, 55 insertions(+), 29 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index bd76527..c81934f 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -79,11 +79,11 @@ void cifs_dump_mids(struct TCP_Server_Info *serve=
r)
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_mid_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_entry(tmp, struct m=
id_q_entry, qhead);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "State: %d Cmd: %d Pid: %d Ts=
k: %p Mid %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "State: %d Cmd: %d Pid: %d Cb=
data: %p Mid %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->midState,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(int)mid_entry->comman=
d,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->pid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->tsk,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback_dat=
a,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->mid);
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "IsLarge: %d buf: %p time rc=
v: %ld now: %ld",
> @@ -218,11 +218,11 @@ static int cifs_debug_data_proc_show(struct seq=
_file *m, void *v)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try =3D list_entry(tmp3, struct mid_q_entry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_pr=
intf(m, "\tState: %d com: %d pid:"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 " %d tsk: %p mid %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 " %d cbdata: %p mid %d\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->midState,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(int)mid_entry->command,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->pid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->tsk,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0mid_entry->mid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cf0dfda..cc43ada 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -511,6 +511,10 @@ static inline void cifs_stats_bytes_read(struct =
cifsTconInfo *tcon,
>
> =A0#endif
>
> +struct mid_q_entry;
> +
> +typedef void (mid_callback_t)(struct mid_q_entry *mid);
> +
> =A0/* one of these for every pending CIFS request to the server */
> =A0struct mid_q_entry {
> =A0 =A0 =A0 =A0struct list_head qhead; /* mids waiting on reply from =
this server */
> @@ -522,7 +526,8 @@ struct mid_q_entry {
> =A0 =A0 =A0 =A0unsigned long when_sent; /* time when smb send finishe=
d */
> =A0 =A0 =A0 =A0unsigned long when_received; /* when demux complete (t=
aken off wire) */
> =A0#endif
> - =A0 =A0 =A0 struct task_struct *tsk; =A0 =A0 =A0 =A0/* task waiting=
 for response */
> + =A0 =A0 =A0 mid_callback_t *callback; /* call completion callback *=
/
> + =A0 =A0 =A0 void *callback_data; =A0 =A0 =A0/* general purpose poin=
ter for callback */
> =A0 =A0 =A0 =A0struct smb_hdr *resp_buf; =A0 =A0 =A0 /* response buff=
er */
> =A0 =A0 =A0 =A0int midState; =A0 /* wish this were enum but can not p=
ass to wait_event */
> =A0 =A0 =A0 =A0__u8 command; =A0 /* smb command code */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 9fbe7c5..7e20ece 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -133,6 +133,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0struct list_head *tmp, *tmp2;
> + =A0 =A0 =A0 struct list_head retry;
> =A0 =A0 =A0 =A0struct cifsSesInfo *ses;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> @@ -152,6 +153,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>
> =A0 =A0 =A0 =A0/* before reconnecting the tcp session, mark the smb s=
ession (uid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and the tid bad so they are not used u=
ntil reconnected */
> + =A0 =A0 =A0 cFYI(1, "%s: marking sessions and tcons for reconnect",=
 __func__);
> =A0 =A0 =A0 =A0spin_lock(&cifs_tcp_ses_lock);
> =A0 =A0 =A0 =A0list_for_each(tmp, &server->smb_ses_list) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ses =3D list_entry(tmp, struct cifsSes=
Info, smb_ses_list);
> @@ -163,7 +165,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);
> +
> =A0 =A0 =A0 =A0/* do not want to be sending data on a socket we are f=
reeing */
> + =A0 =A0 =A0 cFYI(1, "%s: tearing down socket", __func__);
> =A0 =A0 =A0 =A0mutex_lock(&server->srv_mutex);
> =A0 =A0 =A0 =A0if (server->ssocket) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "State: 0x%x Flags: 0x%lx", se=
rver->ssocket->state,
> @@ -180,22 +184,21 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0kfree(server->session_key.response);
> =A0 =A0 =A0 =A0server->session_key.response =3D NULL;
> =A0 =A0 =A0 =A0server->session_key.len =3D 0;
> + =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* move in-progress mids to a private list so that we=
 can walk it later
> + =A0 =A0 =A0 =A0* without needing a lock. We'll mark them for retry =
after reconnect.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 cFYI(1, "%s: moving mids to retry list", __func__);
> + =A0 =A0 =A0 INIT_LIST_HEAD(&retry);
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> - =A0 =A0 =A0 list_for_each(tmp, &server->pending_mid_q) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_q_entry,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 qhead);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->midState =3D=3D MID_REQU=
EST_SUBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Mark=
 other intransit requests as needing
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
retry so we do not immediately mark the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
session bad again (ie after we reconnect
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
below) as they timeout too */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState =3D=
 MID_RETRY_NEEDED;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct mi=
d_q_entry, qhead);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry->midState =3D=3D MID_REQU=
EST_SUBMITTED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(tmp, &retry);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>
> =A0 =A0 =A0 =A0while ((server->tcpStatus !=3D CifsExiting) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (server->tcpStatus !=3D CifsGood)) {
> @@ -213,10 +216,17 @@ cifs_reconnect(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (server->tcpStatus =
!=3D CifsExiting)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server=
->tcpStatus =3D CifsGood;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> - =A0 =A0 =A0 /* =A0 =A0 =A0 =A0 =A0 =A0 =A0atomic_set(&server->inFli=
ght,0);*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->respon=
se_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 /* now, issue callback for all mids in flight */
> + =A0 =A0 =A0 list_for_each_safe(tmp, tmp2, &retry) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del_init(tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entry(tmp, struct mi=
d_q_entry, qhead);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState =3D MID_RETRY_NEEDE=
D;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid_entry);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> @@ -560,8 +570,7 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_to_wake =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_mi=
d_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_ent=
ry(tmp, struct mid_q_entry, qhead);
> @@ -604,7 +613,6 @@ incomplete_rcv:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->resp_buf =3D smb_buffer;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->largeBuf =3D isLargeBuf;
> =A0multi_t2_fnd:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_to=
_wake =3D mid_entry->tsk;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->midState =3D MID_RESPONSE_RECEIVED;
> =A0#ifdef CONFIG_CIFS_STATS2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_en=
try->when_received =3D jiffies;
> @@ -615,9 +623,12 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server=
->lstrp =3D jiffies;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (task_to_wake) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_entry !=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback(mid=
_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Was previous buf pu=
t in mpx struct for multi-rsp? */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!isMultiRsp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* smb=
 buffer will be freed by user thread */
> @@ -626,7 +637,6 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0smallbuf =3D NULL;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_process(task_to=
_wake);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (!is_valid_oplock_break(smb_=
buffer, server) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !isMultiRsp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "No task to =
wake, unknown frame received! "
> @@ -707,11 +717,9 @@ multi_t2_fnd:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each(tmp, &server->pending_mi=
d_q) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_entry =3D list_entry(tmp, struct m=
id_q_entry, qhead);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mid_entry->midStat=
e =3D=3D MID_REQUEST_SUBMITTED) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "Clearing Mid 0x%x - waking up ",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "Clearing Mid 0x%x - issuing callback",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->mid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 task_to=
_wake =3D mid_entry->tsk;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tas=
k_to_wake)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 wake_up_process(task_to_wake);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_ent=
ry->callback(mid_entry);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid_Lock);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 05ced17..79647db 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -36,6 +36,12 @@
>
> =A0extern mempool_t *cifs_mid_poolp;
>
> +static void
> +wake_up_task(struct mid_q_entry *mid)
> +{
> + =A0 =A0 =A0 wake_up_process(mid->callback_data);
> +}
> +
> =A0static struct mid_q_entry *
> =A0AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server=
_Info *server)
> =A0{
> @@ -58,7 +64,13 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, s=
truct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0/* =A0 =A0 =A0do_gettimeofday(&temp->when_sent);*/ /* =
easier to use jiffies */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* when mid allocated can be before wh=
en sent */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0temp->when_alloc =3D jiffies;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp->tsk =3D current;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The default is for the mid to be s=
ynchronous, so the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* default callback just wakes up the=
 current task.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp->callback =3D wake_up_task;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp->callback_data =3D current;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0spin_lock(&GlobalMid_Lock);
> @@ -374,6 +386,7 @@ handle_mid_result(struct mid_q_entry *mid, struct=
 TCP_Server_Info *server)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid->midState =3D MID_RETRY_NEEDED;
> =A0 =A0 =A0 =A0case MID_RETRY_NEEDED:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move(&mid->qhead, &server->pending=
_mid_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> --
> 1.7.3.2
>

Very good idea to add default synchronous callback - it simplifies the
code greatly. Looks ok to me.

Reviewed-by:  Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


--=20
Best regards,
Pavel Shilovsky.
