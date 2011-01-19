From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: clean up some unaligned memory accesses
Date: Wed, 19 Jan 2011 17:20:09 +0300
Message-ID: <AANLkTinx+P-85HwT-VFz-y9dWcD2utZ=bdX4G2qoKzG=@mail.gmail.com>
References: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295382799-7902-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/18 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> When the CIFS client is marshalling a call or parsing a response from
> the server, it often will access fields within the packets directly.
> It's easily possible however that those fields will not be aligned
> properly. Many CPUs handle this transparently. Some CPUs (such as ia6=
4)
> throw a warning and then use a slow-path mechanism to deal with it.
> Other CPUs (mostly the embedded ones, it seems) actually throw an
> exception and just don't work.
>
> For more background on the problem, see this file in the kernel sourc=
e
> tree:
>
> =A0 =A0Documentation/unaligned-memory-access.txt
>
> This was originally reported quite some time ago here:
>
> =A0 =A0https://bugzilla.kernel.org/show_bug.cgi?id=3D11115
>
> I've also had a report of the same problem on ia64 against RHEL5:
>
> =A0 =A0https://bugzilla.redhat.com/show_bug.cgi?id=3D659715
>
> My patchset is based on the one originally by John Voltz. His propose=
d
> patch also patched up the generic NLS code for unaligned access, but =
I
> took a different approach by making sure that we just never called in=
to
> those routines with an unaligned buffer.
>
> I've tested this patchset on x86_64 and it seems to be fine. I've als=
o
> tested a version of this patchset backported to RHEL5 on ia64. Certai=
n
> tests would make that arch pop these sorts of printks:
>
> =A0 =A0kernel unaligned access to 0xe0000040ed16807f, ip=3D0xa0000002=
029b8530
>
> ...with this set, those are eliminated. I suspect that this may also
> help CIFS to work on some embedded arches as well (such as avr32).
>
> Note that this is likely not a comprehensive fix for CIFS though. It
> seems like there are a lot of places in cifssmb.c that access fields =
in
> the request or response directly. Any of them are probably also fair
> game for unaligned access fixes.
>
> I think this patchset is pretty safe, so we should consider getting i=
t
> into 2.6.38 if possible. If not, definitely for 2.6.39.
>
> Jeff Layton (5):
> =A0cifs: use get/put_unaligned functions to access ByteCount
> =A0cifs: clean up unaligned accesses in validate_t2
> =A0cifs: fix unaligned access in check2ndT2 and coalesce_t2
> =A0cifs: clean up unaligned accesses in cifs_unicode.c
> =A0cifs: fix unaligned accesses in cifsConvertToUCS
>
> =A0fs/cifs/cifs_unicode.c | =A0125 ++++++++++++++++++++++++++++++++++=
+++++--------
> =A0fs/cifs/cifspdu.h =A0 =A0 =A0| =A0 47 ++++++++++++++++--
> =A0fs/cifs/cifssmb.c =A0 =A0 =A0| =A0 52 ++++++++++----------
> =A0fs/cifs/connect.c =A0 =A0 =A0| =A0 43 +++++++---------
> =A0fs/cifs/misc.c =A0 =A0 =A0 =A0 | =A0 71 --------------------------=
-
> =A0fs/cifs/netmisc.c =A0 =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/sess.c =A0 =A0 =A0 =A0 | =A0 13 ++---
> =A0fs/cifs/transport.c =A0 =A0| =A0 =A09 ++--
> =A08 files changed, 202 insertions(+), 162 deletions(-)
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Jeff, I am not very comfortable in this area, but after investigating
the problem a little your patchset looks good to me. You can add my
this tag to all patches of the set: Acked-by: Pavel Shilovsky
<piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


--=20
Best regards,
Pavel Shilovsky.
