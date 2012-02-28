From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 01/11] CIFS: Simplify inFlight logic
Date: Tue, 28 Feb 2012 13:38:46 +0400
Message-ID: <CAKywueQNFbwDqwr7adWsUZmaYX28tz3kYnL1=4itBHAFV1aeaA@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

The idea was to simplify the usage of inFlight value. Now it is
protected by both spin_lock and atomic mechanism in one case and with
only atomic in another -  I think it's rather complicated. The patch
gets rid of one of the protection mechanism (atomic) and use only
spin_lock - this spin_lock is used further for protecting oplock and
echo specific variables as well.

--=20
Best regards,
Pavel Shilovsky.
