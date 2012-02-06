From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/50] CIFS: Add SMB2 credits support
Date: Mon, 6 Feb 2012 10:34:09 -0500
Message-ID: <20120206103409.4770249e@tlielax.poochiereds.net>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-6-git-send-email-piastry@etersoft.ru>
	<20120203134212.53f1e950@tlielax.poochiereds.net>
	<CAKywueRE8-Rbcc0QaJeWVJVZKtvxApGfN=QttKECA-fd+yKMyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRE8-Rbcc0QaJeWVJVZKtvxApGfN=QttKECA-fd+yKMyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 6 Feb 2012 13:59:32 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/3 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 20 Jan 2012 12:34:27 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> >>
> >> Convert wait_for_free_request to wait on available credits
> >> for SMB2 servers and decrement a credit number for every call.
> >> Increment the credit number in smb2_sendrcv2 with every response
> >> got from the server.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A01 +
> >> =C2=A0fs/cifs/cifsproto.h =C2=A0 =C2=A0 | =C2=A0 =C2=A02 +-
> >> =C2=A0fs/cifs/smb2transport.c | =C2=A0 =C2=A06 ++++++
> >> =C2=A0fs/cifs/transport.c =C2=A0 =C2=A0 | =C2=A0 20 ++++++++++++++=
++++--
> >> =C2=A04 files changed, 26 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index bb2af48..e5f0b86 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -318,6 +318,7 @@ struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 atomic_t num_waiters; =C2=A0 /* blocked waiti=
ng to get in sendrecv */
> >> =C2=A0#endif
> >> =C2=A0#ifdef CONFIG_CIFS_SMB2
> >> + =C2=A0 =C2=A0 atomic_t credits; /* send no more simultaneous req=
uests than this */
> >> =C2=A0 =C2=A0 =C2=A0 __u64 current_smb2_mid; =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* multiplex id - rotating counter */
> >> =C2=A0#endif
> >> =C2=A0};
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index d1e30d9..b6c784b 100644
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
> >> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> >> index d7f1c05..b5702f3 100644
> >> --- a/fs/cifs/smb2transport.c
> >> +++ b/fs/cifs/smb2transport.c
> >> @@ -148,6 +148,7 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 unsigned int receive_len;
> >> =C2=A0 =C2=A0 =C2=A0 struct mid_q_entry *midQ;
> >> =C2=A0 =C2=A0 =C2=A0 struct smb2_hdr *buf =3D iov[0].iov_base;
> >> + =C2=A0 =C2=A0 unsigned int credits =3D 1;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 if (status)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *status =3D STATU=
S_SUCCESS;
> >> @@ -186,6 +187,7 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_unlock(&ses=
->server->srv_mutex);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_small_buf_re=
lease(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -222,6 +224,7 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 midQ->callback =3D cifs_delete_mid;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 spin_unlock(&GlobalMid_Lock);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cifs_small_buf_release(buf);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 atomic_inc(&ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wake_up(&ses->server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -232,6 +235,7 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_sync_mid_result(midQ, ses->server=
);
> >> =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atomic_inc(&ses->serve=
r->credits);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->ser=
ver->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> @@ -271,7 +275,9 @@ smb2_sendrcv2(const unsigned int xid, struct c=
ifs_ses *ses,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* mark it so buf=
 will not be freed by free_smb2mid */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 midQ->resp_buf =3D=
 NULL;
> >>
> >> + =C2=A0 =C2=A0 credits =3D le16_to_cpu(buf->CreditRequest);
> >> =C2=A0out:
> >> + =C2=A0 =C2=A0 atomic_add(credits, &ses->server->credits);
> >> =C2=A0 =C2=A0 =C2=A0 cifs_delete_mid(midQ);
> >> =C2=A0 =C2=A0 =C2=A0 wake_up(&ses->server->request_q);
> >> =C2=A0 =C2=A0 =C2=A0 return rc;
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index f7ac3f0..4414df8 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -287,7 +287,8 @@ cifs_wait_for_free_request(struct TCP_Server_I=
nfo *server, const int long_op)
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
> >> @@ -295,6 +296,16 @@ cifs_wait_for_free_request(struct TCP_Server_=
Info *server, const int long_op)
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
> >> @@ -305,8 +316,13 @@ cifs_wait_for_free_request(struct TCP_Server_=
Info *server, const int long_op)
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
> > I'd like to suggest an alternate approach here...
> >
> > Instead of considering this as a SMB1 vs. SMB2 either/or thing we
> > should consider the SMB1 case to be a special case of SMB2 credits.=
 In
> > the SMB1 NEGOTIATE response, the server sends us a MaxMpx value. We
> > could consider that to be an initial set of credits. Every time we =
get
> > a SMB1 response from the server, we'll increment the credit value.
> >
> > If we do that, then there's a lot less protocol dependent code that=
's
> > needed, and if done correctly should also fix the current bug in
> > the SMB1 code where it ignores the MaxMpx value.
> >
> > Thoughts?
>=20
> As the initial step, I suggest we can set credit value to
> cifs_max_pending  before negotiate and then decrement it for any
> out-coming request and increment for - incoming. Then we can change i=
t
> to 1 respect MaxMpx value.
>=20

Exactly!

That sounds like a nice, incremental approach. Doing things in small
steps like that is much better. It may take more steps to get there,
but it will pay off later. It also makes it easier to look for places
where the SMB1 architecture can be improved as you make these changes.

I'd also encourage you to look at the rest of the SMB2 patchset and see
where it can be broken up into smaller sets of patches. It's fine if
the fs isn't "feature complete" at the end of a set. You just want to
ensure that SMB1 still works after each set and the new pieces that
you've merged also work within expectations.

The main thing we *don't* want to do is merge a huge blob of SMB2 code,
have it break something and then be stuck trying to look through that
huge set of changes to figure out what broke...
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
