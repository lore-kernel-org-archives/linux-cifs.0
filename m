From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Mon, 27 Feb 2012 18:01:04 -0600
Message-ID: <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1329895984-9251-7-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is going to be more complicated than it seems.

Apparently (according to Chris), Windows will often allow mapmpx simult=
aneous
requests per process for various handle based requests.   In addition a=
ccording
to JRA, Samba server does not care if you go beyond maxmpx (and there i=
s
a big performance advantage of that).   On the other hand - if the serv=
er
sets maxmpx to less than 10, these kind of changes probably make sense
(those servers are probably broken otherwise), but for normal servers
this will end up restricting more than windows (for more than than the
maxmpx per pid).   Generally, for servers like Samba that support
simultaneous requests reasonably we have to be careful about killing
performance especially now that with Jeff's async reads and writes
we will frequently get up to 50 (and should probably make it easier
to have more than 50 to servers like Samba).

Quoting JRA and Volker - "You should be able to queue
thousands of simultaneous requests from one client to Samba"
(as long as the client doesn't time out.  The server keeps
responding to the earlier requests, so with our client timeout
code weshould be fine).

On Wed, Feb 22, 2012 at 1:32 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> by setting the number of available credits to it except 2 that goes
> to extra echo and oplock slots. If MaxMpxCount is 2 - disable oplocks=
,
> if 1 - disable oplocks and echos.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 12 --------
> =A0fs/cifs/cifsglob.h =A0| =A0 60 ++++++++++++++++++-----------------=
---
> =A0fs/cifs/cifsproto.h | =A0 =A07 ++++-
> =A0fs/cifs/cifssmb.c =A0 | =A0 16 ++++++----
> =A0fs/cifs/connect.c =A0 | =A0 10 +++---
> =A0fs/cifs/dir.c =A0 =A0 =A0 | =A0 =A05 ++-
> =A0fs/cifs/file.c =A0 =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 49 +++++++++++++++++++++++++++++++
> =A0fs/cifs/transport.c | =A0 79 +++++++++++++++++++++++++------------=
--------------
> =A09 files changed, 142 insertions(+), 100 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index e1ce1ca..a9b483b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -73,10 +73,6 @@ unsigned int cifs_min_small =3D 30;
> =A0module_param(cifs_min_small, int, 0);
> =A0MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. D=
efault: 30 "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Rang=
e: 2 to 256");
> -unsigned int cifs_max_pending =3D CIFS_MAX_REQ;
> -module_param(cifs_max_pending, int, 0444);
> -MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server.=
 "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"Default: 50 Range: 2 to 256");
> =A0module_param(enable_oplocks, bool, 0644);
> =A0MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool)=
=2E Default:"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "y/Y/=
1");
> @@ -1108,14 +1104,6 @@ init_cifs(void)
> =A0 =A0 =A0 =A0spin_lock_init(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0spin_lock_init(&GlobalMid_Lock);
>
> - =A0 =A0 =A0 if (cifs_max_pending < 2) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_max_pending =3D 2;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_max_pending set to min of=
 2");
> - =A0 =A0 =A0 } else if (cifs_max_pending > 256) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_max_pending =3D 256;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "cifs_max_pending set to max of=
 256");
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0rc =3D cifs_fscache_register();
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_clean_proc;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 674792e..4b13be5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -53,17 +53,6 @@
> =A0*/
> =A0#define CIFS_MAX_ACTIMEO (1 << 30)
>
> -/*
> - * MAX_REQ is the maximum number of requests that WE will send
> - * on one socket concurrently. It also matches the most common
> - * value of max multiplex returned by servers. =A0We may
> - * eventually want to use the negotiated value (in case
> - * future servers can handle more) when we are more confident that
> - * we will not have problems oveloading the socket with pending
> - * write data.
> - */
> -#define CIFS_MAX_REQ 50
> -
> =A0#define RFC1001_NAME_LEN 15
> =A0#define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
>
> @@ -255,7 +244,11 @@ struct TCP_Server_Info {
> =A0 =A0 =A0 =A0bool noblocksnd; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* use=
 blocking sendmsg */
> =A0 =A0 =A0 =A0bool noautotune; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do =
not autotune send buf sizes */
> =A0 =A0 =A0 =A0bool tcp_nodelay;
> - =A0 =A0 =A0 int credits; =A0/* send no more requests at once */
> + =A0 =A0 =A0 bool oplocks:1; /* server supports async oplock breaks =
*/
> + =A0 =A0 =A0 bool echos:1; /* server supports async echos */
> + =A0 =A0 =A0 unsigned int echo_credits; /* reserve for echos */
> + =A0 =A0 =A0 unsigned int oplock_credits; /* reserve for oplock brea=
ks */
> + =A0 =A0 =A0 unsigned int credits; =A0/* send no more requests at on=
ce */
> =A0 =A0 =A0 =A0unsigned int in_flight; =A0/* number of requests on th=
e wire to server */
> =A0 =A0 =A0 =A0spinlock_t req_lock; =A0/* protect the two values abov=
e */
> =A0 =A0 =A0 =A0struct mutex srv_mutex;
> @@ -309,6 +302,12 @@ struct TCP_Server_Info {
> =A0#endif
> =A0};
>
> +/*
> + * The minimal value to set before negotiating and don't issue extra=
 messaging
> + * in cifs_change_conf.
> + */
> +#define CIFS_CREDITS_DEFAULT 3
> +
> =A0static inline unsigned int
> =A0in_flight(struct TCP_Server_Info *server)
> =A0{
> @@ -319,31 +318,31 @@ in_flight(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0return num;
> =A0}
>
> -static inline int
> -get_credits(struct TCP_Server_Info *server)
> -{
> - =A0 =A0 =A0 int num;
> - =A0 =A0 =A0 spin_lock(&server->req_lock);
> - =A0 =A0 =A0 num =3D server->credits;
> - =A0 =A0 =A0 spin_unlock(&server->req_lock);
> - =A0 =A0 =A0 return num;
> -}
> +#define =A0 CIFS_OBREAK_OP =A0 =A00x080 =A0 =A0/* oplock break reque=
st */
> +#define =A0 CIFS_ECHO_OP =A0 =A0 0x0100 =A0 =A0/* echo request */
> +#define =A0 CIFS_REQ_MASK =A0 =A00x0180 =A0 =A0/* mask request type =
*/
>
> -static inline void
> -add_credits(struct TCP_Server_Info *server, unsigned int add)
> +static inline unsigned int*
> +get_credits_field(struct TCP_Server_Info *server, const int optype)
> =A0{
> - =A0 =A0 =A0 spin_lock(&server->req_lock);
> - =A0 =A0 =A0 server->credits +=3D add;
> - =A0 =A0 =A0 server->in_flight--;
> - =A0 =A0 =A0 spin_unlock(&server->req_lock);
> + =A0 =A0 =A0 switch (optype) {
> + =A0 =A0 =A0 case CIFS_ECHO_OP:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return &server->echo_credits;
> + =A0 =A0 =A0 case CIFS_OBREAK_OP:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return &server->oplock_credits;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return &server->credits;
> + =A0 =A0 =A0 }
> =A0}
>
> -static inline void
> -set_credits(struct TCP_Server_Info *server, int val)
> +static inline bool
> +has_free_credits(struct TCP_Server_Info *server, unsigned int *val)
> =A0{
> + =A0 =A0 =A0 bool res;
> =A0 =A0 =A0 =A0spin_lock(&server->req_lock);
> - =A0 =A0 =A0 server->credits =3D val;
> + =A0 =A0 =A0 res =3D *val > 0;
> =A0 =A0 =A0 =A0spin_unlock(&server->req_lock);
> + =A0 =A0 =A0 return res;
> =A0}
>
> =A0/*
> @@ -1047,7 +1046,6 @@ GLOBAL_EXTERN unsigned int linuxExtEnabled;/*en=
able Linux/Unix CIFS extensions*/
> =A0GLOBAL_EXTERN unsigned int CIFSMaxBufSize; =A0/* max size not incl=
uding hdr */
> =A0GLOBAL_EXTERN unsigned int cifs_min_rcv; =A0 =A0/* min size of big=
 ntwrk buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_min_small; =A0/* min size of small=
 buf pool */
> -GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once=
 to server*/
>
> =A0#ifdef CONFIG_CIFS_ACL
> =A0GLOBAL_EXTERN struct rb_root uidtree;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 6f4e243..75163a6 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *mid=
Entry);
> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct =
kvec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec=
, mid_receive_t *receive,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *c=
allback, void *cbdata,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool ignore_pend=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int optype);
> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifs_=
ses *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* in=
put */ ,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_hdr * /* ou=
t */ ,
> @@ -169,6 +169,11 @@ extern struct smb_vol *cifs_get_volume_info(char=
 *mount_data,
> =A0extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
> =A0extern void cifs_umount(struct cifs_sb_info *);
> =A0extern void cifs_dfs_release_automount_timer(void);
> +extern int cifs_reconnect(struct TCP_Server_Info *server);
> +extern void cifs_change_conf(struct TCP_Server_Info *server);
> +extern void add_credits(struct TCP_Server_Info *server, unsigned int=
 add,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int optype);
> +extern void set_credits(struct TCP_Server_Info *server, unsigned int=
 val);
> =A0void cifs_proc_init(void);
> =A0void cifs_proc_clean(void);
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index c255c25..985dcce 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -459,6 +459,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_se=
s *ses)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->sec_mode =3D (__u8)le16_to_cpu=
(rsp->SecurityMode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->maxReq =3D le16_to_cpu(rsp->Ma=
xMpxCount);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_credits(server, server->maxReq);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->maxBuf =3D le16_to_cpu(rsp->Ma=
xBufSize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->max_vcs =3D le16_to_cpu(rsp->M=
axNumberVcs);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* even though we do not use raw we mi=
ght as well set this
> @@ -565,6 +566,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_se=
s *ses)
> =A0 =A0 =A0 =A0/* one byte, so no need to convert this or EncryptionK=
eyLen from
> =A0 =A0 =A0 =A0 =A0 little endian */
> =A0 =A0 =A0 =A0server->maxReq =3D le16_to_cpu(pSMBr->MaxMpxCount);
> + =A0 =A0 =A0 set_credits(server, server->maxReq);
> =A0 =A0 =A0 =A0/* probably no need to store and check maxvcs */
> =A0 =A0 =A0 =A0server->maxBuf =3D le32_to_cpu(pSMBr->MaxBufferSize);
> =A0 =A0 =A0 =A0server->max_rw =3D le32_to_cpu(pSMBr->MaxRawSize);
> @@ -716,7 +718,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server =3D mid->callback_data;
>
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 add_credits(server, 1);
> + =A0 =A0 =A0 add_credits(server, 1, CIFS_ECHO_OP);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0}
>
> @@ -744,7 +746,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length) +=
 4;
>
> =A0 =A0 =A0 =A0rc =3D cifs_call_async(server, &iov, 1, NULL, cifs_ech=
o_callback,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, true=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, CIFS=
_ECHO_OP);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Echo request failed: %d", rc)=
;
>
> @@ -1669,7 +1671,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>
> =A0 =A0 =A0 =A0queue_work(system_nrt_wq, &rdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 add_credits(server, 1);
> + =A0 =A0 =A0 add_credits(server, 1, 0);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0}
>
> @@ -1725,7 +1727,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
>
> =A0 =A0 =A0 =A0rc =3D cifs_call_async(tcon->ses->server, rdata->iov, =
1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_readv_re=
ceive, cifs_readv_callback,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, false=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, 0);
>
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_reads);
> @@ -2110,7 +2112,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>
> =A0 =A0 =A0 =A0queue_work(system_nrt_wq, &wdata->work);
> =A0 =A0 =A0 =A0DeleteMidQEntry(mid);
> - =A0 =A0 =A0 add_credits(tcon->ses->server, 1);
> + =A0 =A0 =A0 add_credits(tcon->ses->server, 1, 0);
> =A0 =A0 =A0 =A0wake_up(&tcon->ses->server->request_q);
> =A0}
>
> @@ -2194,7 +2196,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
>
> =A0 =A0 =A0 =A0kref_get(&wdata->refcount);
> =A0 =A0 =A0 =A0rc =3D cifs_call_async(tcon->ses->server, iov, wdata->=
nr_pages + 1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_w=
ritev_callback, wdata, false);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_w=
ritev_callback, wdata, 0);
>
> =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_stats_inc(&tcon->num_writes);
> @@ -2382,7 +2384,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tc=
on,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_ASYNC_OP; /* no respon=
se expected */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_ASYNC_OP | CIFS_OBREAK=
_OP;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->Timeout =3D 0;
> =A0 =A0 =A0 =A0} else if (waitFlag) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0timeout =3D CIFS_BLOCKING_OP; /* block=
ing operation, no timeout */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 86d7a40..aa97dab 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -78,7 +78,7 @@ static int cifs_setup_volume_info(struct smb_vol *v=
olume_info, char *mount_data,
> =A0* reconnect tcp session
> =A0* wake up waiters on reconnection? - (not needed currently)
> =A0*/
> -static int
> +int
> =A0cifs_reconnect(struct TCP_Server_Info *server)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> @@ -324,7 +324,7 @@ cifs_echo_request(struct work_struct *work)
> =A0 =A0 =A0 =A0 * done, which is indicated by maxBuf !=3D 0. Also, no=
 need to ping if
> =A0 =A0 =A0 =A0 * we got a response recently
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (server->maxBuf =3D=3D 0 ||
> + =A0 =A0 =A0 if (!server->echos || server->maxBuf =3D=3D 0 ||
> =A0 =A0 =A0 =A0 =A0 =A0time_before(jiffies, server->lstrp + SMB_ECHO_=
INTERVAL - HZ))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto requeue_echo;
>
> @@ -1901,7 +1901,7 @@ cifs_get_tcp_session(struct smb_vol *volume_inf=
o)
> =A0 =A0 =A0 =A0tcp_ses->noautotune =3D volume_info->noautotune;
> =A0 =A0 =A0 =A0tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_node=
lay;
> =A0 =A0 =A0 =A0tcp_ses->in_flight =3D 0;
> - =A0 =A0 =A0 tcp_ses->credits =3D cifs_max_pending;
> + =A0 =A0 =A0 tcp_ses->credits =3D CIFS_CREDITS_DEFAULT;
> =A0 =A0 =A0 =A0init_waitqueue_head(&tcp_ses->response_q);
> =A0 =A0 =A0 =A0init_waitqueue_head(&tcp_ses->request_q);
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
> @@ -3751,11 +3751,11 @@ int cifs_negotiate_protocol(unsigned int xid,=
 struct cifs_ses *ses)
> =A0 =A0 =A0 =A0if (server->maxBuf !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> - =A0 =A0 =A0 set_credits(server, cifs_max_pending);
> + =A0 =A0 =A0 set_credits(server, CIFS_CREDITS_DEFAULT);
> =A0 =A0 =A0 =A0rc =3D CIFSSMBNegotiate(xid, ses);
> =A0 =A0 =A0 =A0if (rc =3D=3D -EAGAIN) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* retry only once on 1st time connect=
ion */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_credits(server, cifs_max_pending);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_credits(server, CIFS_CREDITS_DEFAUL=
T);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBNegotiate(xid, ses);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D -EAGAIN)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EHOSTDOWN;
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 63a196b..e183e38 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -171,7 +171,7 @@ cifs_create(struct inode *inode, struct dentry *d=
irentry, umode_t mode,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
>
> - =A0 =A0 =A0 if (enable_oplocks)
> + =A0 =A0 =A0 if (tcon->ses->server->oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
>
> =A0 =A0 =A0 =A0if (nd)
> @@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, struc=
t dentry *direntry,
> =A0{
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0int rc =3D 0; /* to get around spurious gcc warning, s=
et to zero here */
> - =A0 =A0 =A0 __u32 oplock =3D enable_oplocks ? REQ_OPLOCK : 0;
> + =A0 =A0 =A0 __u32 oplock;
> =A0 =A0 =A0 =A0__u16 fileHandle =3D 0;
> =A0 =A0 =A0 =A0bool posix_open =3D false;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> @@ -517,6 +517,7 @@ cifs_lookup(struct inode *parent_dir_inode, struc=
t dentry *direntry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return (struct dentry *)tlink;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(tlink);
> + =A0 =A0 =A0 oplock =3D pTcon->ses->server->oplocks ? REQ_OPLOCK : 0=
;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Don't allow the separator character in a path compo=
nent.
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4dd9283..b5e38b1 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -380,7 +380,7 @@ int cifs_open(struct inode *inode, struct file *f=
ile)
> =A0 =A0 =A0 =A0cFYI(1, "inode =3D 0x%p file flags are 0x%x for %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, file->f_flags, full_path);
>
> - =A0 =A0 =A0 if (enable_oplocks)
> + =A0 =A0 =A0 if (tcon->ses->server->oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D 0;
> @@ -505,7 +505,7 @@ static int cifs_reopen_file(struct cifsFileInfo *=
pCifsFile, bool can_flush)
> =A0 =A0 =A0 =A0cFYI(1, "inode =3D 0x%p file flags 0x%x for %s",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode, pCifsFile->f_flags, full_path)=
;
>
> - =A0 =A0 =A0 if (enable_oplocks)
> + =A0 =A0 =A0 if (tcon->ses->server->oplocks)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D REQ_OPLOCK;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0oplock =3D 0;
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 703ef5c..e14dc8f 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -690,3 +690,52 @@ backup_cred(struct cifs_sb_info *cifs_sb)
>
> =A0 =A0 =A0 =A0return false;
> =A0}
> +
> +void
> +cifs_change_conf(struct TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 server->oplock_credits =3D server->echo_credits =3D 0;
> + =A0 =A0 =A0 switch (server->credits) {
> + =A0 =A0 =A0 case 0:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_reconnect(server);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 case 1:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "disabling echos and oplocks"=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case 2:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->echo_credits =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "disabling oplocks");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->echos =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->oplocks =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->echo_credits =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->oplock_credits =3D 1;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 server->credits -=3D server->echo_credits + server->opl=
ock_credits;
> +}
> +
> +void
> +add_credits(struct TCP_Server_Info *server, const unsigned int add,
> + =A0 =A0 =A0 =A0 =A0 const int optype)
> +{
> + =A0 =A0 =A0 unsigned int *val;
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 val =3D get_credits_field(server, optype);
> + =A0 =A0 =A0 *val +=3D add;
> + =A0 =A0 =A0 server->in_flight--;
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> +}
> +
> +void
> +set_credits(struct TCP_Server_Info *server, const unsigned int val)
> +{
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 server->credits =3D val;
> + =A0 =A0 =A0 cifs_change_conf(server);
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> +}
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 938d20b..91f009d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -255,44 +255,41 @@ smb_send(struct TCP_Server_Info *server, struct=
 smb_hdr *smb_buffer,
> =A0}
>
> =A0static int
> -wait_for_free_request(struct TCP_Server_Info *server, const int long=
_op)
> +wait_for_free_credits(struct TCP_Server_Info *server, unsigned int *=
num)
> =A0{
> =A0 =A0 =A0 =A0int rc;
>
> - =A0 =A0 =A0 spin_lock(&server->req_lock);
> -
> - =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->credits--;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->req_lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0while (1) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->credits <=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (*num =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&server->r=
eq_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_num_waiters_inc(s=
erver);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D wait_event_inte=
rruptible(server->request_q,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 get_credits(server) > 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 has_free_credits(server, num));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_num_waiters_dec(s=
erver);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&server->req=
_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=
=3D CifsExiting) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&server->req_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->tcpStatus =3D=
=3D CifsExiting)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 -ENOENT;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->credits--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *num -=3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->in_flight++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&server->re=
q_lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +static int
> +wait_for_free_request(struct TCP_Server_Info *server, const int opty=
pe)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 spin_lock(&server->req_lock);
> + =A0 =A0 =A0 rc =3D wait_for_free_credits(server, get_credits_field(=
server, optype));
> + =A0 =A0 =A0 spin_unlock(&server->req_lock);
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_b=
uf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct mid_q_entry **p=
pmidQ)
> =A0{
> @@ -342,13 +339,13 @@ wait_for_response(struct TCP_Server_Info *serve=
r, struct mid_q_entry *midQ)
> =A0int
> =A0cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec, mid_receive_t *rece=
ive,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata,=
 bool ignore_pend)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata,=
 int optype)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid;
> =A0 =A0 =A0 =A0struct smb_hdr *hdr =3D (struct smb_hdr *)iov[0].iov_b=
ase;
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(server, ignore_pend ? CIFS=
_ASYNC_OP : 0);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(server, optype);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -360,7 +357,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> =A0 =A0 =A0 =A0mid =3D AllocMidQEntry(hdr, server);
> =A0 =A0 =A0 =A0if (mid =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(server, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0}
> @@ -393,7 +390,7 @@ cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> =A0 =A0 =A0 =A0return rc;
> =A0out_err:
> =A0 =A0 =A0 =A0delete_mid(mid);
> - =A0 =A0 =A0 add_credits(server, 1);
> + =A0 =A0 =A0 add_credits(server, 1, optype);
> =A0 =A0 =A0 =A0wake_up(&server->request_q);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -526,10 +523,12 @@ SendReceive2(const unsigned int xid, struct cif=
s_ses *ses,
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int long_op;
> + =A0 =A0 =A0 int optype;
> =A0 =A0 =A0 =A0struct mid_q_entry *midQ;
> =A0 =A0 =A0 =A0struct smb_hdr *in_buf =3D iov[0].iov_base;
>
> =A0 =A0 =A0 =A0long_op =3D flags & CIFS_TIMEOUT_MASK;
> + =A0 =A0 =A0 optype =3D flags & CIFS_REQ_MASK;
>
> =A0 =A0 =A0 =A0*pRespBufType =3D CIFS_NO_BUFFER; =A0/* no response bu=
f yet */
>
> @@ -548,7 +547,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 to the same server. We may make this configurable=
 later or
> =A0 =A0 =A0 =A0 =A0 use ses->maxReq */
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, optype);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> @@ -565,7 +564,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Update # of requests on wire to ser=
ver */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -602,7 +601,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->callback =3D Del=
eteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release=
(in_buf);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server=
, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server=
, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->=
request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -613,7 +612,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, optype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -638,7 +637,7 @@ SendReceive2(const unsigned int xid, struct cifs_=
ses *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->resp_buf =3D NULL;
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 add_credits(ses->server, 1, optype);
> =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
>
> =A0 =A0 =A0 =A0return rc;
> @@ -675,7 +674,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
> + =A0 =A0 =A0 rc =3D wait_for_free_request(ses->server, 0);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -689,7 +688,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Update # of requests on wire to ser=
ver */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -722,7 +721,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no longer considere=
d to be "in-flight" */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->callback =3D Del=
eteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(&GlobalMid=
_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server=
, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server=
, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->=
request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -731,7 +730,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -748,7 +747,7 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> =A0 =A0 =A0 =A0rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
>
> =A0 =A0 =A0 =A0return rc;
> @@ -827,7 +826,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0rc =3D allocate_mid(ses, in_buf, &midQ);
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -836,7 +835,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete_mid(midQ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&ses->server->srv_mutex);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -850,7 +849,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
>
> =A0 =A0 =A0 =A0if (rc < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -873,7 +872,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D send_nt_cancel(=
ses->server, in_buf, midQ);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete=
_mid(midQ);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_u=
p(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -887,7 +886,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 already been remo=
ved. Don't exit in this case. */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc && rc !=3D -ENO=
LCK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0delete=
_mid(midQ);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_u=
p(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -901,7 +900,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* no =
longer considered to be "in-flight" */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0midQ->=
callback =3D DeleteMidQEntry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_u=
nlock(&GlobalMid_Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_cre=
dits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_u=
p(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return=
 rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -914,7 +913,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
>
> =A0 =A0 =A0 =A0rc =3D cifs_sync_mid_result(midQ, ses->server);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> @@ -931,7 +930,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0rc =3D cifs_check_receive(midQ, ses->server, 0);
> =A0out:
> =A0 =A0 =A0 =A0delete_mid(midQ);
> - =A0 =A0 =A0 add_credits(ses->server, 1);
> + =A0 =A0 =A0 add_credits(ses->server, 1, 0);
> =A0 =A0 =A0 =A0wake_up(&ses->server->request_q);
> =A0 =A0 =A0 =A0if (rstart && rc =3D=3D -EACCES)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ERESTARTSYS;
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
