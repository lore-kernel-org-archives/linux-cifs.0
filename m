From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v2 03/11] CIFS: Introduce credit-based flow control
Date: Sat, 17 Mar 2012 18:56:22 +0400
Message-ID: <CAKywueQiOf3QsAwN3XCDv0VTuQR5VdmWCCNgsGsm1QQaHh47Hw@mail.gmail.com>
References: <1331910574-998-1-git-send-email-piastry@etersoft.ru>
	<1331910574-998-4-git-send-email-piastry@etersoft.ru>
	<20120317063258.77618c0e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120317063258.77618c0e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

17 =CD=C1=D2=D4=C1 2012=9A=C7. 14:32 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Fri, 16 Mar 2012 18:09:26 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> and send no more than credits value requests at once. For SMB/CIFS
>> it's trivial: increment this value by receiving any message and
>> decrement by sending one.
>>
>
> The existing code essentially "hardcodes" a value of 50 instead of
> using maxReq. While I think that's wrong, if you change that behavior
> in the first patch, it's going to make tracking down any regressions
> from this very difficult.
>
> I think it might be better to have this series introduce no behaviora=
l
> changes at all, and simply reorganize the code around a credit-based
> model. Once that's complete and working, then do a patch that makes t=
he
> code respect maxReq.
>
> I know that that's more work, but we do need to be careful when we're
> tinkering with the low-level plumbing like this...
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/cifsglob.h =9A| =9A 11 +++++++----
>> =9Afs/cifs/cifsproto.h | =9A =9A3 +++
>> =9Afs/cifs/cifssmb.c =9A | =9A 10 +++++-----
>> =9Afs/cifs/connect.c =9A | =9A 14 ++++++--------
>> =9Afs/cifs/misc.c =9A =9A =9A| =9A 18 ++++++++++++++++++
>> =9Afs/cifs/transport.c | =9A 36 ++++++++++++++++++++----------------
>> =9A6 files changed, 59 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index fb78bc9..d55de96 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -250,8 +250,9 @@ struct TCP_Server_Info {
>> =9A =9A =9A bool noblocksnd; =9A =9A =9A =9A =9A =9A =9A =9A/* use b=
locking sendmsg */
>> =9A =9A =9A bool noautotune; =9A =9A =9A =9A =9A =9A =9A =9A/* do no=
t autotune send buf sizes */
>> =9A =9A =9A bool tcp_nodelay;
>> + =9A =9A int credits; =9A/* send no more requests at once */
>> =9A =9A =9A unsigned int in_flight; =9A/* number of requests on the =
wire to server */
>> - =9A =9A spinlock_t req_lock; /* protect the value above */
>> + =9A =9A spinlock_t req_lock; =9A/* protect the two values above */
>> =9A =9A =9A struct mutex srv_mutex;
>> =9A =9A =9A struct task_struct *tsk;
>> =9A =9A =9A char server_GUID[16];
>> @@ -314,12 +315,14 @@ in_flight(struct TCP_Server_Info *server)
>> =9A =9A =9A return num;
>> =9A}
>>
>> -static inline void
>> -dec_in_flight(struct TCP_Server_Info *server)
>> +static inline bool
>> +has_credits(struct TCP_Server_Info *server)
>> =9A{
>> + =9A =9A int num;
>> =9A =9A =9A spin_lock(&server->req_lock);
>> - =9A =9A server->in_flight--;
>> + =9A =9A num =3D server->credits;
>> =9A =9A =9A spin_unlock(&server->req_lock);
>> + =9A =9A return num > 0;
>> =9A}
>>
>> =9A/*
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 6f4e243..47a769e 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -88,6 +88,9 @@ extern int SendReceiveBlockingLock(const unsigned =
int xid,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct smb_hdr *in_buf ,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A struct smb_hdr *out_buf,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A int *bytes_returned);
>> +extern void cifs_add_credits(struct TCP_Server_Info *server,
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Aconst unsigned =
int add);
>> +extern void cifs_set_credits(struct TCP_Server_Info *server, const =
int val);
>> =9Aextern int checkSMB(struct smb_hdr *smb, __u16 mid, unsigned int =
length);
>> =9Aextern bool is_valid_oplock_break(struct smb_hdr *smb,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A stru=
ct TCP_Server_Info *);
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index d7cbcfa..08c84a1 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -461,7 +461,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_s=
es *ses)
>> =9A =9A =9A =9A =9A =9A =9A server->maxReq =3D min_t(unsigned int,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9Ale16_to_cpu(rsp->MaxMpxCount),
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =
=9A =9Acifs_max_pending);
>> - =9A =9A =9A =9A =9A =9A server->oplocks =3D server->maxReq > 1 ? e=
nable_oplocks : false;
>> + =9A =9A =9A =9A =9A =9A cifs_set_credits(server, server->maxReq);
>> =9A =9A =9A =9A =9A =9A =9A server->maxBuf =3D le16_to_cpu(rsp->MaxB=
ufSize);
>> =9A =9A =9A =9A =9A =9A =9A server->max_vcs =3D le16_to_cpu(rsp->Max=
NumberVcs);
>> =9A =9A =9A =9A =9A =9A =9A /* even though we do not use raw we migh=
t as well set this
>> @@ -569,7 +569,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_s=
es *ses)
>> =9A =9A =9A =9A =9Alittle endian */
>> =9A =9A =9A server->maxReq =3D min_t(unsigned int, le16_to_cpu(pSMBr=
->MaxMpxCount),
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Acifs_max_=
pending);
>> - =9A =9A server->oplocks =3D server->maxReq > 1 ? enable_oplocks : =
false;
>> + =9A =9A cifs_set_credits(server, server->maxReq);
>> =9A =9A =9A /* probably no need to store and check maxvcs */
>> =9A =9A =9A server->maxBuf =3D le32_to_cpu(pSMBr->MaxBufferSize);
>> =9A =9A =9A server->max_rw =3D le32_to_cpu(pSMBr->MaxRawSize);
>> @@ -721,7 +721,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>> =9A =9A =9A struct TCP_Server_Info *server =3D mid->callback_data;
>>
>> =9A =9A =9A DeleteMidQEntry(mid);
>> - =9A =9A dec_in_flight(server);
>> + =9A =9A cifs_add_credits(server, 1);
>> =9A =9A =9A wake_up(&server->request_q);
> =9A =9A =9A =9A^^^^^^^^^
>
> The above wake_up always follows the call to cifs_add_credits. Should
> you go ahead and move it inside of cifs_add_credits?

That makes sense - will fix it when we decide what to do with the first=
 patch.

>
>
>> =9A}
>>
>> @@ -1674,7 +1674,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>>
>> =9A =9A =9A queue_work(system_nrt_wq, &rdata->work);
>> =9A =9A =9A DeleteMidQEntry(mid);
>> - =9A =9A dec_in_flight(server);
>> + =9A =9A cifs_add_credits(server, 1);
>> =9A =9A =9A wake_up(&server->request_q);
>> =9A}
>>
>> @@ -2115,7 +2115,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>>
>> =9A =9A =9A queue_work(system_nrt_wq, &wdata->work);
>> =9A =9A =9A DeleteMidQEntry(mid);
>> - =9A =9A dec_in_flight(tcon->ses->server);
>> + =9A =9A cifs_add_credits(tcon->ses->server, 1);
>> =9A =9A =9A wake_up(&tcon->ses->server->request_q);
>> =9A}
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index a7627f2..f3a0c49 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -642,14 +642,10 @@ static void clean_demultiplex_info(struct TCP_=
Server_Info *server)
>> =9A =9A =9A spin_unlock(&GlobalMid_Lock);
>> =9A =9A =9A wake_up_all(&server->response_q);
>>
>> - =9A =9A /* Check if we have blocked requests that need to free. */
>> + =9A =9A /* check if we have blocked requests that need to free */
>> =9A =9A =9A spin_lock(&server->req_lock);
>> - =9A =9A if (server->in_flight >=3D server->maxReq)
>> - =9A =9A =9A =9A =9A =9A server->in_flight =3D server->maxReq - 1;
>> - =9A =9A /*
>> - =9A =9A =9A* We do not want to set the max_pending too low or we c=
ould end up
>> - =9A =9A =9A* with the counter going negative.
>> - =9A =9A =9A*/
>> + =9A =9A if (server->credits <=3D 0)
>> + =9A =9A =9A =9A =9A =9A server->credits =3D 1;
>> =9A =9A =9A spin_unlock(&server->req_lock);
>> =9A =9A =9A /*
>> =9A =9A =9A =9A* Although there should not be any requests blocked o=
n this queue it
>> @@ -1906,7 +1902,7 @@ cifs_get_tcp_session(struct smb_vol *volume_in=
fo)
>> =9A =9A =9A tcp_ses->noautotune =3D volume_info->noautotune;
>> =9A =9A =9A tcp_ses->tcp_nodelay =3D volume_info->sockopt_tcp_nodela=
y;
>> =9A =9A =9A tcp_ses->in_flight =3D 0;
>> - =9A =9A tcp_ses->maxReq =3D 1; /* enough to send negotiate request=
 */
>> + =9A =9A tcp_ses->credits =3D 1;
>> =9A =9A =9A init_waitqueue_head(&tcp_ses->response_q);
>> =9A =9A =9A init_waitqueue_head(&tcp_ses->request_q);
>> =9A =9A =9A INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
>> @@ -3756,9 +3752,11 @@ int cifs_negotiate_protocol(unsigned int xid,=
 struct cifs_ses *ses)
>> =9A =9A =9A if (server->maxBuf !=3D 0)
>> =9A =9A =9A =9A =9A =9A =9A return 0;
>>
>> + =9A =9A cifs_set_credits(server, 1);
>> =9A =9A =9A rc =3D CIFSSMBNegotiate(xid, ses);
>> =9A =9A =9A if (rc =3D=3D -EAGAIN) {
>> =9A =9A =9A =9A =9A =9A =9A /* retry only once on 1st time connectio=
n */
>> + =9A =9A =9A =9A =9A =9A cifs_set_credits(server, 1);
>> =9A =9A =9A =9A =9A =9A =9A rc =3D CIFSSMBNegotiate(xid, ses);
>> =9A =9A =9A =9A =9A =9A =9A if (rc =3D=3D -EAGAIN)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A rc =3D -EHOSTDOWN;
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 703ef5c..5dc936b 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -690,3 +690,21 @@ backup_cred(struct cifs_sb_info *cifs_sb)
>>
>> =9A =9A =9A return false;
>> =9A}
>> +
>> +void
>> +cifs_add_credits(struct TCP_Server_Info *server, const unsigned int=
 add)
>> +{
>> + =9A =9A spin_lock(&server->req_lock);
>> + =9A =9A server->credits +=3D add;
>> + =9A =9A server->in_flight--;
>> + =9A =9A spin_unlock(&server->req_lock);
>> +}
>> +
>> +void
>> +cifs_set_credits(struct TCP_Server_Info *server, const int val)
>> +{
>> + =9A =9A spin_lock(&server->req_lock);
>> + =9A =9A server->credits =3D val;
>> + =9A =9A server->oplocks =3D val > 1 ? enable_oplocks : false;
>> + =9A =9A spin_unlock(&server->req_lock);
>> +}
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index e2673aa..e8a4fd3 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -262,16 +262,16 @@ wait_for_free_request(struct TCP_Server_Info *=
server, const int long_op)
>> =9A =9A =9A if (long_op =3D=3D CIFS_ASYNC_OP) {
>> =9A =9A =9A =9A =9A =9A =9A /* oplock breaks must not be held up */
>> =9A =9A =9A =9A =9A =9A =9A server->in_flight++;
>> + =9A =9A =9A =9A =9A =9A server->credits--;
>> =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req_lock);
>> =9A =9A =9A =9A =9A =9A =9A return 0;
>> =9A =9A =9A }
>>
>> =9A =9A =9A while (1) {
>> - =9A =9A =9A =9A =9A =9A if (server->in_flight >=3D server->maxReq)=
 {
>> + =9A =9A =9A =9A =9A =9A if (server->credits <=3D 0) {
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req=
_lock);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_inc(ser=
ver);
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A wait_event(server->request=
_q,
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Ain_=
flight(server) < server->maxReq);
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A wait_event(server->request=
_q, has_credits(server));
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_num_waiters_dec(ser=
ver);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_lock(&server->req_l=
ock);
>> =9A =9A =9A =9A =9A =9A =9A } else {
>> @@ -280,12 +280,16 @@ wait_for_free_request(struct TCP_Server_Info *=
server, const int long_op)
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return -=
ENOENT;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A }
>>
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* can not count locking c=
ommands against total
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9Aas they are allowed=
 to block on server */
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /*
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* Can not count locking=
 commands against total
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A* as they are allowed t=
o block on server.
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A*/
>>
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* update # of requests =
on the wire to server */
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (long_op !=3D CIFS_BLOC=
KING_OP)
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A if (long_op !=3D CIFS_BLOC=
KING_OP) {
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->cr=
edits--;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A server->=
in_flight++;
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A }
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&server->req=
_lock);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A break;
>> =9A =9A =9A =9A =9A =9A =9A }
>> @@ -360,7 +364,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =9A =9A =9A mid =3D AllocMidQEntry(hdr, server);
>> =9A =9A =9A if (mid =3D=3D NULL) {
>> =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&server->srv_mutex);
>> - =9A =9A =9A =9A =9A =9A dec_in_flight(server);
>> + =9A =9A =9A =9A =9A =9A cifs_add_credits(server, 1);
>> =9A =9A =9A =9A =9A =9A =9A wake_up(&server->request_q);
>> =9A =9A =9A =9A =9A =9A =9A return -ENOMEM;
>> =9A =9A =9A }
>> @@ -393,7 +397,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =9A =9A =9A return rc;
>> =9Aout_err:
>> =9A =9A =9A delete_mid(mid);
>> - =9A =9A dec_in_flight(server);
>> + =9A =9A cifs_add_credits(server, 1);
>> =9A =9A =9A wake_up(&server->request_q);
>> =9A =9A =9A return rc;
>> =9A}
>> @@ -565,7 +569,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&ses->server->srv_mutex);
>> =9A =9A =9A =9A =9A =9A =9A cifs_small_buf_release(in_buf);
>> =9A =9A =9A =9A =9A =9A =9A /* Update # of requests on wire to serve=
r */
>> - =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server);
>> + =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->request_q);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> @@ -602,7 +606,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A midQ->callback =3D Delet=
eMidQEntry;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&GlobalMid_L=
ock);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_small_buf_release(i=
n_buf);
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server)=
;
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->serv=
er, 1);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->re=
quest_q);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A =9A =9A =9A =9A }
>> @@ -613,7 +617,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>>
>> =9A =9A =9A rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =9A =9A =9A if (rc !=3D 0) {
>> - =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server);
>> + =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->request_q);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> @@ -638,7 +642,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =9A =9A =9A =9A =9A =9A =9A midQ->resp_buf =3D NULL;
>> =9Aout:
>> =9A =9A =9A delete_mid(midQ);
>> - =9A =9A dec_in_flight(ses->server);
>> + =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A wake_up(&ses->server->request_q);
>>
>> =9A =9A =9A return rc;
>> @@ -689,7 +693,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =9A =9A =9A if (rc) {
>> =9A =9A =9A =9A =9A =9A =9A mutex_unlock(&ses->server->srv_mutex);
>> =9A =9A =9A =9A =9A =9A =9A /* Update # of requests on wire to serve=
r */
>> - =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server);
>> + =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->request_q);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> @@ -722,7 +726,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A /* no longer considered =
to be "in-flight" */
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A midQ->callback =3D Delet=
eMidQEntry;
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A spin_unlock(&GlobalMid_L=
ock);
>> - =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server)=
;
>> + =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->serv=
er, 1);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->re=
quest_q);
>> =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A =9A =9A =9A =9A }
>> @@ -731,7 +735,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>>
>> =9A =9A =9A rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =9A =9A =9A if (rc !=3D 0) {
>> - =9A =9A =9A =9A =9A =9A dec_in_flight(ses->server);
>> + =9A =9A =9A =9A =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A =9A =9A =9A =9A wake_up(&ses->server->request_q);
>> =9A =9A =9A =9A =9A =9A =9A return rc;
>> =9A =9A =9A }
>> @@ -748,7 +752,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =9A =9A =9A rc =3D cifs_check_receive(midQ, ses->server, 0);
>> =9Aout:
>> =9A =9A =9A delete_mid(midQ);
>> - =9A =9A dec_in_flight(ses->server);
>> + =9A =9A cifs_add_credits(ses->server, 1);
>> =9A =9A =9A wake_up(&ses->server->request_q);
>>
>> =9A =9A =9A return rc;
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Best regards,
Pavel Shilovsky.
