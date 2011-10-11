From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/16] cifs: cleanup and overhaul of the receive
 codepath (try #2)
Date: Tue, 11 Oct 2011 06:34:57 -0400
Message-ID: <20111011063457.018504f0@tlielax.poochiereds.net>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
	<CAKywueRCK+sw=GHBVn-mWe_Z1aWCH6uW=e=5MX7NNPY8Kum9tw@mail.gmail.com>
	<CAKywueSboCYDxOF2a=Q0eLsKwWuai6BU5mnzAt_C_vjFkhSufw@mail.gmail.com>
	<20111004070058.7d3cf2bf@tlielax.poochiereds.net>
	<CAKywueTByfFjDkMP8x5A8EJktqfKitbdipofujqJCwC5MknEuw@mail.gmail.com>
	<CAKywueT3irL0zebNrxa_ErPLbT6NMgELos9e6dTe-0iPM4gz6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueT3irL0zebNrxa_ErPLbT6NMgELos9e6dTe-0iPM4gz6A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 14:16:36 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/10/11 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > 2011/10/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >> On Tue, 4 Oct 2011 13:04:19 +0400
> >> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >>
> >>> 2011/8/27 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> >>> > 2011/8/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> >>> >> This patchset does a fairly major cleanup and overhaul of the =
receive
> >>> >> codepath for cifs. Aside from basic cleanup, there are two mai=
n goals:
> >>> >>
> >>> >> 1) allow the receive codepath to identify the mid before recei=
ving all
> >>> >> of the data for a particular SMB.
> >>> >>
> >>> >> ...and in turn...
> >>> >>
> >>> >> 2) add the ability for certain calls to receive their response=
s into
> >>> >> their into their own set of buffers.
> >>> >>
> >>> >> These two changes allow cifs to break the CIFSMaxBufSize barri=
er for
> >>> >> receives. This patchset just adds the necessary infrastructure=
 to do
> >>> >> the above.
> >>> >>
> >>> >> A separate patchset will follow that will overhaul cifs_readpa=
ges to use
> >>> >> this infrastructure to allow for a larger rsize.
> >>> >>
> >>> >> Jeff Layton (16):
> >>> >> =C2=A0cifs: clean up checkSMB
> >>> >> =C2=A0cifs: consolidate signature generating code
> >>> >> =C2=A0cifs: trivial: remove obsolete comment
> >>> >> =C2=A0cifs: make smb_msg local to read_from_socket
> >>> >> =C2=A0cifs: check for unresponsive server every time we call k=
ernel_recvmsg
> >>> >> =C2=A0cifs: simplify read_from_socket
> >>> >> =C2=A0cifs: turn read_from_socket into a wrapper around a vect=
orized
> >>> >> =C2=A0 =C2=A0version
> >>> >> =C2=A0cifs: keep a reusable kvec array for receives
> >>> >> =C2=A0cifs: clean up check_rfc1002_header
> >>> >> =C2=A0cifs: add a third receive phase to cifs_demultiplex_thre=
ad
> >>> >> =C2=A0cifs: move mid finding into separate routine
> >>> >> =C2=A0cifs: eliminate is_multi_rsp parm to find_cifs_mid
> >>> >> =C2=A0cifs: move buffer pointers into TCP_Server_Info
> >>> >> =C2=A0cifs: find mid earlier in receive codepath
> >>> >> =C2=A0cifs: break out 3rd receive phase into separate function
> >>> >> =C2=A0cifs: add a callback function to receive the rest of the=
 frame
> >>> >>
> >>> >> =C2=A0fs/cifs/cifsencrypt.c | =C2=A0103 ++--------
> >>> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 =C2=A0| =C2=A0 29 +++-
> >>> >> =C2=A0fs/cifs/cifsproto.h =C2=A0 | =C2=A0 =C2=A07 +-
> >>> >> =C2=A0fs/cifs/cifssmb.c =C2=A0 =C2=A0 | =C2=A0 =C2=A05 +-
> >>> >> =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0 | =C2=A0519 ++++++++++++=
++++++++++++++++---------------------
> >>> >> =C2=A0fs/cifs/misc.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 51 ++=
+---
> >>> >> =C2=A0fs/cifs/transport.c =C2=A0 | =C2=A0 16 +-
> >>> >> =C2=A07 files changed, 391 insertions(+), 339 deletions(-)
> >>> >>
> >>> >> --
> >>> >> 1.7.6
> >>> >>
> >>> >> --
> >>> >> To unsubscribe from this list: send the line "unsubscribe linu=
x-cifs" in
> >>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-=
info.html
> >>> >>
> >>> >
> >>> > The patchset looks good to me at the first glance. I am going t=
o look
> >>> > at this more carefully and test it in a few days.
> >>> >
> >>> > --
> >>> > Best regards,
> >>> > Pavel Shilovsky.
> >>> >
> >>>
> >>> Sorry for the long delay on this. As patchwork.kernel.org isn't
> >>> available now, can you point me to public git repo, where I can f=
etch
> >>> that changes, please?
> >>>
> >>
> >>
> >> Yes, I've moved my git repo to samba.org for the time being:
> >>
> >> http://git.samba.org/?p=3Djlayton/linux.git;a=3Dsummary
> >>
> >> See the "cifs-3.2" branch.
> >>
> >> --
> >> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>
> >
> > I successfully tested this - the performance was closed to write on=
e
> > in my case - about 11.5 MB on 100Mbit LAN against Windows 7 server.
>=20
> Sorry for the type - "about 11.5 MB/s"
>=20
> > Seems like a very good work!
> >

Thanks for testing them! That's about what I get too. Working against
samba is much faster since we can negotiate a much larger rsize/wsize.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
