From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 08/13] cifs: handle cancelled requests better
Date: Tue, 14 Dec 2010 18:18:29 -0500
Message-ID: <20101214181829.0075c6c6@tlielax.poochiereds.net>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
	<1291995877-2276-9-git-send-email-jlayton@redhat.com>
	<AANLkTinU19tUL-6uwYN64dfE1Rsa+uSiC2fkeBHV+XOS@mail.gmail.com>
	<20101214065935.50a0bdf0@tlielax.poochiereds.net>
	<AANLkTi=mFXsJd55CzebrKO24ALnwmduBnFLyYZCRVdP4@mail.gmail.com>
	<AANLkTinSC4WKa4ZBeEOWkSQmy6wBhU8=cO09EKy2Qda2@mail.gmail.com>
	<20101214164407.377304e0@tlielax.poochiereds.net>
	<AANLkTimFQSeMk8ZCbAud+RdU5WQcGrDnKz+dAC_UFzNM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimFQSeMk8ZCbAud+RdU5WQcGrDnKz+dAC_UFzNM-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Dec 2010 16:22:01 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Dec 14, 2010 at 3:44 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Tue, 14 Dec 2010 15:33:48 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Why wouldn't we issue SMB NTCancel on these? =A0That way we only h=
ave to
> >> wait until the timeout for the NTCancel (at worst) and can't leak =
midq
> >> entries.
> >>
> >
> > I suppose we could, but...
> >
> > a) windows doesn't do it
>=20
> Windows does issue cancel requests ... even if not for exactly the sa=
me case
>=20

Hmm...maybe, but when I asked MS about timeout behavior, Edgar said thi=
s:

2) If it returns an error to the application, does the client send a
SMB_COM_NT_CANCEL to cancel the outstanding request?

Answer:
The client will not send a CANCEL request on any outstanding request;
it simply tears down the connection after the session times out.

=2E..he may have been talking about timeouts specifically however and n=
ot
about NT cancel commands in general.

Still, I'm a little leery of doing this. It adds complexity to an
already very complex codepath. It's also not going to be necessary in
most cases. Well behaved servers eventually send a reply of some sort. =
A
server that doesn't is broken. A MID that hangs around until reconnect
or unmount is probably the least of your worries in that situation.

But in principle, we could do it. There is a send_nt_cancel() command
in the code already and we could call it from this codepath. It'll be
tricky however as we'll have a signal pending and that affects
kernel_sendmsg behavior.

There's also the problem that we'll potentially block while trying to
send the cancel, which could make it so that you stall userspace out
while trying to kill off the process. Not ideal. Maybe we'll need to
send the cancel from another context entirely?

In any case, I'd really prefer to not do that in the context of
this set. It requires some careful thought about how to do it right,
and adds complexity that I don't think is needed at this point in time.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
