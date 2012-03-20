From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: pull request
Date: Tue, 20 Mar 2012 09:35:11 -0500
Message-ID: <CAH2r5mur8BaRzEoHRgfD6-BbZ9XHDAo2n6o8rB2MN_rEPkgW=g@mail.gmail.com>
References: <CAKywueTDvzmHzwApV3gqSa4MrS-tPiWDORorDk0fe_NtgT_wZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTDvzmHzwApV3gqSa4MrS-tPiWDORorDk0fe_NtgT_wZA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks promising - will try to pull part of your and Jeff's requests in
next few days,
allow a little more time for my testing and for any more review feedbac=
k.

On Tue, Mar 20, 2012 at 6:30 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> The following changes since commit ce85852b90a214cf577fc1b4f49d99fd7e=
98784a:
>
> =A0CIFS: Fix a spurious error in cifs_push_posix_locks (2012-03-19
> 10:20:22 -0500)
>
> are available in the git repository at:
> =A0git://git.altlinux.org/people/piastry/public/cifs-2.6.git cifs-pat=
ches
>
> Pavel Shilovsky (17):
> =A0 =A0 =A0CIFS: Respect negotiated MaxMpxCount
> =A0 =A0 =A0CIFS: Simplify inFlight logic
> =A0 =A0 =A0CIFS: Introduce credit-based flow control
> =A0 =A0 =A0CIFS: Make wait_for_free_request killable
> =A0 =A0 =A0CIFS: Prepare credits code for a slot reservation
> =A0 =A0 =A0CIFS: Delete echo_retries module parm
> =A0 =A0 =A0CIFS: Separate protocol-specific code from transport routi=
nes
> =A0 =A0 =A0CIFS: Separate protocol-specific code from demultiplex cod=
e
> =A0 =A0 =A0CIFS: Separate protocol-specific code from cifs_readv_rece=
ive code
> =A0 =A0 =A0CIFS: Expand CurrentMid field
> =A0 =A0 =A0CIFS: Change mid_q_entry structure fields
> =A0 =A0 =A0CIFS: Move locks to file structure
> =A0 =A0 =A0CIFS: Fix VFS locks usage
> =A0 =A0 =A0CIFS: Convert lock type to 32 bit variable
> =A0 =A0 =A0CIFS: Separate protocol specific lock type handling
> =A0 =A0 =A0CIFS: Separate protocol specific part from getlk
> =A0 =A0 =A0CIFS: Separate protocol specific part from setlk
>
> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A06 +-
> =A0fs/cifs/cifs_debug.c | =A0 28 +++---
> =A0fs/cifs/cifs_debug.h | =A0 =A04 +-
> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 14 +--
> =A0fs/cifs/cifsglob.h =A0 | =A0 84 ++++++++++----
> =A0fs/cifs/cifsproto.h =A0| =A0 14 ++-
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0109 +++++++++++--------
> =A0fs/cifs/connect.c =A0 =A0| =A0129 +++++++++++-----------
> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A06 +-
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0254 ++++++++++++++++++++++++++++++=
------------
> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0117 ++++++++++++-------
> =A0fs/cifs/netmisc.c =A0 =A0| =A0 =A03 +-
> =A0fs/cifs/transport.c =A0| =A0305 ++++++++++++++++++++++++++++------=
----------------
> =A013 files changed, 651 insertions(+), 422 deletions(-)
>
>
> --
> Best regards,
> Pavel Shilovsky.



--=20
Thanks,

Steve
