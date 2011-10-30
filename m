From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2 05/53] CIFS: wait_for_free_request needs to wait on
 credits returned by server (for SMB2)
Date: Sat, 29 Oct 2011 22:41:47 -0400
Message-ID: <20111029224147.4cc321f7@corrin.poochiereds.net>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
	<1319831704-3572-6-git-send-email-piastry@etersoft.ru>
	<20111029113508.370e7df9@corrin.poochiereds.net>
	<CAKywueSGDSw33L4_a7W6D7gM_PH9uy3xTQ6=8zgAimGhz5=UfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSGDSw33L4_a7W6D7gM_PH9uy3xTQ6=8zgAimGhz5=UfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 30 Oct 2011 00:00:15 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/10/29 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > On Fri, 28 Oct 2011 23:54:16 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >>
> >> wait_for_free_request is called to ensure that we don't have more =
than the
> >> configured maximum of requests in flight on the wire (for cifs), b=
ut for SMB2,
> >> the number of requests that can be in flight varies dynamically (t=
he client
> >> may request that the server grant more "credits" in a request, and=
 each
> >> request uses at least one credit). =C2=A0 Instead of migrating ove=
r the original
> >> smb2_wait_for_free_request function, simply add a check in cifs's =
original
> >> wait_for_free_request for the is_smb2 case to make sure that we do=
n't go
> >> beyond the number of allocated "credits" (ie those that remain fro=
m those
> >> the server has allocated for this tcp session). =C2=A0Otherwise th=
e logic is unchanged
> >> (other than to make it extern so that the next function to be adde=
d, smb2_sendrcv2
> >> in =C2=A0smbtransport.c can call it - smb2_sendrcv2 will be migrat=
ed over in the next patch).
> >>
> >> Note that smb2 servers will typically allow many more requests in =
flight at one time
> >> than cifs servers (which usually default to only 50) and can adjus=
t this as needed.
> >> This should provide significant performance benefit in some worklo=
ads (ie smb2
> >> in many cases will get more parallelism than cifs and some other p=
rotocols
> >> since some artificially constrain the maximum number of requests).
> >>
> >> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0| =C2=A0 =C2=A01 +
> >> =C2=A0fs/cifs/cifsproto.h | =C2=A0 =C2=A03 ++-
> >> =C2=A0fs/cifs/transport.c | =C2=A0 22 +++++++++++++++++++---
> >> =C2=A03 files changed, 22 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 179b784..b440329 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -311,6 +311,7 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 wait_queue_head_t read_q; /* used by readpage=
s */
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t active_readpage_req; /* used by read=
pages */
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t resp_rdy; /* used by readpages and d=
emultiplex */
> >> + =C2=A0 =C2=A0 atomic_t credits; =C2=A0/* send no more simultaneo=
us requests than this */
> >> =C2=A0 =C2=A0 =C2=A0 __le16 smb2_dialect_revision; /* SMB2.0 imple=
mented, 2.1 recognized */
> >> =C2=A0 =C2=A0 =C2=A0 struct task_struct *observe;
> >> =C2=A0 =C2=A0 =C2=A0 char smb2_crypt_key[CIFS_CRYPTO_KEY_SIZE]; /*=
 BB can we use cifs key */
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index ef4f631..84d1e4c 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -1,7 +1,7 @@
> >> =C2=A0/*
> >> =C2=A0 * =C2=A0 fs/cifs/cifsproto.h
> >> =C2=A0 *
> >> - * =C2=A0 Copyright (c) International Business Machines =C2=A0Cor=
p., 2002,2008
> >> + * =C2=A0 Copyright (c) International Business Machines =C2=A0Cor=
p., 2002,2011
> >> =C2=A0 * =C2=A0 Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
> >> =C2=A0 *
> >> =C2=A0 * =C2=A0 This library is free software; you can redistribut=
e it and/or modify
> >> @@ -68,6 +68,7 @@ extern char *cifs_compose_mount_options(const ch=
ar *sb_mountdata,
> >> =C2=A0extern struct mid_q_entry *AllocMidQEntry(const struct smb_h=
dr *smb_buffer,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct TCP_Server_Info *server);
> >> =C2=A0extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
> >> +extern int wait_for_free_request(struct TCP_Server_Info *sv, cons=
t int long_op);
> >> =C2=A0extern int cifs_call_async(struct TCP_Server_Info *server, s=
truct kvec *iov,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0unsigned int nvec, mid_receive_t *receive,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0mid_callback_t *callback, void *cbdata,
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index 0cc9584..25d04df 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -254,7 +254,7 @@ smb_send(struct TCP_Server_Info *server, struc=
t smb_hdr *smb_buffer,
> >> =C2=A0 =C2=A0 =C2=A0 return smb_sendv(server, &iov, 1);
> >> =C2=A0}
> >>
> >> -static int wait_for_free_request(struct TCP_Server_Info *server,
> >> +int wait_for_free_request(struct TCP_Server_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const int long_op)
> >> =C2=A0{
> >> =C2=A0 =C2=A0 =C2=A0 if (long_op =3D=3D CIFS_ASYNC_OP) {
> >> @@ -265,7 +265,8 @@ static int wait_for_free_request(struct TCP_Se=
rver_Info *server,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 while (1) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (atomic_read(&serve=
r->inFlight) >=3D cifs_max_pending) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((server->is_smb2 =3D=
=3D false) &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_r=
ead(&server->inFlight) >=3D cifs_max_pending) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_num_waiters_inc(server);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wait_event(server->request_q,
> >> @@ -273,6 +274,16 @@ static int wait_for_free_request(struct TCP_S=
erver_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0< cifs_max_p=
ending);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_num_waiters_dec(server);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_lock(&GlobalMid_Lock);
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (server->is_=
smb2 &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (atomic_read(&server->credits) < 1)) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_unlock(&GlobalMid_Lock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifs_num_waiters_inc(server);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 wait_event(server->request_q,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_read(&server->credi=
ts) > 0);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifs_num_waiters_dec(server);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_lock(&GlobalMid_Lock);
> >> +#endif /* CONFIG_CIFS_SMB2 */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (server->tcpStatus =3D=3D CifsExiting) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> @@ -283,8 +294,13 @@ static int wait_for_free_request(struct TCP_S=
erver_Info *server,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0as they are allowed to block on server */
> >>
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 /* update # of requests on the wire to server */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (long_op !=3D CIFS_BLOCKING_OP)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (server->is_smb2 =3D=3D false &&
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 long_op !=3D CIFS_BLOCKING_OP)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&server->inFlight);
> >> +#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else if (server->is_smb2)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_dec(&server->credits);
> >> +#endif
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >
> > This patch doesn't make much sense...
> >
> > "credits" gets initialized to 0, then on the first request, you'll
> > decrement it which will make it go negative. I then don't see any p=
lace
> > where credits is ever incremented.
> >
> > Maybe that happens in a different patch, but splitting your patches=
 out
> > this way makes no sense. No one can reasonably review this patch fo=
r
> > sanity since the lifecycle of "credits" is incomplete.
>=20
> In this case we should move this patch after we add smb2_sendrcv
> function (where credits are increased). Make sense?
>=20

I haven't gotten that far in the series yet, so I'm not sure if that
makes sense or not. That's the problem: we as reviewers can't review
this set as a whole. Most of us don't have brains that big. We have to
review these patches a set of individual changes that are working
toward a goal.

I think what you need to do is to figure out a way to break the
patchset up more logically. One would think that doing that would be a
set of steps that you could follow, but it's really more of an art. You
have to look at this from the viewpoint of potential reviewers.

A large patchset like this needs to have a clear "flow" that evolves
the code incrementally. Cleanups or other changes that make sense on
their own should usually be broken out and done first, and often in a
separate set. Further patches should make a set of logically complete
changes to the code.

A case in point: when I did the patchset to clean up the demultiplex
codepath, I added code to kmalloc a buffer on each pass through
readv_from_socket. In the next patch, I ripped that kmalloc back out
and added code to keep a reusable buffer for that purpose.

I could have done that in a different way that didn't "churn" the code
so much, but it made more sense to do it that way for a reviewer walkin=
g
the patches in order. Adding the new buffer management was logically
separate from the earlier change, so I broke the patches up along the
same lines.

Doing this also pays off later. It also allows for someone bisecting
the code to have a tree that reasonably works if they stop at that
point, and makes it easier to find bugs since the change is more
logical.

Sometimes it is necessary to have a patch that doesn't make a lot of
sense on its own in order to prepare for later patches. If you do that
though, you really need to have a commit message that explains what
you're doing and why.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
