From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Introduce credit-based flow control
Date: Wed, 15 Feb 2012 18:18:11 +0400
Message-ID: <CAKywueRHe7_s2TCaHuthm6m8kQ4zjKkmtf_SLNT0RMvJgPaqJw@mail.gmail.com>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
	<20120212075309.7368d89b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120212075309.7368d89b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On Thu, =A09 Feb 2012 11:41:24 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> and send no more than credits value requests at once. For SMB/CIFS
>> it's trivial: increment this value by receiving any message and
>> decrement by sending one.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
> Yes! Nice work. This is clearly the right approach for merging SMB2
> support into the kernel. Extend the CIFS code to do what we need and
> share as much code as possible between the SMB1 and SMB2 support. By
> doing this piecemeal too we can avoid a wholesale "code dump" into th=
e
> kernel.
>
> Some comments below.
>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A01 +
>> =A0fs/cifs/cifssmb.c =A0 | =A0 =A03 +++
>> =A0fs/cifs/connect.c =A0 | =A0 10 ++++------
>> =A0fs/cifs/transport.c | =A0 20 ++++++++++++++++----
>> =A04 files changed, 24 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 76e7d8b..f96752a 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -256,6 +256,7 @@ struct TCP_Server_Info {
>> =A0 =A0 =A0 bool noautotune; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do no=
t autotune send buf sizes */
>> =A0 =A0 =A0 bool tcp_nodelay;
>> =A0 =A0 =A0 atomic_t inFlight; =A0/* number of requests on the wire =
to server */
>> + =A0 =A0 atomic_t credits; =A0/* send no more requests at once */
>
> Currently, it's not clear whether the inFlight counter is protected b=
y
> the GlobalMid_lock or not. Ditto for this new counter. If it is
> protected by it, then there's no need for it to be an atomic value. T=
he
> locking around this needs to be explicitly clear to avoid later bugs
> when we tinker with this code.

We decrement inFlight value without holding GlobalMid_lock - so it
should be atomic.

>
> Also, should we just replace the inFlight counter with the credits
> counter? Is there some way to calculate the # of requests in flight g=
iven
> the value of "credits" in the SMB2 case?

I don't think so.

>
>> =A0 =A0 =A0 struct mutex srv_mutex;
>> =A0 =A0 =A0 struct task_struct *tsk;
>> =A0 =A0 =A0 char server_GUID[16];
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 8b7794c..fbc4437 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -717,6 +717,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>>
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> + =A0 =A0 atomic_inc(&server->credits);
>> =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0}
>>
>> @@ -1670,6 +1671,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>> =A0 =A0 =A0 queue_work(system_nrt_wq, &rdata->work);
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> + =A0 =A0 atomic_inc(&server->credits);
>> =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0}
>>
>> @@ -2111,6 +2113,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
>> =A0 =A0 =A0 queue_work(system_nrt_wq, &wdata->work);
>> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> =A0 =A0 =A0 atomic_dec(&tcon->ses->server->inFlight);
>> + =A0 =A0 atomic_inc(&tcon->ses->server->credits);
>> =A0 =A0 =A0 wake_up(&tcon->ses->server->request_q);
>> =A0}
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 602f77c..6b95304 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -648,12 +648,8 @@ static void clean_demultiplex_info(struct TCP_S=
erver_Info *server)
>> =A0 =A0 =A0 =A0* time to as little as two.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> - =A0 =A0 if (atomic_read(&server->inFlight) >=3D cifs_max_pending)
>> - =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->inFlight, cifs_max_pen=
ding - 1);
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* We do not want to set the max_pending too low or we c=
ould end up
>> - =A0 =A0 =A0* with the counter going negative.
>> - =A0 =A0 =A0*/
>> + =A0 =A0 if (atomic_read(&server->credits) =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->credits, 1);
>> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* Although there should not be any requests blocked o=
n this queue it
>> @@ -3759,9 +3755,11 @@ int cifs_negotiate_protocol(unsigned int xid,=
 struct cifs_ses *ses)
>> =A0 =A0 =A0 if (server->maxBuf !=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> + =A0 =A0 atomic_set(&ses->server->credits, cifs_max_pending);
>> =A0 =A0 =A0 rc =3D CIFSSMBNegotiate(xid, ses);
>> =A0 =A0 =A0 if (rc =3D=3D -EAGAIN) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry only once on 1st time connectio=
n */
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ses->server->credits, cifs_max=
_pending);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBNegotiate(xid, ses);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EHOSTDOWN;
>> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> index 0cc9584..f1f927f 100644
>> --- a/fs/cifs/transport.c
>> +++ b/fs/cifs/transport.c
>> @@ -260,17 +260,17 @@ static int wait_for_free_request(struct TCP_Se=
rver_Info *server,
>> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0 =A0 =A0 }
>>
>
> I haven't gotten to your later patches so I may be reviewing
> prematurely, but I think we need to rethink the code above. Allowing
> the client to exceed the maxmpx is clearly problematic. Rather than
> doing that we ought to attempt to keep 2 credits in reserve at any
> given time -- one for oplock breaks and one for echo requests.
>
> If MaxMpx 2, then we should disable oplocks. If it's 1, then we
> should disable echoes and oplocks. The latter case may take some over=
haul
> of how the echo timeout handling works.

I agree that allowing to exceed the maxmps is wrong, but I think we
can leave it as it is for this patch.

>
>> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> =A0 =A0 =A0 while (1) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D ci=
fs_max_pending) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->credits) =3D=3D 0=
) {

Now I think that (according to echo and oplock problem) we need this to=
 be:

if (atomic_read(&server->credits) <=3D 0) {

Right?

>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_inc(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_event(server->reque=
st_q,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ato=
mic_read(&server->inFlight)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
< cifs_max_pending);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ato=
mic_read(&server->credits) > 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_num_waiters_dec(ser=
ver);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Loc=
k);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> @@ -283,8 +283,10 @@ static int wait_for_free_request(struct TCP_Ser=
ver_Info *server,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0as they are allow=
ed to block on server */
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* update # of requests =
on the wire to server */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_BLOC=
KING_OP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (long_op !=3D CIFS_BLOC=
KING_OP) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_i=
nc(&server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec=
(&server->credits);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -360,6 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =A0 =A0 =A0 if (mid =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> =A0 =A0 =A0 }
>> @@ -393,6 +396,7 @@ cifs_call_async(struct TCP_Server_Info *server, =
struct kvec *iov,
>> =A0out_err:
>> =A0 =A0 =A0 delete_mid(mid);
>> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> + =A0 =A0 atomic_inc(&server->credits);
>> =A0 =A0 =A0 wake_up(&server->request_q);
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -565,6 +569,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(in_buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serve=
r */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -602,6 +607,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(i=
n_buf);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server-=
>inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->c=
redits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->re=
quest_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -613,6 +619,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -638,6 +645,7 @@ SendReceive2(const unsigned int xid, struct cifs=
_ses *ses,
>> =A0out:
>> =A0 =A0 =A0 delete_mid(midQ);
>> =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 wake_up(&ses->server->request_q);
>>
>> =A0 =A0 =A0 return rc;
>> @@ -689,6 +697,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mutex_unlock(&ses->server->srv_mutex);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Update # of requests on wire to serve=
r */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -722,6 +731,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 midQ->callback =3D Delet=
eMidQEntry;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_L=
ock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server-=
>inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->c=
redits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->re=
quest_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -731,6 +741,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0 =A0 =A0 rc =3D cifs_sync_mid_result(midQ, ses->server);
>> =A0 =A0 =A0 if (rc !=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&ses->server->request_q);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>> @@ -748,6 +759,7 @@ SendReceive(const unsigned int xid, struct cifs_=
ses *ses,
>> =A0out:
>> =A0 =A0 =A0 delete_mid(midQ);
>> =A0 =A0 =A0 atomic_dec(&ses->server->inFlight);
>> + =A0 =A0 atomic_inc(&ses->server->credits);
>> =A0 =A0 =A0 wake_up(&ses->server->request_q);
>>
>> =A0 =A0 =A0 return rc;
>
>
> - --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.18 (GNU/Linux)
>
> iQIcBAEBAgAGBQJPN7Y1AAoJEAAOaEEZVoIVil4P/1IfpsJswGldw1/ufTuoMw4Y
> pT80BdlFuNQ612hVXq3xrzrP8WYHlwnhfADS5n+JCdeBJwfJzV//bah5I5/4cLfY
> htvajLzlhL0aCIK57Sxa1GoHiXkadaO9TI+vA6x5hM2SALhJT2UA/4QVNGsC5jhG
> nDs07RjcGRzFT2nZ8/LLDliYmQXZk5FvnieShEdiDofcod2ILwaBUTIbJ5hz+CGL
> GXTFmo2GKKyZGIuGCeg+8AkV3oeFXdfakjzjkTBFZSqLnGZoJyHe4vzKhob1mGtO
> Xw7szAlFDxCLylccfid+ila60u2EHQiGZkPjRJCTcZmb+BpUuKo+5ShXBLOItIxQ
> gWLsydodP9G5uIHsrWakY/tfaQSUZzbfmIQMJKrJ31MKo/EtVdPgSdRGJKlPukjS
> 0oc+hW1o6Gkdqz98lL4sBiT6Mn6/ekB3CXdhOR1TTC+5tyOdLwxoI6DejDp0HlDs
> wypfNgbrhLarV/BF/LpY/5MXI8kGyOLZT584bO2Bl2QTRwfGUwgmMAwluf0MEMs2
> JJO5KLN+uozfLi/6b7YcT4/Uqy5D1BwWowT/0Lf2IpZYuLkyaKiWZ/Q/K6mMDKNo
> p7P+qsyF2RjwYpltSWG6zPPldLPczkWvy9BiQKXMFWI2EVNHbbPMUKRaWvIw66hX
> 28PtjNXqCfDFfIhrHE86
> =3DaqY+
> -----END PGP SIGNATURE-----

Thanks for reviewing this one!

--=20
Best regards,
Pavel Shilovsky.
