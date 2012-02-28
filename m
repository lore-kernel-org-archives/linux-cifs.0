From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 03/11] CIFS: Count blocking lock command
Date: Tue, 28 Feb 2012 13:40:38 +0400
Message-ID: <CAKywueT8aEfn6fQ2zKm-paGpxJCe_hU=4OA+L3MB7z80pKd6xA@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-4-git-send-email-piastry@etersoft.ru>
	<CAH2r5mujUbTEe0xtk_sfM1xokCk7FnX=6JKO539ut88Z+RS7wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mujUbTEe0xtk_sfM1xokCk7FnX=6JKO539ut88Z+RS7wA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/28 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I don't think we can do this for the cifs case - 49 blocking locks an=
d
> we would deadlock our system (a pending write could block forever) -
> for smb2.2 it makes more sense. =A0I don't think it actually causes a
> problem to exceed 50 blocks locks - but if we want to count blocking
> locks we will have to limit the maximum number of blocking locks to 2
> or 3 less than maxmpx and not allow blocking locks if maxmpx is lower
> than 3.
>

Seems reasonable. We can easy add such a check to now exceed maxmpx - 3=
 value.

--=20
Best regards,
Pavel Shilovsky.
