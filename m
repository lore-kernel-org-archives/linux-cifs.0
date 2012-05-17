From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] Move protocol specific transport code to ops struct
Date: Thu, 17 May 2012 11:16:00 -0500
Message-ID: <CAH2r5mun0=CeQZjBQrSQP9CWu-P82azdg9KiBn_kgPdzvSifVg@mail.gmail.com>
References: <1337269424-9494-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337269424-9494-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

These look reasonable to me.  Let me know if any objections.

On Thu, May 17, 2012 at 10:43 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>=
 wrote:
> Here is yet another patchset that is targeted to make existing cifs c=
ode
> more protocol independent and let us add new protocols easily further=
=2E
>
> It can be merge as soons as got reviewed and ok for 3.5.
>
> Pavel Shilovsky (5):
> =A0CIFS: Move protocol specific part from SendReceive2 to ops struct
> =A0CIFS: Move header_size/max_header_size to ops structure
> =A0CIFS: Move protocol specific part from cifs_readv_receive to ops
> =A0 =A0struct
> =A0CIFS: Move protocol specific demultiplex thread calls to ops struc=
t
> =A0CIFS: Move add/set_credits and get_credits_field to ops structure
>
> =A0fs/cifs/cifsglob.h =A0| =A0 45 +++++++++++++++++++----------
> =A0fs/cifs/cifsproto.h | =A0 =A05 +--
> =A0fs/cifs/cifssmb.c =A0 | =A0 39 ++++++-------------------
> =A0fs/cifs/connect.c =A0 | =A0 44 ++++++++--------------------
> =A0fs/cifs/misc.c =A0 =A0 =A0| =A0 19 ------------
> =A0fs/cifs/smb1ops.c =A0 | =A0 78 +++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A0fs/cifs/transport.c | =A0 10 ++++--
> =A07 files changed, 138 insertions(+), 102 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
