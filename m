From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v5 2/5] CIFS: Extend credit mechanism to process request type
Date: Tue, 19 Jun 2012 23:53:06 +0400
Message-ID: <CAKywueQw8YaZ0=3Mv-UNZxur=dg_D59m352Msq+hZjsWEHqr1A@mail.gmail.com>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-3-git-send-email-pshilovsky@samba.org>
	<20120619083156.761f8a31@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120619083156.761f8a31-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sat, =A09 Jun 2012 10:26:01 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Split all requests to echos, oplocks and others - each group uses
>> its own credit slot. This is indicated by new flags
>>
>> CIFS_ECHO_OP and CIFS_OBREAK_OP
>>
>> that are not used now for CIFS. This change is required to support
>> SMB2 protocol because of different processing of these commands.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 16 +++++++++++---
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 21 ++++++++++---------
>> =A0fs/cifs/smb1ops.c =A0 | =A0 12 +++++++++-
>> =A0fs/cifs/transport.c | =A0 54 +++++++++++++++++++++++++++++-------=
--------------
>> =A05 files changed, 65 insertions(+), 40 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 2aac4e5..844b77c 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -171,9 +171,11 @@ struct smb_version_operations {
>> =A0 =A0 =A0 /* check response: verify signature, map error */
>> =A0 =A0 =A0 int (*check_receive)(struct mid_q_entry *, struct TCP_Se=
rver_Info *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool);
>> - =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const unsign=
ed int);
>> + =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const unsign=
ed int,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int);
>> =A0 =A0 =A0 void (*set_credits)(struct TCP_Server_Info *, const int)=
;
>> - =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *);
>> + =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *, const=
 int);
>> + =A0 =A0 unsigned int (*get_credits)(struct mid_q_entry *);
>> =A0 =A0 =A0 __u64 (*get_next_mid)(struct TCP_Server_Info *);
>> =A0 =A0 =A0 /* data offset from read response message */
>> =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
>> @@ -392,9 +394,10 @@ has_credits(struct TCP_Server_Info *server, int=
 *credits)
>> =A0}
>>
>> =A0static inline void
>> -add_credits(struct TCP_Server_Info *server, const unsigned int add)
>> +add_credits(struct TCP_Server_Info *server, const unsigned int add,
>> + =A0 =A0 =A0 =A0 const int optype)
>> =A0{
>> - =A0 =A0 server->ops->add_credits(server, add);
>> + =A0 =A0 server->ops->add_credits(server, add, optype);
>> =A0}
>>
>> =A0static inline void
>> @@ -957,6 +960,11 @@ static inline void free_dfs_info_array(struct d=
fs_info3_param *param,
>> =A0#define =A0 CIFS_LARGE_BUF_OP 0x020 =A0 =A0/* large request buffe=
r */
>> =A0#define =A0 CIFS_NO_RESP =A0 =A0 =A00x040 =A0 =A0/* no response b=
uffer required */
>>
>> +/* Type of request operation */
>> +#define =A0 CIFS_ECHO_OP =A0 =A0 =A00x080 =A0 =A0/* echo request */
>> +#define =A0 CIFS_OBREAK_OP =A0 0x0100 =A0 =A0/* oplock break reques=
t */
>> +#define =A0 CIFS_OP_MASK =A0 =A0 0x0180 =A0 =A0/* mask request type=
 */
>> +
>> =A0/* Security Flags: indicate type of session setup needed */
>> =A0#define =A0 CIFSSEC_MAY_SIGN =A0 0x00001
>> =A0#define =A0 CIFSSEC_MAY_NTLM =A0 0x00002
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 0a6cbfe..8c1c7c1 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *mi=
dEntry);
>> =A0extern int cifs_call_async(struct TCP_Server_Info *server, struct=
 kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int nvec=
, mid_receive_t *receive,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_t *c=
allback, void *cbdata,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool ignore_pend);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int flags);
>> =A0extern int SendReceive(const unsigned int /* xid */ , struct cifs=
_ses *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* inpu=
t */ ,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* out =
*/ ,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 5b40073..58f1ab5 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -720,7 +720,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>> =A0 =A0 =A0 struct TCP_Server_Info *server =3D mid->callback_data;
>>
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> - =A0 =A0 add_credits(server, 1);
>> + =A0 =A0 add_credits(server, 1, CIFS_ECHO_OP);
>> =A0}
>>
>> =A0int
>> @@ -747,7 +747,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>> =A0 =A0 =A0 iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length) + 4=
;
>>
>> =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, NULL, cifs_echo_=
callback,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, true);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, CIFS_AS=
YNC_OP | CIFS_ECHO_OP);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Echo request failed: %d", rc);
>>
>> @@ -1563,7 +1563,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>>
>> =A0 =A0 =A0 queue_work(cifsiod_wq, &rdata->work);
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> - =A0 =A0 add_credits(server, 1);
>> + =A0 =A0 add_credits(server, 1, 0);
>> =A0}
>>
>> =A0/* cifs_async_readv - send an async write, and set up mid to hand=
le result */
>> @@ -1619,7 +1619,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
>> =A0 =A0 =A0 kref_get(&rdata->refcount);
>> =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, rdata->iov, 1,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_readv_re=
ceive, cifs_readv_callback,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, 0);
>>
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_reads);
>> @@ -2010,7 +2010,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>>
>> =A0 =A0 =A0 queue_work(cifsiod_wq, &wdata->work);
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> - =A0 =A0 add_credits(tcon->ses->server, 1);
>> + =A0 =A0 add_credits(tcon->ses->server, 1, 0);
>> =A0}
>>
>> =A0/* cifs_async_writev - send an async write, and set up mid to han=
dle result */
>> @@ -2090,7 +2090,7 @@ cifs_async_writev(struct cifs_writedata *wdata=
)
>>
>> =A0 =A0 =A0 kref_get(&wdata->refcount);
>> =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, iov, wdata->nr=
_pages + 1,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_writ=
ev_callback, wdata, false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_writ=
ev_callback, wdata, 0);
>>
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_writes);
>> @@ -2268,7 +2268,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *t=
con,
>> =A0 =A0 =A0 LOCK_REQ *pSMB =3D NULL;
>> =A0/* =A0 LOCK_RSP *pSMBr =3D NULL; */ /* No response data other tha=
n rc to parse */
>> =A0 =A0 =A0 int bytes_returned;
>> - =A0 =A0 int timeout =3D 0;
>> + =A0 =A0 int flags =3D 0;
>> =A0 =A0 =A0 __u16 count;
>>
>> =A0 =A0 =A0 cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)waitFl=
ag, numLock);
>> @@ -2278,10 +2278,11 @@ CIFSSMBLock(const int xid, struct cifs_tcon =
*tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> =A0 =A0 =A0 if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_ASYNC_OP; /* no response =
expected */
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* no response expected */
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags =3D CIFS_ASYNC_OP | CIFS_OBREAK_OP;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D 0;
>> =A0 =A0 =A0 } else if (waitFlag) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_BLOCKING_OP; /* blocking =
operation, no timeout */
>> + =A0 =A0 =A0 =A0 =A0 =A0 flags =3D CIFS_BLOCKING_OP; /* blocking op=
eration, no timeout */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D cpu_to_le32(-1);/* blo=
cking - do not time out */
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D 0;
>> @@ -2314,7 +2315,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *t=
con,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMB,=
 &bytes_returned);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(pSMB);
>> =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (c=
har *)pSMB, timeout);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (c=
har *)pSMB, flags);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* SMB buffer freed by function above */
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_locks);
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index 28359e7..f4f8394 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -101,7 +101,8 @@ cifs_find_mid(struct TCP_Server_Info *server, ch=
ar *buffer)
>> =A0}
>>
>> =A0static void
>> -cifs_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add)
>> +cifs_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0const int optype)
>> =A0{
>> =A0 =A0 =A0 spin_lock(&server->req_lock);
>> =A0 =A0 =A0 server->credits +=3D add;
>> @@ -120,11 +121,17 @@ cifs_set_credits(struct TCP_Server_Info *serve=
r, const int val)
>> =A0}
>>
>> =A0static int *
>> -cifs_get_credits_field(struct TCP_Server_Info *server)
>> +cifs_get_credits_field(struct TCP_Server_Info *server, const int op=
type)
>> =A0{
>> =A0 =A0 =A0 return &server->credits;
>> =A0}
>>
>> +static unsigned int
>> +cifs_get_credits(struct mid_q_entry *mid)
>> +{
>> + =A0 =A0 return 1;
>> +}
>> +
>> =A0/*
>> =A0 * Find a free multiplex id (SMB mid). Otherwise there could be
>> =A0 * mid collisions which might cause problems, demultiplexing the
>> @@ -390,6 +397,7 @@ struct smb_version_operations smb1_operations =3D=
 {
>> =A0 =A0 =A0 .add_credits =3D cifs_add_credits,
>> =A0 =A0 =A0 .set_credits =3D cifs_set_credits,
>> =A0 =A0 =A0 .get_credits_field =3D cifs_get_credits_field,
>> + =A0 =A0 .get_credits =3D cifs_get_credits,
>> =A0 =A0 =A0 .get_next_mid =3D cifs_get_next_mid,
>> =A0 =A0 =A0 .read_data_offset =3D cifs_read_data_offset,
>> =A0 =A0 =A0 .read_data_length =3D cifs_read_data_length,
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 3097ee5..54cd8dd 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -254,13 +254,13 @@ smb_send(struct TCP_Server_Info *server, struc=
t smb_hdr *smb_buffer,
>> =A0}
>>
>> =A0static int
>> -wait_for_free_credits(struct TCP_Server_Info *server, const int opt=
ype,
>> +wait_for_free_credits(struct TCP_Server_Info *server, const int lon=
g_op,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *credits)
>> =A0{
>> =A0 =A0 =A0 int rc;
>>
>> =A0 =A0 =A0 spin_lock(&server->req_lock);
>> - =A0 =A0 if (optype =3D=3D CIFS_ASYNC_OP) {
>> + =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *credits -=3D 1;
>> @@ -290,7 +290,7 @@ wait_for_free_credits(struct TCP_Server_Info *se=
rver, const int optype,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update # of requests =
on the wire to server */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (optype !=3D CIFS_BLOCK=
ING_OP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_BLOC=
KING_OP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *credits=
 -=3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->=
in_flight++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
> Why rename the variable in this above function? "optype" seems like a=
 better name...

That was done to make variable names the same: 'optype' is used to
indicate if it is echo, oplock or other operation, 'long_op' is used
to indicate if we need any special behavior (aysnc, blocking).

wait_for_free_request function (below) takes both 'optype' and
'long_op' and passes 'long_op' to wait_for_free_credits. It is cleaner
if wait_for_free_credits uses the same name - 'long_op'.

Of course, 'long_op' may be not so good name at all (I took it from
the old code) - suggestions are welcome.

>
>> @@ -302,10 +302,11 @@ wait_for_free_credits(struct TCP_Server_Info *=
server, const int optype,
>> =A0}
>>
>> =A0static int
>> -wait_for_free_request(struct TCP_Server_Info *server, const int opt=
ype)
>> +wait_for_free_request(struct TCP_Server_Info *server, const int lon=
g_op,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int optype)
>> =A0{
>> - =A0 =A0 return wait_for_free_credits(server, optype,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->ops->get_credits_field(server));
>> + =A0 =A0 return wait_for_free_credits(server, long_op,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->op=
s->get_credits_field(server, optype));
>> =A0}
>>
>> =A0static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_=
buf,
>> @@ -384,12 +385,15 @@ cifs_setup_async_request(struct TCP_Server_Inf=
o *server, struct kvec *iov,
>> =A0int
>> =A0cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int nvec, mid_receive_t *receiv=
e,
>> - =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata, bo=
ol ignore_pend)
>> + =A0 =A0 =A0 =A0 =A0 =A0 mid_callback_t *callback, void *cbdata, co=
nst int flags)
>> =A0{
>> - =A0 =A0 int rc;
>> + =A0 =A0 int rc, long_op, optype;
>> =A0 =A0 =A0 struct mid_q_entry *mid;
>>
>> - =A0 =A0 rc =3D wait_for_free_request(server, ignore_pend ? CIFS_AS=
YNC_OP : 0);
>> + =A0 =A0 long_op =3D flags & CIFS_TIMEOUT_MASK;
>> + =A0 =A0 optype =3D flags & CIFS_OP_MASK;
>> +
>> + =A0 =A0 rc =3D wait_for_free_request(server, long_op, optype);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -397,7 +401,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =A0 =A0 =A0 rc =3D cifs_setup_async_request(server, iov, nvec, &mid)=
;
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> - =A0 =A0 =A0 =A0 =A0 =A0 add_credits(server, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 add_credits(server, 1, optype);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -419,7 +423,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =A0 =A0 =A0 return rc;
>> =A0out_err:
>> =A0 =A0 =A0 delete_mid(mid);
>> - =A0 =A0 add_credits(server, 1);
>> + =A0 =A0 add_credits(server, 1, optype);
>> =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -539,11 +543,13 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0const int flags)
>> =A0{
>> =A0 =A0 =A0 int rc =3D 0;
>> - =A0 =A0 int long_op;
>> + =A0 =A0 int long_op, optype;
>> =A0 =A0 =A0 struct mid_q_entry *midQ;
>> =A0 =A0 =A0 char *buf =3D iov[0].iov_base;
>> + =A0 =A0 unsigned int credits =3D 1;
>>
>> =A0 =A0 =A0 long_op =3D flags & CIFS_TIMEOUT_MASK;
>> + =A0 =A0 optype =3D flags & CIFS_OP_MASK;
>>
>> =A0 =A0 =A0 *pRespBufType =3D CIFS_NO_BUFFER; =A0/* no response buf =
yet */
>>
>> @@ -564,7 +570,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0* use ses->maxReq.
>> =A0 =A0 =A0 =A0*/
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
>> + =A0 =A0 rc =3D wait_for_free_request(ses->server, optype, long_op)=
;
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> @@ -583,7 +589,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serve=
r */
>> - =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, optype);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> @@ -613,7 +619,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->callback =3D Delet=
eMidQEntry;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(b=
uf);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1=
, optype);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> @@ -623,7 +629,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>>
>> =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, optype);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> @@ -641,6 +647,8 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *pRespBufType =3D CIFS_SMALL_BUFFER;
>>
>> + =A0 =A0 credits =3D ses->server->ops->get_credits(midQ);
>> +
>> =A0 =A0 =A0 rc =3D ses->server->ops->check_receive(midQ, ses->server=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0flags & CIFS_LOG_ERROR);
>>
>> @@ -649,7 +657,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->resp_buf =3D NULL;
>> =A0out:
>> =A0 =A0 =A0 delete_mid(midQ);
>> - =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 add_credits(ses->server, credits, optype);
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -685,7 +693,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, long_op);
>> + =A0 =A0 rc =3D wait_for_free_request(ses->server, 0, long_op);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> @@ -699,7 +707,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serve=
r */
>> - =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> @@ -731,7 +739,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* no longer considered =
to be "in-flight" */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->callback =3D Delet=
eMidQEntry;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1=
, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> @@ -739,7 +747,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>>
>> =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 add_credits(ses->server, 1, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> @@ -755,7 +763,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =A0out:
>> =A0 =A0 =A0 delete_mid(midQ);
>> - =A0 =A0 add_credits(ses->server, 1);
>> + =A0 =A0 add_credits(ses->server, 1, 0);
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -820,7 +828,7 @@ SendReceiveBlockingLock(const unsigned int xid, =
struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP=
);
>> + =A0 =A0 rc =3D wait_for_free_request(ses->server, 0, CIFS_BLOCKING=
_OP);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>
> Other than the nit about renaming that variable, this looks reasonabl=
e,
> at least until we can come up with a better scheme to handle this...
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Best regards,
Pavel Shilovsky.
