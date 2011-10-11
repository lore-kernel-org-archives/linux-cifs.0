From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] cifs: cleanup and overhaul of the receive codepath
 (try #2)
Date: Tue, 11 Oct 2011 14:09:38 +0400
Message-ID: <CAKywueTByfFjDkMP8x5A8EJktqfKitbdipofujqJCwC5MknEuw@mail.gmail.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
	<CAKywueRCK+sw=GHBVn-mWe_Z1aWCH6uW=e=5MX7NNPY8Kum9tw@mail.gmail.com>
	<CAKywueSboCYDxOF2a=Q0eLsKwWuai6BU5mnzAt_C_vjFkhSufw@mail.gmail.com>
	<20111004070058.7d3cf2bf@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111004070058.7d3cf2bf-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/4 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 4 Oct 2011 13:04:19 +0400
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2011/8/27 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> > 2011/8/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> >> This patchset does a fairly major cleanup and overhaul of the rec=
eive
>> >> codepath for cifs. Aside from basic cleanup, there are two main g=
oals:
>> >>
>> >> 1) allow the receive codepath to identify the mid before receivin=
g all
>> >> of the data for a particular SMB.
>> >>
>> >> ...and in turn...
>> >>
>> >> 2) add the ability for certain calls to receive their responses i=
nto
>> >> their into their own set of buffers.
>> >>
>> >> These two changes allow cifs to break the CIFSMaxBufSize barrier =
for
>> >> receives. This patchset just adds the necessary infrastructure to=
 do
>> >> the above.
>> >>
>> >> A separate patchset will follow that will overhaul cifs_readpages=
 to use
>> >> this infrastructure to allow for a larger rsize.
>> >>
>> >> Jeff Layton (16):
>> >> =A0cifs: clean up checkSMB
>> >> =A0cifs: consolidate signature generating code
>> >> =A0cifs: trivial: remove obsolete comment
>> >> =A0cifs: make smb_msg local to read_from_socket
>> >> =A0cifs: check for unresponsive server every time we call kernel_=
recvmsg
>> >> =A0cifs: simplify read_from_socket
>> >> =A0cifs: turn read_from_socket into a wrapper around a vectorized
>> >> =A0 =A0version
>> >> =A0cifs: keep a reusable kvec array for receives
>> >> =A0cifs: clean up check_rfc1002_header
>> >> =A0cifs: add a third receive phase to cifs_demultiplex_thread
>> >> =A0cifs: move mid finding into separate routine
>> >> =A0cifs: eliminate is_multi_rsp parm to find_cifs_mid
>> >> =A0cifs: move buffer pointers into TCP_Server_Info
>> >> =A0cifs: find mid earlier in receive codepath
>> >> =A0cifs: break out 3rd receive phase into separate function
>> >> =A0cifs: add a callback function to receive the rest of the frame
>> >>
>> >> =A0fs/cifs/cifsencrypt.c | =A0103 ++--------
>> >> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 29 +++-
>> >> =A0fs/cifs/cifsproto.h =A0 | =A0 =A07 +-
>> >> =A0fs/cifs/cifssmb.c =A0 =A0 | =A0 =A05 +-
>> >> =A0fs/cifs/connect.c =A0 =A0 | =A0519 +++++++++++++++++++++++++++=
+---------------------
>> >> =A0fs/cifs/misc.c =A0 =A0 =A0 =A0| =A0 51 +++---
>> >> =A0fs/cifs/transport.c =A0 | =A0 16 +-
>> >> =A07 files changed, 391 insertions(+), 339 deletions(-)
>> >>
>> >> --
>> >> 1.7.6
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-c=
ifs" in
>> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> >>
>> >
>> > The patchset looks good to me at the first glance. I am going to l=
ook
>> > at this more carefully and test it in a few days.
>> >
>> > --
>> > Best regards,
>> > Pavel Shilovsky.
>> >
>>
>> Sorry for the long delay on this. As patchwork.kernel.org isn't
>> available now, can you point me to public git repo, where I can fetc=
h
>> that changes, please?
>>
>
>
> Yes, I've moved my git repo to samba.org for the time being:
>
> http://git.samba.org/?p=3Djlayton/linux.git;a=3Dsummary
>
> See the "cifs-3.2" branch.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

I successfully tested this - the performance was closed to write one
in my case - about 11.5 MB on 100Mbit LAN against Windows 7 server.
Seems like a very good work!

--=20
Best regards,
Pavel Shilovsky.
