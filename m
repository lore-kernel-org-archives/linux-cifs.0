From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs, freezer: add wait_event_freezekillable and
 have cifs use it
Date: Thu, 29 Sep 2011 13:29:00 -0400
Message-ID: <20110929132900.47a7aa40@barsoom.rdu.redhat.com>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
	<1317210761-11518-3-git-send-email-jlayton@redhat.com>
	<CAH2r5mtBwUkTXLQeXzvTC6oAcz1i9jzPGfiE7XTzDTw12A6C_Q@mail.gmail.com>
	<20110929064119.160cb455@corrin.poochiereds.net>
	<CAH2r5ms8pg7VW7JMa_eCUomEC1cfiM+rG_JZ6F7cHB=MtZwF0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: trond.myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org,
	linux-pm-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-HpsXz0BELY4AvxtiuMwx3w@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms8pg7VW7JMa_eCUomEC1cfiM+rG_JZ6F7cHB=MtZwF0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 29 Sep 2011 11:39:53 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Sep 29, 2011 at 5:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Wed, 28 Sep 2011 23:28:02 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> The general idea of the patch seems like a good idea to
> >> me. =C2=A0Assuming testing feedback was good from the problem
> >> reporters, what tree would you want it merged from?
> >>
> >
> > There's the rub -- this requires a number of changes in different
> > areas. What I really need at this point is a verdict on patch #1. I=
f
> > that looks OK, then that should probably go in via the one of the
> > linux-pm trees. Then patch #2 can probably go in via your tree and =
3
> > and 4 can go in via Trond's.
>=20
> Yes - makes sense, but wonder about ways to test the various
> suspend/hibernate cases to make sure they work.
>=20

I think this set is unlikely to hurt anything (assuming of course that
waking up TASK_KILLABLE tasks on suspend events is OK). It's possible
that there are other places that need to be patched in the same way,
but this seems to cover the main pain points that people have reported.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
