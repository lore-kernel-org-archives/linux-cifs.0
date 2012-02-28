From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] CIFS: Simplify inFlight logic
Date: Tue, 28 Feb 2012 06:31:20 -0500
Message-ID: <20120228063120.76265cd9@tlielax.poochiereds.net>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-2-git-send-email-piastry@etersoft.ru>
	<CAH2r5msNLEF9qVvKsTVTUnPyUjk+7iYVJTxZgd_uuXLAE0iyRg@mail.gmail.com>
	<CAKywueQNFbwDqwr7adWsUZmaYX28tz3kYnL1=4itBHAFV1aeaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQNFbwDqwr7adWsUZmaYX28tz3kYnL1=4itBHAFV1aeaA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 28 Feb 2012 13:38:46 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > I got a chance to look through this patch set in more detail on the=
 way
> > to the SMB2.2 test event. =C2=A0I liked many of the patches, but th=
is one
> > seems to complicate, rather than simplify by adding a spinlock
> > to what used to be an atomic_inc. =C2=A0There is also a possibility=
 that this
> > spinlock will become hot. =C2=A0I don't mind moving the atomic_inc =
inside the
> > new dec_in_flight macro though to make it easier in the future.
> >
>=20
> The idea was to simplify the usage of inFlight value. Now it is
> protected by both spin_lock and atomic mechanism in one case and with
> only atomic in another -  I think it's rather complicated. The patch
> gets rid of one of the protection mechanism (atomic) and use only
> spin_lock - this spin_lock is used further for protecting oplock and
> echo specific variables as well.
>=20

The problem here is that the locking around this variable is unclear:

If you need a spinlock to access/change it, then why use an atomic? If
an atomic is sufficient then why use the spinlock at all?

I don't much care what scheme you end up using for this, but if you
really need a belt-and-suspenders approach (atomic + spinlock), then
the reasoning for it needs to be clearly documented. We mere mortals
must understand how it's supposed to work so we don't break it later.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
