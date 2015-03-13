From: Franck Eyraud <franck+linux-cifs-ici3nDnK79kZQKRGMNo+Zg@public.gmane.org>
Subject: Re: DFS referrals support ?
Date: Fri, 13 Mar 2015 17:07:11 +0100
Message-ID: <55030B2F.5090507@nospam.yrnm.net>
References: <548AD6D5.7080901@nospam.yrnm.net> <dda8f4838ed40871acc3092c5440d396.squirrel@mail.balsover.com> <548C086C.8050102@nospam.yrnm.net> <CAH2r5mtOtmhEMgGOq22fy-RQa58c+u=JWwfGOvXh83MyZwb4og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtOtmhEMgGOq22fy-RQa58c+u=JWwfGOvXh83MyZwb4og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Le 09/01/2015 20:51, Steve French a =C3=A9crit :
> What did you find out about behavior of a more current kernel? (given=
=20
> that your kernel was more than 5 years old, there is a good chance=20
> that the behavior has improved in more recent kernels)
Sorry for long delay answer, but this issue was put aside as not=20
critical (first choice to access the filer from Linux clients is NFS).=20
Unfortunately we could not for technical/schedule reasons test other=20
kernels.
However, it seems that after a recent upgrade on the NetApp filer to=20
OnTap 8.2.3 this behaviour disappeared from all our systems. So it seem=
s=20
a case of faulty server, and not linked to Linux CIFS client.

Have a good day, and thanks for support.

=46ranck
