From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Introduce credit-based flow control
Date: Wed, 15 Feb 2012 22:04:11 +0400
Message-ID: <CAKywueTh2Y4uuLr+2W9Rrv+rtNM6xtbq+3M7gL41hpUZd5is1Q@mail.gmail.com>
References: <1328776890-4190-1-git-send-email-piastry@etersoft.ru>
	<20120212075309.7368d89b@tlielax.poochiereds.net>
	<CAKywueRHe7_s2TCaHuthm6m8kQ4zjKkmtf_SLNT0RMvJgPaqJw@mail.gmail.com>
	<20120215101107.32befdc6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120215101107.32befdc6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/15 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Wed, 15 Feb 2012 18:18:11 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2012/2/12 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>> > -----BEGIN PGP SIGNED MESSAGE-----
>> > Hash: SHA1
>> >
>> > On Thu, =A09 Feb 2012 11:41:24 +0300
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> and send no more than credits value requests at once. For SMB/CIF=
S
>> >> it's trivial: increment this value by receiving any message and
>> >> decrement by sending one.
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >
>> > Yes! Nice work. This is clearly the right approach for merging SMB=
2
>> > support into the kernel. Extend the CIFS code to do what we need a=
nd
>> > share as much code as possible between the SMB1 and SMB2 support. =
By
>> > doing this piecemeal too we can avoid a wholesale "code dump" into=
 the
>> > kernel.
>> >
>> > Some comments below.
>> >
>> >> ---
>> >> =A0fs/cifs/cifsglob.h =A0| =A0 =A01 +
>> >> =A0fs/cifs/cifssmb.c =A0 | =A0 =A03 +++
>> >> =A0fs/cifs/connect.c =A0 | =A0 10 ++++------
>> >> =A0fs/cifs/transport.c | =A0 20 ++++++++++++++++----
>> >> =A04 files changed, 24 insertions(+), 10 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >> index 76e7d8b..f96752a 100644
>> >> --- a/fs/cifs/cifsglob.h
>> >> +++ b/fs/cifs/cifsglob.h
>> >> @@ -256,6 +256,7 @@ struct TCP_Server_Info {
>> >> =A0 =A0 =A0 bool noautotune; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* do=
 not autotune send buf sizes */
>> >> =A0 =A0 =A0 bool tcp_nodelay;
>> >> =A0 =A0 =A0 atomic_t inFlight; =A0/* number of requests on the wi=
re to server */
>> >> + =A0 =A0 atomic_t credits; =A0/* send no more requests at once *=
/
>> >
>> > Currently, it's not clear whether the inFlight counter is protecte=
d by
>> > the GlobalMid_lock or not. Ditto for this new counter. If it is
>> > protected by it, then there's no need for it to be an atomic value=
=2E The
>> > locking around this needs to be explicitly clear to avoid later bu=
gs
>> > when we tinker with this code.
>>
>> We decrement inFlight value without holding GlobalMid_lock - so it
>> should be atomic.
>>
>
> But why is it this way? If it's atomic why bother with the locking at
> all? If you really need the lock then why bother making it atomic?
>
> Any time I see inconsistent locking like this, it's usually an indica=
tor
> that something is wrong. If it's not wrong then it needs to be
> documented at the very least.
>
> My suspicion is that the existing code was slapped together without
> much thought as to what locks were necessary. Since you're in here no=
w
> though, this ought to be corrected before you move forward with addin=
g
> new code.

Ok, it seems like a bug. Locking it with GlobalMid_lock looks better
to me (the explanation is below).

>
>> >
>> > Also, should we just replace the inFlight counter with the credits
>> > counter? Is there some way to calculate the # of requests in fligh=
t given
>> > the value of "credits" in the SMB2 case?
>>
>> I don't think so.
>>
>> >
>> >> =A0 =A0 =A0 struct mutex srv_mutex;
>> >> =A0 =A0 =A0 struct task_struct *tsk;
>> >> =A0 =A0 =A0 char server_GUID[16];
>> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> >> index 8b7794c..fbc4437 100644
>> >> --- a/fs/cifs/cifssmb.c
>> >> +++ b/fs/cifs/cifssmb.c
>> >> @@ -717,6 +717,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
>> >>
>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> >> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> >> + =A0 =A0 atomic_inc(&server->credits);
>> >> =A0 =A0 =A0 wake_up(&server->request_q);
>> >> =A0}
>> >>
>> >> @@ -1670,6 +1671,7 @@ cifs_readv_callback(struct mid_q_entry *mid=
)
>> >> =A0 =A0 =A0 queue_work(system_nrt_wq, &rdata->work);
>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> >> =A0 =A0 =A0 atomic_dec(&server->inFlight);
>> >> + =A0 =A0 atomic_inc(&server->credits);
>> >> =A0 =A0 =A0 wake_up(&server->request_q);
>> >> =A0}
>> >>
>> >> @@ -2111,6 +2113,7 @@ cifs_writev_callback(struct mid_q_entry *mi=
d)
>> >> =A0 =A0 =A0 queue_work(system_nrt_wq, &wdata->work);
>> >> =A0 =A0 =A0 DeleteMidQEntry(mid);
>> >> =A0 =A0 =A0 atomic_dec(&tcon->ses->server->inFlight);
>> >> + =A0 =A0 atomic_inc(&tcon->ses->server->credits);
>> >> =A0 =A0 =A0 wake_up(&tcon->ses->server->request_q);
>> >> =A0}
>> >>
>> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> >> index 602f77c..6b95304 100644
>> >> --- a/fs/cifs/connect.c
>> >> +++ b/fs/cifs/connect.c
>> >> @@ -648,12 +648,8 @@ static void clean_demultiplex_info(struct TC=
P_Server_Info *server)
>> >> =A0 =A0 =A0 =A0* time to as little as two.
>> >> =A0 =A0 =A0 =A0*/
>> >> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> >> - =A0 =A0 if (atomic_read(&server->inFlight) >=3D cifs_max_pendin=
g)
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->inFlight, cifs_max_=
pending - 1);
>> >> - =A0 =A0 /*
>> >> - =A0 =A0 =A0* We do not want to set the max_pending too low or w=
e could end up
>> >> - =A0 =A0 =A0* with the counter going negative.
>> >> - =A0 =A0 =A0*/
>> >> + =A0 =A0 if (atomic_read(&server->credits) =3D=3D 0)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&server->credits, 1);
>> >> =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
>> >> =A0 =A0 =A0 /*
>> >> =A0 =A0 =A0 =A0* Although there should not be any requests blocke=
d on this queue it
>> >> @@ -3759,9 +3755,11 @@ int cifs_negotiate_protocol(unsigned int x=
id, struct cifs_ses *ses)
>> >> =A0 =A0 =A0 if (server->maxBuf !=3D 0)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >>
>> >> + =A0 =A0 atomic_set(&ses->server->credits, cifs_max_pending);
>> >> =A0 =A0 =A0 rc =3D CIFSSMBNegotiate(xid, ses);
>> >> =A0 =A0 =A0 if (rc =3D=3D -EAGAIN) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* retry only once on 1st time connec=
tion */
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_set(&ses->server->credits, cifs_=
max_pending);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBNegotiate(xid, ses);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN)
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EHOSTDOWN;
>> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> >> index 0cc9584..f1f927f 100644
>> >> --- a/fs/cifs/transport.c
>> >> +++ b/fs/cifs/transport.c
>> >> @@ -260,17 +260,17 @@ static int wait_for_free_request(struct TCP=
_Server_Info *server,
>> >> =A0 =A0 =A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* oplock breaks must not be held up =
*/
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_inc(&server->inFlight);
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&server->credits);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> =A0 =A0 =A0 }
>> >>
>> >
>> > I haven't gotten to your later patches so I may be reviewing
>> > prematurely, but I think we need to rethink the code above. Allowi=
ng
>> > the client to exceed the maxmpx is clearly problematic. Rather tha=
n
>> > doing that we ought to attempt to keep 2 credits in reserve at any
>> > given time -- one for oplock breaks and one for echo requests.
>> >
>> > If MaxMpx 2, then we should disable oplocks. If it's 1, then we
>> > should disable echoes and oplocks. The latter case may take some o=
verhaul
>> > of how the echo timeout handling works.
>>
>> I agree that allowing to exceed the maxmps is wrong, but I think we
>> can leave it as it is for this patch.
>>
>
> I suppose, but I worry that adding the new complexity of credits
> without fixing that bug is going to make this really difficult to
> debug...
>
>> >
>> >> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
>> >> =A0 =A0 =A0 while (1) {
>> >> - =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->inFlight) >=3D=
 cifs_max_pending) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_read(&server->credits) =3D=3D=
 0) {
>>
>> Now I think that (according to echo and oplock problem) we need this=
 to be:
>>
>> if (atomic_read(&server->credits) <=3D 0) {
>>
>> Right?
>>
>
> Ugh, I guess. Is this fixed later in this patchset? If not, then I
> suggest fixing that problem first before you introduce the new
> credit-based algorithm. Fixing this problem is really my immediate go=
al
> with this patchset. If we can do it in a way that also paves the way
> for the for SMB2 code then that's ideal.
>

I understand. In SMB2 we have the dynamic MaxMpx value - so, we should
disable/enable echo/oplock on the fly.

I suggest to do this for SMB2 on every arrival request:

1) lock GlobalMid_lock
2) update credits and reqOnFlight values
3) check if outstanding requests exist - goto 5 (can't make a desicion
about server configuration).
4) change server configuration:
  4.1) if credits >=3D 3: enable oplocks & echos
  4.2) if credits =3D=3D 2: disable oplocks & enable echos
  4.3) if credits =3D=3D 1: disable oplocks & disable echos
(credits should not be 0 here; if so - reconnect)
5) unlock GlobalMid_lock

But for CIFS we should do something like step 4 only once after
getting MaxMpx value.

Thoughts?

--=20
Best regards,
Pavel Shilovsky.
