From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/10] Prepare transport code for future SMB2 usage
Date: Wed, 21 Mar 2012 11:56:56 -0500
Message-ID: <CAH2r5msWwAPVqaWrX-aE3AQXDXUb06Q8yeRSHPwutvrMefQBOA@mail.gmail.com>
References: <1332237640-10145-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332237640-10145-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged first five.  Reviewing the others.

On Tue, Mar 20, 2012 at 5:00 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> The goal of this patchset is to reorganize existing CIFS code to make=
 it
> easily expandable when SMB2 specific code come into the tree. This le=
t us
> avoid a code dublication and reduce the whole number of changes comin=
g
> with SMB2 code.
>
> This should be applied on top of "Respect negotiated MaxMpxCount" pat=
ch that
> goes alone.
>
> Pavel Shilovsky (10):
> =A0CIFS: Simplify inFlight logic
> =A0CIFS: Introduce credit-based flow control
> =A0CIFS: Make wait_for_free_request killable
> =A0CIFS: Prepare credits code for a slot reservation
> =A0CIFS: Delete echo_retries module parm
> =A0CIFS: Separate protocol-specific code from transport routines
> =A0CIFS: Separate protocol-specific code from demultiplex code
> =A0CIFS: Separate protocol-specific code from cifs_readv_receive code
> =A0CIFS: Expand CurrentMid field
> =A0CIFS: Change mid_q_entry structure fields
>
> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A06 +-
> =A0fs/cifs/cifs_debug.c | =A0 28 +++---
> =A0fs/cifs/cifs_debug.h | =A0 =A04 +-
> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A05 -
> =A0fs/cifs/cifsglob.h =A0 | =A0 69 ++++++++++--
> =A0fs/cifs/cifsproto.h =A0| =A0 14 ++-
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0104 ++++++++++--------
> =A0fs/cifs/connect.c =A0 =A0| =A0126 +++++++++++----------
> =A0fs/cifs/misc.c =A0 =A0 =A0 | =A0117 ++++++++++++-------
> =A0fs/cifs/netmisc.c =A0 =A0| =A0 =A03 +-
> =A0fs/cifs/transport.c =A0| =A0305 ++++++++++++++++++++++++++++------=
----------------
> =A011 files changed, 451 insertions(+), 330 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
