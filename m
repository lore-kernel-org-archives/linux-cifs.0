From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 00/17] Preparations before SMB2 protocol support
Date: Wed, 14 Mar 2012 07:52:14 -0400
Message-ID: <20120314075214.0328dc86@tlielax.poochiereds.net>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
	<20120312112010.1f5eb0ba@tlielax.poochiereds.net>
	<CAH2r5mt5H1-J18+Hy2res3ewf1bx9cs1FGnGfNsYG8Gh51GbaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mt5H1-J18+Hy2res3ewf1bx9cs1FGnGfNsYG8Gh51GbaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 13 Mar 2012 13:14:05 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Mar 12, 2012 at 10:20 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Sat, =C2=A03 Mar 2012 12:37:01 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> The goal of this patchset is to reorganize existing CIFS code to m=
ake it
> >> easily expandable when SMB2 specific code come into the tree. This=
 let us
> >> avoid a code dublication and reduce the whole number of changes co=
ming
> >> with SMB2 code.
> >>
> >> Pavel Shilovsky (17):
> >> =C2=A0 CIFS: Simplify inFlight logic
> >> =C2=A0 CIFS: Introduce credit-based flow control
> >> =C2=A0 CIFS: Count blocking lock command
> >> =C2=A0 CIFS: Delete echo_retries module parm
> >> =C2=A0 CIFS: Make wait_for_free_request killable
> >> =C2=A0 CIFS: Respect MaxMpxCount field
> >> =C2=A0 CIFS: Separate protocol-specific code from transport routin=
es
> >> =C2=A0 CIFS: Separate protocol-specific code from demultiplex code
> >> =C2=A0 CIFS: Separate protocol-specific code from cifs_readv_recei=
ve code
> >> =C2=A0 CIFS: Expand CurrentMid field
> >> =C2=A0 CIFS: Change mid_q_entry structure fields
> >
> > nit: It seems like the above patches ought to be one set and the lo=
wer
> > patches ought to be another. No objection to merging them both in 3=
=2E3,
> > however but it's generally easier to get small sets merged than big=
ger
> > ones.
> >
> >> =C2=A0 CIFS: Move locks to file structure
> >> =C2=A0 CIFS: Fix VFS locks usage
> >> =C2=A0 CIFS: Convert lock type to 32 bit variable
> >> =C2=A0 CIFS: Separate protocol specific lock type handling
> >> =C2=A0 CIFS: Separate protocol specific part from getlk
> >> =C2=A0 CIFS: Separate protocol specific part from setlk
> >>
> >> =C2=A0fs/cifs/README =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A06 +-
> >> =C2=A0fs/cifs/cifs_debug.c | =C2=A0 28 ++--
> >> =C2=A0fs/cifs/cifs_debug.h | =C2=A0 =C2=A04 +-
> >> =C2=A0fs/cifs/cifsfs.c =C2=A0 =C2=A0 | =C2=A0 18 ---
> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 | =C2=A0 98 +++++++++++----
> >> =C2=A0fs/cifs/cifsproto.h =C2=A0| =C2=A0 18 ++-
> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0| =C2=A0107 ++++++++++-------
> >> =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0| =C2=A0123 +++++++++--------=
--
> >> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A05 +-
> >> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0254 ++++++++++++=
++++++++++++++++-----------
> >> =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0152 ++++++++++++=
+++++-------
> >> =C2=A0fs/cifs/netmisc.c =C2=A0 =C2=A0| =C2=A0 =C2=A03 +-
> >> =C2=A0fs/cifs/transport.c =C2=A0| =C2=A0327 ++++++++++++++++++++++=
+++++++---------------------
> >> =C2=A013 files changed, 702 insertions(+), 441 deletions(-)
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> > I like this set overall, but we obviously have some unanswered
> > questions about SMB1 behavior.
> >
> > Here's what I'd suggest for 3.3:
> >
> > Let's plan to take this patchset or something very similar to it, b=
ut
> > do it in such a way that we do substantially alter the SMB1 behavio=
r
> > yet. IOW, integrate the existing behavior of the SMB1 code into thi=
s
> > patchset.
> >
> > You should be fine to change the echo behavior and get rid of
> > echo_retries. What we don't want to change yet is the behavior of
> > blocking locks, oplock breaks, etc...
> >
> > Once we have a clearer picture of how we want the SMB1 code to beha=
ve,
> > we can then do a (hopefully small) set of patches to change the SMB=
1
> > behavior for the better.
> >
> > Does that sound reasonable?
>=20
> If we can get agreement on a simple patch to block outgoing requests =
at
> maxmpx (similar to earlier patch) which would be suitable for stable
> and address the Windows Vista/7 client (running as a server) - that
> would make sense to consider separately.  For that
> patch we would avoid the complexity of touching blocking lock behavio=
r.
>=20
>=20

That sounds reasonable. Basically I think we ought to try to introduce
this new code with no or only minimal behavior changes. Once that's in
place, then do another patchset that changes the behavior in
well-defined ways. If we do it that way, we're less likely to end up
with a difficult to track down regression.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
