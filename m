From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Respect negotiated MaxMpxCount
Date: Wed, 21 Mar 2012 20:48:34 +0400
Message-ID: <CAKywueQMAxVByQArPFqDM45AQ3JKHE9wF4MXyuQ455AijYN02g@mail.gmail.com>
References: <1332237309-9586-1-git-send-email-piastry@etersoft.ru>
	<20120320063517.2de289cd@tlielax.poochiereds.net>
	<CAH2r5msK5W0Gp7QGe2U9U89_eXKrxaJO-8aiftKUmDfNS14_Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msK5W0Gp7QGe2U9U89_eXKrxaJO-8aiftKUmDfNS14_Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

20 =CD=C1=D2=D4=C1 2012=9A=C7. 18:52 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> I like this better than my earlier patch.
>
> I will try this in my test environment, but I don't have a Windows
> Vista system or VM configured at the moment. =9AAnyone have a WIndows
> Vista system to try this patch against? =9AIn particular large
> sequential file copy (cp of file 500MB or larger) to server with
> maxmpx 10 and maxworkitems at default value in the WIndows Vista
> registry.
>

tried it with ~400 MB file - everything went ok.

--=20
Best regards,
Pavel Shilovsky.
