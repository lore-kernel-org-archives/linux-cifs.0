From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs, freezer: add wait_event_freezekillable and
 have cifs use it
Date: Thu, 29 Sep 2011 06:41:19 -0400
Message-ID: <20110929064119.160cb455@corrin.poochiereds.net>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
	<1317210761-11518-3-git-send-email-jlayton@redhat.com>
	<CAH2r5mtBwUkTXLQeXzvTC6oAcz1i9jzPGfiE7XTzDTw12A6C_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org,
	linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-HpsXz0BELY4AvxtiuMwx3w@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtBwUkTXLQeXzvTC6oAcz1i9jzPGfiE7XTzDTw12A6C_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Sep 2011 23:28:02 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> The general idea of the patch seems like a good idea to
> me.  Assuming testing feedback was good from the problem
> reporters, what tree would you want it merged from?
>=20

There's the rub -- this requires a number of changes in different
areas. What I really need at this point is a verdict on patch #1. If
that looks OK, then that should probably go in via the one of the
linux-pm trees. Then patch #2 can probably go in via your tree and 3
and 4 can go in via Trond's.

However, none of this should go in unless #1 is ok. Make sense?

> On Wed, Sep 28, 2011 at 6:52 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > CIFS currently uses wait_event_killable to put tasks to sleep while
> > they await replies from the server. That function though does not
> > allow the freezer to run. In many cases, the network interface may
> > be going down anyway, in which case the reply will never come. The
> > client then ends up blocking the computer from suspending.
> >
> > Fix this by adding a new wait_event_freezable variant --
> > wait_event_freezekillable. The idea is to combine the behavior of
> > wait_event_killable and wait_event_freezable -- put the task to
> > sleep and only allow it to be awoken by fatal signals, but also
> > allow the freezer to do its job.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/transport.c =C2=A0 =C2=A0 | =C2=A0 =C2=A03 ++-
> > =C2=A0include/linux/freezer.h | =C2=A0 19 +++++++++++++++++--
> > =C2=A02 files changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 10ca6b2..791bc4f 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -26,6 +26,7 @@
> > =C2=A0#include <linux/wait.h>
> > =C2=A0#include <linux/net.h>
> > =C2=A0#include <linux/delay.h>
> > +#include <linux/freezer.h>
> > =C2=A0#include <asm/uaccess.h>
> > =C2=A0#include <asm/processor.h>
> > =C2=A0#include <linux/mempool.h>
> > @@ -324,7 +325,7 @@ wait_for_response(struct TCP_Server_Info *serve=
r, struct mid_q_entry *midQ)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int error;
> >
> > - =C2=A0 =C2=A0 =C2=A0 error =3D wait_event_killable(server->respon=
se_q,
> > + =C2=A0 =C2=A0 =C2=A0 error =3D wait_event_freezekillable(server->=
response_q,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0midQ->midState =
!=3D MID_REQUEST_SUBMITTED);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (error < 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ERES=
TARTSYS;
> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > index 1effc8b..3672f73 100644
> > --- a/include/linux/freezer.h
> > +++ b/include/linux/freezer.h
> > @@ -134,10 +134,25 @@ static inline void set_freezable_with_signal(=
void)
> > =C2=A0}
> >
> > =C2=A0/*
> > - * Freezer-friendly wrappers around wait_event_interruptible() and
> > - * wait_event_interruptible_timeout(), originally defined in <linu=
x/wait.h>
> > + * Freezer-friendly wrappers around wait_event_interruptible(),
> > + * wait_event_killable() and wait_event_interruptible_timeout(), o=
riginally
> > + * defined in <linux/wait.h>
> > =C2=A0*/
> >
> > +#define wait_event_freezekillable(wq, condition) =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> > +({ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> > + =C2=A0 =C2=A0 =C2=A0 int __retval; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
\
> > + =C2=A0 =C2=A0 =C2=A0 do { =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __retval =3D wai=
t_event_killable(wq, =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (condition) || freezing(current)=
); =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__retval && =
!freezing(current)) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 \
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (!(condi=
tion)) =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 __retval =3D -ERESTARTSYS; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 } while (try_to_freeze()); =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\
> > + =C2=A0 =C2=A0 =C2=A0 __retval; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 \
> > +})
> > +
> > =C2=A0#define wait_event_freezable(wq, condition) =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0\
> > =C2=A0({ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int __retval; =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 \
> > --
> > 1.7.6.2
> >
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
