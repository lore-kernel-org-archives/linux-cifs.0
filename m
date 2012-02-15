From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Introduce credit-based flow control
Date: Wed, 15 Feb 2012 10:11:07 -0500
Message-ID: <20120215101107.32befdc6@tlielax.poochiereds.net>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
	<20120212075309.7368d89b@tlielax.poochiereds.net>
	<CAKywueRHe7_s2TCaHuthm6m8kQ4zjKkmtf_SLNT0RMvJgPaqJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRHe7_s2TCaHuthm6m8kQ4zjKkmtf_SLNT0RMvJgPaqJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 15 Feb 2012 18:18:11 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> >
> > On Thu, =C2=A09 Feb 2012 11:41:24 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> and send no more than credits value requests at once. For SMB/CIFS
> >> it's trivial: increment this value by receiving any message and
> >> decrement by sending one.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >
> > Yes! Nice work. This is clearly the right approach for merging SMB2
> > support into the kernel. Extend the CIFS code to do what we need an=
d
> > share as much code as possible between the SMB1 and SMB2 support. B=
y
> > doing this piecemeal too we can avoid a wholesale "code dump" into =
the
> > kernel.
> >
> > Some comments below.
> >
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 =C2=A01 +
> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 | =C2=A0 =C2=A03 +++
> >> =C2=A0fs/cifs/connect.c =C2=A0 | =C2=A0 10 ++++------
> >> =C2=A0fs/cifs/transport.c | =C2=A0 20 ++++++++++++++++----
> >> =C2=A04 files changed, 24 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 76e7d8b..f96752a 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -256,6 +256,7 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 bool noautotune; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0/* do not autotune send buf sizes */
> >> =C2=A0 =C2=A0 =C2=A0 bool tcp_nodelay;
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t inFlight; =C2=A0/* number of request=
s on the wire to server */
> >> + =C2=A0 =C2=A0 atomic_t credits; =C2=A0/* send no more requests a=
t once */
> >
> > Currently, it's not clear whether the inFlight counter is protected=
 by
> > the GlobalMid_lock or not. Ditto for this new counter. If it is
> > protected by it, then there's no need for it to be an atomic value.=
 The
> > locking around this needs to be explicitly clear to avoid later bug=
s
> > when we tinker with this code.
>=20
> We decrement inFlight value without holding GlobalMid_lock - so it
> should be atomic.
>=20

But why is it this way? If it's atomic why bother with the locking at
all? If you really need the lock then why bother making it atomic?

Any time I see inconsistent locking like this, it's usually an indicato=
r
that something is wrong. If it's not wrong then it needs to be
documented at the very least.

My suspicion is that the existing code was slapped together without
much thought as to what locks were necessary. Since you're in here now
though, this ought to be corrected before you move forward with adding
new code.

> >
> > Also, should we just replace the inFlight counter with the credits
> > counter? Is there some way to calculate the # of requests in flight=
 given
> > the value of "credits" in the SMB2 case?
>=20
> I don't think so.
>=20
> >
> >> =C2=A0 =C2=A0 =C2=A0 struct mutex srv_mutex;
> >> =C2=A0 =C2=A0 =C2=A0 struct task_struct *tsk;
> >> =C2=A0 =C2=A0 =C2=A0 char server_GUID[16];
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index 8b7794c..fbc4437 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -717,6 +717,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
> >>
> >> =C2=A0 =C2=A0 =C2=A0 DeleteMidQEntry(mid);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&server->request_q);
> >> =C2=A0}
> >>
> >> @@ -1670,6 +1671,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
> >> =C2=A0 =C2=A0 =C2=A0 queue_work(system_nrt_wq, &rdata->work);
> >> =C2=A0 =C2=A0 =C2=A0 DeleteMidQEntry(mid);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&server->request_q);
> >> =C2=A0}
> >>
> >> @@ -2111,6 +2113,7 @@ cifs_writev_callback(struct mid_q_entry *mid=
)
> >> =C2=A0 =C2=A0 =C2=A0 queue_work(system_nrt_wq, &wdata->work);
> >> =C2=A0 =C2=A0 =C2=A0 DeleteMidQEntry(mid);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&tcon->ses->server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&tcon->ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&tcon->ses->server->request_q);
> >> =C2=A0}
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 602f77c..6b95304 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -648,12 +648,8 @@ static void clean_demultiplex_info(struct TCP=
_Server_Info *server)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* time to as little as two.
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> - =C2=A0 =C2=A0 if (atomic_read(&server->inFlight) >=3D cifs_max_p=
ending)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(&server->in=
=46light, cifs_max_pending - 1);
> >> - =C2=A0 =C2=A0 /*
> >> - =C2=A0 =C2=A0 =C2=A0* We do not want to set the max_pending too =
low or we could end up
> >> - =C2=A0 =C2=A0 =C2=A0* with the counter going negative.
> >> - =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 if (atomic_read(&server->credits) =3D=3D 0)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(&server->cr=
edits, 1);
> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 /*
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0* Although there should not be any requ=
ests blocked on this queue it
> >> @@ -3759,9 +3755,11 @@ int cifs_negotiate_protocol(unsigned int xi=
d, struct cifs_ses *ses)
> >> =C2=A0 =C2=A0 =C2=A0 if (server->maxBuf !=3D 0)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >>
> >> + =C2=A0 =C2=A0 atomic_set(&ses->server->credits, cifs_max_pending=
);
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBNegotiate(xid, ses);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D -EAGAIN) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* retry only onc=
e on 1st time connection */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_set(&ses->serve=
r->credits, cifs_max_pending);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBNeg=
otiate(xid, ses);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc =3D=3D -EA=
GAIN)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 rc =3D -EHOSTDOWN;
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index 0cc9584..f1f927f 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -260,17 +260,17 @@ static int wait_for_free_request(struct TCP_=
Server_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* oplock breaks =
must not be held up */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&serve=
r->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->cr=
edits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >
> > I haven't gotten to your later patches so I may be reviewing
> > prematurely, but I think we need to rethink the code above. Allowin=
g
> > the client to exceed the maxmpx is clearly problematic. Rather than
> > doing that we ought to attempt to keep 2 credits in reserve at any
> > given time -- one for oplock breaks and one for echo requests.
> >
> > If MaxMpx 2, then we should disable oplocks. If it's 1, then we
> > should disable echoes and oplocks. The latter case may take some ov=
erhaul
> > of how the echo timeout handling works.
>=20
> I agree that allowing to exceed the maxmps is wrong, but I think we
> can leave it as it is for this patch.
>=20

I suppose, but I worry that adding the new complexity of credits
without fixing that bug is going to make this really difficult to
debug...

> >
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 while (1) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (atomic_read(&serve=
r->inFlight) >=3D cifs_max_pending) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (atomic_read(&serve=
r->credits) =3D=3D 0) {
>=20
> Now I think that (according to echo and oplock problem) we need this =
to be:
>=20
> if (atomic_read(&server->credits) <=3D 0) {
>=20
> Right?
>=20

Ugh, I guess. Is this fixed later in this patchset? If not, then I
suggest fixing that problem first before you introduce the new
credit-based algorithm. Fixing this problem is really my immediate goal
with this patchset. If we can do it in a way that also paves the way
for the for SMB2 code then that's ideal.

> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_num_waiters_inc(server);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wait_event(server->request_q,
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_read(&server->inFli=
ght)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0< cifs_max_pending)=
;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_read(&server->credi=
ts) > 0);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_num_waiters_dec(server);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> @@ -283,8 +283,10 @@ static int wait_for_free_request(struct TCP_S=
erver_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0as they are allowed to block on server */
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* update # of requests on the wire to server */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (long_op !=3D CIFS_BLOCKING_OP)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (long_op !=3D CIFS_BLOCKING_OP) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->credits);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -360,6 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server=
, struct kvec *iov,
> >> =C2=A0 =C2=A0 =C2=A0 if (mid =3D=3D NULL) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ser=
ver->srv_mutex);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&serve=
r->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&server->cr=
edits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&server->=
request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -393,6 +396,7 @@ cifs_call_async(struct TCP_Server_Info *server=
, struct kvec *iov,
> >> =C2=A0out_err:
> >> =C2=A0 =C2=A0 =C2=A0 delete_mid(mid);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0}
> >> @@ -565,6 +569,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_re=
lease(in_buf);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Update # of re=
quests on wire to server */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->=
server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -602,6 +607,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_small_buf_release(in_buf);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_inc(&ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wake_up(&ses->server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -613,6 +619,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_sync_mid_result(midQ, ses->server=
);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->=
server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -638,6 +645,7 @@ SendReceive2(const unsigned int xid, struct ci=
fs_ses *ses,
> >> =C2=A0out:
> >> =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> @@ -689,6 +697,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses=
->server->srv_mutex);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Update # of re=
quests on wire to server */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->=
server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -722,6 +731,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 midQ->callback =3D DeleteMidQEntry;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_inc(&ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wake_up(&ses->server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -731,6 +741,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_sync_mid_result(midQ, ses->server=
);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->=
server->inFlight);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -748,6 +759,7 @@ SendReceive(const unsigned int xid, struct cif=
s_ses *ses,
> >> =C2=A0out:
> >> =C2=A0 =C2=A0 =C2=A0 delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 atomic_dec(&ses->server->inFlight);
> >> + =C2=A0 =C2=A0 atomic_inc(&ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >>
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >
> >
> > - --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > -----BEGIN PGP SIGNATURE-----
> > Version: GnuPG v2.0.18 (GNU/Linux)
> >
> > iQIcBAEBAgAGBQJPN7Y1AAoJEAAOaEEZVoIVil4P/1IfpsJswGldw1/ufTuoMw4Y
> > pT80BdlFuNQ612hVXq3xrzrP8WYHlwnhfADS5n+JCdeBJwfJzV//bah5I5/4cLfY
> > htvajLzlhL0aCIK57Sxa1GoHiXkadaO9TI+vA6x5hM2SALhJT2UA/4QVNGsC5jhG
> > nDs07RjcGRzFT2nZ8/LLDliYmQXZk5FvnieShEdiDofcod2ILwaBUTIbJ5hz+CGL
> > GXTFmo2GKKyZGIuGCeg+8AkV3oeFXdfakjzjkTBFZSqLnGZoJyHe4vzKhob1mGtO
> > Xw7szAlFDxCLylccfid+ila60u2EHQiGZkPjRJCTcZmb+BpUuKo+5ShXBLOItIxQ
> > gWLsydodP9G5uIHsrWakY/tfaQSUZzbfmIQMJKrJ31MKo/EtVdPgSdRGJKlPukjS
> > 0oc+hW1o6Gkdqz98lL4sBiT6Mn6/ekB3CXdhOR1TTC+5tyOdLwxoI6DejDp0HlDs
> > wypfNgbrhLarV/BF/LpY/5MXI8kGyOLZT584bO2Bl2QTRwfGUwgmMAwluf0MEMs2
> > JJO5KLN+uozfLi/6b7YcT4/Uqy5D1BwWowT/0Lf2IpZYuLkyaKiWZ/Q/K6mMDKNo
> > p7P+qsyF2RjwYpltSWG6zPPldLPczkWvy9BiQKXMFWI2EVNHbbPMUKRaWvIw66hX
> > 28PtjNXqCfDFfIhrHE86
> > =3DaqY+
> > -----END PGP SIGNATURE-----
>=20
> Thanks for reviewing this one!
>=20


--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
