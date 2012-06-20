From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v5 2/5] CIFS: Extend credit mechanism to process request type
Date: Wed, 20 Jun 2012 11:12:29 +0400
Message-ID: <CAKywueTRiqkBDmuSah_q1O48S25qM6CP4F6bCchBaLZOJEb1gw@mail.gmail.com>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-3-git-send-email-pshilovsky@samba.org>
	<20120619083156.761f8a31@corrin.poochiereds.net>
	<CAKywueQw8YaZ0=3Mv-UNZxur=dg_D59m352Msq+hZjsWEHqr1A@mail.gmail.com>
	<20120619150017.73546a39@corrin.poochiereds.net>
	<CAH2r5muXdc708-HtceH02y8TBcoAXmi_qjyay0qHeZdtmoxVZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muXdc708-HtceH02y8TBcoAXmi_qjyay0qHeZdtmoxVZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/6/20 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Wed, Jun 20, 2012 at 12:00 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> On Tue, 19 Jun 2012 23:53:06 +0400
>> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>
>>> 2012/6/19 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>>> > On Sat, =A09 Jun 2012 10:26:01 +0400
>>> > Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>>> >
>>> >> Split all requests to echos, oplocks and others - each group use=
s
>>> >> its own credit slot. This is indicated by new flags
>>> >>
>>> >> CIFS_ECHO_OP and CIFS_OBREAK_OP
>>> >>
>>> >> that are not used now for CIFS. This change is required to suppo=
rt
>>> >> SMB2 protocol because of different processing of these commands.
>>> >>
>>> >> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>> >> ---
>>> >> =A0fs/cifs/cifsglob.h =A0| =A0 16 +++++++++++---
>>> >> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>>> >> =A0fs/cifs/cifssmb.c =A0 | =A0 21 ++++++++++---------
>>> >> =A0fs/cifs/smb1ops.c =A0 | =A0 12 +++++++++-
>>> >> =A0fs/cifs/transport.c | =A0 54 +++++++++++++++++++++++++++++---=
------------------
>>> >> =A05 files changed, 65 insertions(+), 40 deletions(-)
>>> >>
>>> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>>> >> index 2aac4e5..844b77c 100644
>>> >> --- a/fs/cifs/cifsglob.h
>>> >> +++ b/fs/cifs/cifsglob.h
>>> >> @@ -171,9 +171,11 @@ struct smb_version_operations {
>>> >> =A0 =A0 =A0 /* check response: verify signature, map error */
>>> >> =A0 =A0 =A0 int (*check_receive)(struct mid_q_entry *, struct TC=
P_Server_Info *,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool);
>>> >> - =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const un=
signed int);
>>> >> + =A0 =A0 void (*add_credits)(struct TCP_Server_Info *, const un=
signed int,
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int);
>>> >> =A0 =A0 =A0 void (*set_credits)(struct TCP_Server_Info *, const =
int);
>>> >> - =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *);
>>> >> + =A0 =A0 int * (*get_credits_field)(struct TCP_Server_Info *, c=
onst int);
>>> >> + =A0 =A0 unsigned int (*get_credits)(struct mid_q_entry *);
>>> >> =A0 =A0 =A0 __u64 (*get_next_mid)(struct TCP_Server_Info *);
>>> >> =A0 =A0 =A0 /* data offset from read response message */
>>> >> =A0 =A0 =A0 unsigned int (*read_data_offset)(char *);
>>> >> @@ -392,9 +394,10 @@ has_credits(struct TCP_Server_Info *server,=
 int *credits)
>>> >> =A0}
>>> >>
>>> >> =A0static inline void
>>> >> -add_credits(struct TCP_Server_Info *server, const unsigned int =
add)
>>> >> +add_credits(struct TCP_Server_Info *server, const unsigned int =
add,
>>> >> + =A0 =A0 =A0 =A0 const int optype)
>>> >> =A0{
>>> >> - =A0 =A0 server->ops->add_credits(server, add);
>>> >> + =A0 =A0 server->ops->add_credits(server, add, optype);
>>> >> =A0}
>>> >>
>>> >> =A0static inline void
>>> >> @@ -957,6 +960,11 @@ static inline void free_dfs_info_array(stru=
ct dfs_info3_param *param,
>>> >> =A0#define =A0 CIFS_LARGE_BUF_OP 0x020 =A0 =A0/* large request b=
uffer */
>>> >> =A0#define =A0 CIFS_NO_RESP =A0 =A0 =A00x040 =A0 =A0/* no respon=
se buffer required */
>>> >>
>>> >> +/* Type of request operation */
>>> >> +#define =A0 CIFS_ECHO_OP =A0 =A0 =A00x080 =A0 =A0/* echo reques=
t */
>>> >> +#define =A0 CIFS_OBREAK_OP =A0 0x0100 =A0 =A0/* oplock break re=
quest */
>>> >> +#define =A0 CIFS_OP_MASK =A0 =A0 0x0180 =A0 =A0/* mask request =
type */
>>> >> +
>>> >> =A0/* Security Flags: indicate type of session setup needed */
>>> >> =A0#define =A0 CIFSSEC_MAY_SIGN =A0 0x00001
>>> >> =A0#define =A0 CIFSSEC_MAY_NTLM =A0 0x00002
>>> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>>> >> index 0a6cbfe..8c1c7c1 100644
>>> >> --- a/fs/cifs/cifsproto.h
>>> >> +++ b/fs/cifs/cifsproto.h
>>> >> @@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry=
 *midEntry);
>>> >> =A0extern int cifs_call_async(struct TCP_Server_Info *server, st=
ruct kvec *iov,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int =
nvec, mid_receive_t *receive,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mid_callback_=
t *callback, void *cbdata,
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool ignore_pen=
d);
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int flags=
);
>>> >> =A0extern int SendReceive(const unsigned int /* xid */ , struct =
cifs_ses *,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* =
input */ ,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* =
out */ ,
>>> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>>> >> index 5b40073..58f1ab5 100644
>>> >> --- a/fs/cifs/cifssmb.c
>>> >> +++ b/fs/cifs/cifssmb.c
>>> >> @@ -720,7 +720,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>>> >> =A0 =A0 =A0 struct TCP_Server_Info *server =3D mid->callback_dat=
a;
>>> >>
>>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>>> >> - =A0 =A0 add_credits(server, 1);
>>> >> + =A0 =A0 add_credits(server, 1, CIFS_ECHO_OP);
>>> >> =A0}
>>> >>
>>> >> =A0int
>>> >> @@ -747,7 +747,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>>> >> =A0 =A0 =A0 iov.iov_len =3D be32_to_cpu(smb->hdr.smb_buf_length)=
 + 4;
>>> >>
>>> >> =A0 =A0 =A0 rc =3D cifs_call_async(server, &iov, 1, NULL, cifs_e=
cho_callback,
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, tru=
e);
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server, CIF=
S_ASYNC_OP | CIFS_ECHO_OP);
>>> >> =A0 =A0 =A0 if (rc)
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Echo request failed: %d", r=
c);
>>> >>
>>> >> @@ -1563,7 +1563,7 @@ cifs_readv_callback(struct mid_q_entry *mi=
d)
>>> >>
>>> >> =A0 =A0 =A0 queue_work(cifsiod_wq, &rdata->work);
>>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>>> >> - =A0 =A0 add_credits(server, 1);
>>> >> + =A0 =A0 add_credits(server, 1, 0);
>>> >> =A0}
>>> >>
>>> >> =A0/* cifs_async_readv - send an async write, and set up mid to =
handle result */
>>> >> @@ -1619,7 +1619,7 @@ cifs_async_readv(struct cifs_readdata *rda=
ta)
>>> >> =A0 =A0 =A0 kref_get(&rdata->refcount);
>>> >> =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, rdata->iov=
, 1,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_read=
v_receive, cifs_readv_callback,
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, fals=
e);
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rdata, 0);
>>> >>
>>> >> =A0 =A0 =A0 if (rc =3D=3D 0)
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_reads);
>>> >> @@ -2010,7 +2010,7 @@ cifs_writev_callback(struct mid_q_entry *m=
id)
>>> >>
>>> >> =A0 =A0 =A0 queue_work(cifsiod_wq, &wdata->work);
>>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>>> >> - =A0 =A0 add_credits(tcon->ses->server, 1);
>>> >> + =A0 =A0 add_credits(tcon->ses->server, 1, 0);
>>> >> =A0}
>>> >>
>>> >> =A0/* cifs_async_writev - send an async write, and set up mid to=
 handle result */
>>> >> @@ -2090,7 +2090,7 @@ cifs_async_writev(struct cifs_writedata *w=
data)
>>> >>
>>> >> =A0 =A0 =A0 kref_get(&wdata->refcount);
>>> >> =A0 =A0 =A0 rc =3D cifs_call_async(tcon->ses->server, iov, wdata=
->nr_pages + 1,
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_=
writev_callback, wdata, false);
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, cifs_=
writev_callback, wdata, 0);
>>> >>
>>> >> =A0 =A0 =A0 if (rc =3D=3D 0)
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_stats_inc(&tcon->num_writes);
>>> >> @@ -2268,7 +2268,7 @@ CIFSSMBLock(const int xid, struct cifs_tco=
n *tcon,
>>> >> =A0 =A0 =A0 LOCK_REQ *pSMB =3D NULL;
>>> >> =A0/* =A0 LOCK_RSP *pSMBr =3D NULL; */ /* No response data other=
 than rc to parse */
>>> >> =A0 =A0 =A0 int bytes_returned;
>>> >> - =A0 =A0 int timeout =3D 0;
>>> >> + =A0 =A0 int flags =3D 0;
>>> >> =A0 =A0 =A0 __u16 count;
>>> >>
>>> >> =A0 =A0 =A0 cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)wa=
itFlag, numLock);
>>> >> @@ -2278,10 +2278,11 @@ CIFSSMBLock(const int xid, struct cifs_t=
con *tcon,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>> >>
>>> >> =A0 =A0 =A0 if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_ASYNC_OP; /* no respo=
nse expected */
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 /* no response expected */
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 flags =3D CIFS_ASYNC_OP | CIFS_OBREAK_=
OP;
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D 0;
>>> >> =A0 =A0 =A0 } else if (waitFlag) {
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 timeout =3D CIFS_BLOCKING_OP; /* block=
ing operation, no timeout */
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 flags =3D CIFS_BLOCKING_OP; /* blockin=
g operation, no timeout */
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D cpu_to_le32(-1);/*=
 blocking - do not time out */
>>> >> =A0 =A0 =A0 } else {
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->Timeout =3D 0;
>>> >> @@ -2314,7 +2315,7 @@ CIFSSMBLock(const int xid, struct cifs_tco=
n *tcon,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) p=
SMB, &bytes_returned);
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(pSMB);
>>> >> =A0 =A0 =A0 } else {
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses=
, (char *)pSMB, timeout);
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses=
, (char *)pSMB, flags);
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* SMB buffer freed by function abov=
e */
>>> >> =A0 =A0 =A0 }
>>> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_locks);
>>> >> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>>> >> index 28359e7..f4f8394 100644
>>> >> --- a/fs/cifs/smb1ops.c
>>> >> +++ b/fs/cifs/smb1ops.c
>>> >> @@ -101,7 +101,8 @@ cifs_find_mid(struct TCP_Server_Info *server=
, char *buffer)
>>> >> =A0}
>>> >>
>>> >> =A0static void
>>> >> -cifs_add_credits(struct TCP_Server_Info *server, const unsigned=
 int add)
>>> >> +cifs_add_credits(struct TCP_Server_Info *server, const unsigned=
 int add,
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0const int optype)
>>> >> =A0{
>>> >> =A0 =A0 =A0 spin_lock(&server->req_lock);
>>> >> =A0 =A0 =A0 server->credits +=3D add;
>>> >> @@ -120,11 +121,17 @@ cifs_set_credits(struct TCP_Server_Info *s=
erver, const int val)
>>> >> =A0}
>>> >>
>>> >> =A0static int *
>>> >> -cifs_get_credits_field(struct TCP_Server_Info *server)
>>> >> +cifs_get_credits_field(struct TCP_Server_Info *server, const in=
t optype)
>>> >> =A0{
>>> >> =A0 =A0 =A0 return &server->credits;
>>> >> =A0}
>>> >>
>>> >> +static unsigned int
>>> >> +cifs_get_credits(struct mid_q_entry *mid)
>>> >> +{
>>> >> + =A0 =A0 return 1;
>>> >> +}
>>> >> +
>>> >> =A0/*
>>> >> =A0 * Find a free multiplex id (SMB mid). Otherwise there could =
be
>>> >> =A0 * mid collisions which might cause problems, demultiplexing =
the
>>> >> @@ -390,6 +397,7 @@ struct smb_version_operations smb1_operation=
s =3D {
>>> >> =A0 =A0 =A0 .add_credits =3D cifs_add_credits,
>>> >> =A0 =A0 =A0 .set_credits =3D cifs_set_credits,
>>> >> =A0 =A0 =A0 .get_credits_field =3D cifs_get_credits_field,
>>> >> + =A0 =A0 .get_credits =3D cifs_get_credits,
>>> >> =A0 =A0 =A0 .get_next_mid =3D cifs_get_next_mid,
>>> >> =A0 =A0 =A0 .read_data_offset =3D cifs_read_data_offset,
>>> >> =A0 =A0 =A0 .read_data_length =3D cifs_read_data_length,
>>> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>>> >> index 3097ee5..54cd8dd 100644
>>> >> --- a/fs/cifs/transport.c
>>> >> +++ b/fs/cifs/transport.c
>>> >> @@ -254,13 +254,13 @@ smb_send(struct TCP_Server_Info *server, s=
truct smb_hdr *smb_buffer,
>>> >> =A0}
>>> >>
>>> >> =A0static int
>>> >> -wait_for_free_credits(struct TCP_Server_Info *server, const int=
 optype,
>>> >> +wait_for_free_credits(struct TCP_Server_Info *server, const int=
 long_op,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *credits)
>>> >> =A0{
>>> >> =A0 =A0 =A0 int rc;
>>> >>
>>> >> =A0 =A0 =A0 spin_lock(&server->req_lock);
>>> >> - =A0 =A0 if (optype =3D=3D CIFS_ASYNC_OP) {
>>> >> + =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up=
 */
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->in_flight++;
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 *credits -=3D 1;
>>> >> @@ -290,7 +290,7 @@ wait_for_free_credits(struct TCP_Server_Info=
 *server, const int optype,
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>>> >>
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update # of reque=
sts on the wire to server */
>>> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (optype !=3D CIFS_B=
LOCKING_OP) {
>>> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_=
BLOCKING_OP) {
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *cre=
dits -=3D 1;
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 serv=
er->in_flight++;
>>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>> >
>>> > Why rename the variable in this above function? "optype" seems li=
ke a better name...
>>>
>>> That was done to make variable names the same: 'optype' is used to
>>> indicate if it is echo, oplock or other operation, 'long_op' is use=
d
>>> to indicate if we need any special behavior (aysnc, blocking).
>>>
>>> wait_for_free_request function (below) takes both 'optype' and
>>> 'long_op' and passes 'long_op' to wait_for_free_credits. It is clea=
ner
>>> if wait_for_free_credits uses the same name - 'long_op'.
>>>
>>> Of course, 'long_op' may be not so good name at all (I took it from
>>> the old code) - suggestions are welcome.
>>>
>>
>> Yeah, I think that's the confusion. "long_op" was from when those fl=
ags
>> were supposed to indicate the length of the operation so the code co=
uld
>> adjust the timeout. Maybe a better name is something generic like
>> "flags" ?
>
> "flags" is fine with me

'flags' is suppose to indicate all request flags (credit slot,
timeout, etc). As soon as we mask CIFS_ASYNC_OP and CIFS_BLOCKING_OP
with CIFS_TIMEOUT_MASK macro we should use something close to it: e.g.
optimeout, timeout, etc.

I think we can rethink names of mask macro and variables further -
let's not stop on this.

--=20
Best regards,
Pavel Shilovsky.
