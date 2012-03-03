From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 01/11] CIFS: Simplify inFlight logic
Date: Sat, 3 Mar 2012 13:33:25 +0400
Message-ID: <CAKywueT-Hn_o_eqW2k0xgxMv50V59XFEqm7xDA0S9VpG6_21JQ@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I got a chance to look through this patch set in more detail on the w=
ay
> to the SMB2.2 test event. =A0I liked many of the patches, but this on=
e
> seems to complicate, rather than simplify by adding a spinlock
> to what used to be an atomic_inc. =A0There is also a possibility that=
 this
> spinlock will become hot. =A0I don't mind moving the atomic_inc insid=
e the
> new dec_in_flight macro though to make it easier in the future.
>

I tested the performance with and without this patch with dbench 3.
The variant with the patch is slightly worse (~1%). So, seems no
problem with this approach because we need to spinlock echo/oplock
specific variables anyway further.

--=20
Best regards,
Pavel Shilovsky.
